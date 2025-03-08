import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state.dart';
import '../utils/dialogs.dart';
import '../utils/swatches.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key, required this.appState}) : super(key: key);

  final AppState appState;

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  // dimming
  RestartableTimer? timerDimming;
  bool _visible = true;
  set visible(bool value) {
    setState(() => _visible = value);
  }

  void checkDimming() {
    if (widget.appState.on) visible = false;
  }

  // blinking

  @override
  void initState() {
    super.initState();
    widget.appState.updateScreen = updateScreen; // circular link: screenState <--> appState
    timerDimming = RestartableTimer(const Duration(seconds: 3), checkDimming);
  }

  void updateScreen() {
    setState(() {});
  }

  void resetDimming() {
    visible = true;
    timerDimming?.reset();
  }

  void onToggle() {
    widget.appState.toggle();
    resetDimming();
  }

  void setStrobe(double value) {
    widget.appState.strobe = value.toInt();
    resetDimming();
  }

  void setSwatch(int value) {
    widget.appState.swatch = value.toInt();
    resetDimming();
  }

  void setBrightness(double value) {
    widget.appState.brightness = value.toInt();
    resetDimming();
  }

  void toggleTorch() {
    widget.appState.toggleTorch();
    resetDimming();
  }

  void toggleScreen() {
    widget.appState.toggleScreen();
    resetDimming();
  }

  void toggleVibrate() {
    widget.appState.toggleVibrate();
    resetDimming();
  }

  void showAboutDialog() {
    showDialog(context: context, builder: buildAboutDialog);
    resetDimming();
  }

  Widget _buildButtonFeedback(bool on, String basename, String caption, Function()? func) {
    var state = widget.appState;
    return InkResponse(
        radius: 32,
        onTap: func,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Column(children: [
              Image.asset(
                'assets/icons/${basename}-${on ? 'on' : 'off'}.png',
                color: on ? state.colorActive : state.colorInactive,
                height: 64,
                width: 64,
              ),
              Text(caption, style: TextStyle(color: state.colorActive)),
            ])));
  }

  Widget buildHeader() {
    var state = widget.appState;
    var titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: state.colorActive);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkResponse(
            radius: 32,
            onTap: showAboutDialog,
            child: Center(child: Text('Flashlight', style: titleStyle))),
        InkResponse(
            radius: 64,
            onTap: onToggle,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: Image.asset(
                  'assets/icons/power-${state.on ? 'on' : 'off'}.png',
                  color: state.on ? state.colorActive : state.colorInactive,
                  height: 92,
                ))),
        InkResponse(
            radius: 32,
            onTap: showAboutDialog,
            child: Center(child: Text('Torcher', style: titleStyle))),
      ],
    );
  }

  Widget _buildSwatch(BuildContext context, int index) {
    var state = widget.appState;
    var baseColor = Swatches.all[index];
    var borderColor = Swatches.all[index][900]!;
    return InkResponse(
        radius: 32,
        onTap: () => setSwatch(index),
        child: Container(
          decoration: BoxDecoration(
              color: baseColor,
              border: Border.all(color: state.swatch == index ? borderColor : baseColor, width: 8),
              shape: BoxShape.circle),
        ));
  }

  Widget buildSwatchChooser() {
    const double swatchSize = 56.0;
    const double swatchExtent = swatchSize + 4;
    final ctrl = ScrollController(initialScrollOffset: widget.appState.swatch * swatchExtent);
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SizedBox(
            height: swatchSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Swatches.all.length,
              itemBuilder: _buildSwatch,
              itemExtent: swatchExtent,
              controller: ctrl,
            )));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    var state = widget.appState;

    // strobe
    var strobeSlider = SliderTheme(
        data: SliderTheme.of(context).copyWith(trackHeight: 8),
        child: Slider(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            activeColor: state.colorActive,
            inactiveColor: state.colorInactive,
            min: 0.0,
            max: state.strobeMax.toDouble(),
            divisions: state.strobeMax.toInt(),
            value: state.strobe.toDouble(),
            onChanged: setStrobe));
    var strobeText = Text(state.strobeHzText, style: TextStyle(color: state.colorActive));

    // brightness
    var brightnessSlider = SliderTheme(
        data: SliderTheme.of(context).copyWith(trackHeight: 8),
        child: Slider(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            activeColor: state.colorActive,
            inactiveColor: state.colorInactive,
            min: 0,
            max: 9,
            divisions: 9,
            value: state.brightness.toDouble(),
            onChanged: setBrightness));
    var brightnessText = Text("Screen brightness: ${state.brightnessPercent} %",
        style: TextStyle(color: state.colorActive));

    // feedback
    var feedbackChooser = Wrap(
      spacing: 3.0,
      children: [
        _buildButtonFeedback(state.torchOn, 'torch', 'Torch', state.hasTorch ? toggleTorch : null),
        _buildButtonFeedback(state.screenOn, 'screen', 'Screen', toggleScreen),
        _buildButtonFeedback(
            state.vibrateOn, 'vibrate', 'Vibrate', state.hasVibrator ? toggleVibrate : null),
        // _buildButtonFeedback('Sound', widget.appState.soundOn, widget.appState.toggleSound),
      ],
    );

    return Scaffold(
        // appBar: AppBar(title: Text('Flashlight Torcher')),
        backgroundColor: state.colorScreen,
        body: TapRegion(
            onTapInside: (_) => resetDimming(),
            onTapOutside: (_) => resetDimming(),
            child: AnimatedOpacity(
                opacity: _visible ? 1 : 0.05,
                duration: _visible ? const Duration(milliseconds: 300) : const Duration(seconds: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    feedbackChooser,
                    const SizedBox(height: 20),
                    strobeText,
                    strobeSlider,
                    Expanded(child: Center()),
                    buildHeader(),
                    Expanded(child: Center()),
                    brightnessSlider,
                    brightnessText,
                    buildSwatchChooser(),
                    const SizedBox(height: 20),
                  ],
                ))));
  }
}
