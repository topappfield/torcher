import 'package:flutter/material.dart';
import 'package:torcher/pages/screen.dart';
import 'package:torcher/state.dart';
import 'package:torcher/utils/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/editswatch.dart';
import '../utils/swatches.dart';

void launchWeb(String url) async {
  final Uri uri = Uri.parse(url);
  await launchUrl(uri);
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.appState, required this.screenState}) : super(key: key);

  final AppState appState;
  final ScreenState screenState;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Color activeButtonColor = Colors.blue[600]!;
  final Color inactiveButtonColor = Colors.blue[200]!;

  Widget _buildButtonDelay(int delay, String text) {
    int d = widget.appState.strobeDelay;
    return FractionallySizedBox(
      widthFactor: 0.1,
      child: ElevatedButton(
        child: Text(text),
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(0),
          primary: d == delay ? activeButtonColor : inactiveButtonColor,
        ),
        onPressed: () => setState(() => widget.appState.strobeDelay = delay),
      ),
    );
  }

  Widget _buildButtonFeedback(String caption, bool state, Function()? func) {
    return ElevatedButton(
      child: Text(caption),
      style: ElevatedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        primary: state ? activeButtonColor : inactiveButtonColor,
      ),
      onPressed: func != null ? () => setState(func) : null,
    );
  }

  Widget buildTitle(String title) {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue);
    return Expanded(
      flex: 2,
      child: InkWell(
          onTap: () => showDialog(context: context, builder: buildAboutDialog),
          child: Center(child: Text(title, style: textStyle))),
    );
  }

  Widget buildFooter() {
    const textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue);
    return Expanded(
      flex: 2,
      child: InkWell(
          onTap: () => launchWeb('https://play.google.com/store/apps/dev?id=5830013704268208202'),
          child: const Center(child: Text('See all TopAppField apps ...', style: textStyle))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onoff = IconButton(
        icon: widget.appState.on
            ? const Icon(Icons.radio_button_on, size: 100)
            : const Icon(Icons.radio_button_off, size: 100),
        iconSize: 120,
        onPressed: () => setState(widget.appState.toggle));
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(children: [
            buildTitle('Flashlight'),
            Expanded(flex: 1, child: onoff),
            buildTitle('Torcher')
          ]),
          const Text('Blinks per second'),
          Wrap(spacing: 2.0, children: [
            _buildButtonDelay(0, '0'),
            _buildButtonDelay(1000, '1/2'),
            _buildButtonDelay(500, '1'),
            _buildButtonDelay(250, '2'),
            _buildButtonDelay(167, '3'),
            _buildButtonDelay(100, '5'),
            _buildButtonDelay(50, '10'),
            _buildButtonDelay(33, '15'),
            _buildButtonDelay(25, '20'),
          ]),
          const SizedBox(height: 16),
          const Text('Color'),
          SwatchEdit(
            initialValue: widget.appState.colorIndex,
            swatches: Swatches.all,
            onChanged: (value) => widget.appState.colorIndex = value,
          ),
          const SizedBox(height: 16),
          const Text('Feedback'),
          Wrap(spacing: 3.0, children: [
            _buildButtonFeedback('Torch', widget.appState.torchOn,
                widget.appState.hasTorch ? widget.appState.toggleTorch : null),
            _buildButtonFeedback('Screen', widget.appState.screenOn, widget.appState.toggleScreen),
            _buildButtonFeedback('Vibrate', widget.appState.vibrateOn,
                widget.appState.hasVibrator ? widget.appState.toggleVibrate : null),
            // _buildButtonFeedback('Sound', widget.appState.soundOn, widget.appState.toggleSound),
          ]),
          const SizedBox(height: 32),
          buildFooter(),
        ],
      ),
    );
  }
}
