import 'dart:async';

import 'package:flutter/material.dart';
import 'package:torch_control/torch_control.dart';
import 'package:vibration/vibration.dart';

import 'utils/swatches.dart';

class AppState {
  AppState() {
    _init();
  }

  // Screen control

  void Function()? updateScreen;

  // ********** Availability **********

  bool hasTorch = false;
  bool hasVibrator = false;

  void _init() async {
    hasTorch = await TorchControl.ready();
    hasVibrator = await Vibration.hasVibrator();
    // set default feedback
    _torchOn = hasTorch;
    _screenOn = true;
    _vibrateOn = hasVibrator;
    updateScreen?.call();
  }

  // ********** Property: strobe delay (blinks per second) **********

  final List<int> _strobeDelays = [0, 1000, 500, 250, 167, 100, 50, 33, 25];
  final List<int> _strobeHzs = [0, -1, 1, 2, 3, 5, 10, 15, 20]; // -1 -> 1/2
  int get strobeMax => 6; // _strobeDelays.length - 1;

  int _strobe = 0;
  int get strobe => _strobe;

  set strobe(int value) {
    _strobe = value;
    _makeFeedback();
    _checkTimer();
  }

  int get strobeDelay => _strobeDelays[strobe];

  String get strobeHzText {
    switch (strobe) {
      case 0:
        return "No blinking";
      case 1:
        return "Blinking frequency: 1/2 per second";
      default:
        return "Blinking frequency: ${_strobeHzs[strobe]} per second";
    }
  }

  // ********** Property: (screen) color **********

  int _swatch = 10;
  int get swatch => _swatch;
  set swatch(value) => _swatch = value;

  int _brightness = 4;
  int get brightness => _brightness;
  set brightness(value) => _brightness = value;

  int get brightnessPercent => (brightness + 1) * 10;

  Color get colorScreen {
    var colorLevel = _brightness == 9 ? 50 : (9 - _brightness) * 100;
    return _on && phaseOn && screenOn ? Swatches.at(swatch)[colorLevel]! : Colors.black;
  }

  Color get colorActive => Swatches.at(_swatch)[!on || !screenOn || brightness < 5 ? 200 : 700]!;

  Color get colorInactive => Swatches.at(_swatch)[!on || !screenOn || brightness < 5 ? 400 : 500]!;

  // ********** Feedback: torch **********

  bool _torchOn = true;
  bool get torchOn => _torchOn;

  void toggleTorch() {
    _torchOn = !_torchOn;
    TorchControl.turn(_on && _torchOn && phaseOn);
  }

  // ********** Feedback: screen **********

  bool _screenOn = true;
  bool get screenOn => _screenOn;

  void toggleScreen() {
    _screenOn = !_screenOn;
  }

  // ********** Feedback: vibrate **********

  bool _vibrateOn = true;
  bool get vibrateOn => _vibrateOn;

  void toggleVibrate() {
    _vibrateOn = !_vibrateOn;
  }

  // ********** Feedback: sound **********

  bool _soundOn = false;
  bool get soundOn => _soundOn;

  void toggleSound() {
    _soundOn = !_soundOn;
  }

  // ********** Property: on/off **********

  bool _on = false;
  bool get on => _on;

  void toggle() {
    _on = !_on;
    _makeFeedback();
    _checkTimer();
  }

  Timer? timerStrobe;

  int _tick = 0;
  int get tick => _tick;
  bool get phaseOn => tick % 2 == 0; // alternating on/even and off/odd phases

  void _checkTimer() {
    if (timerStrobe != null) timerStrobe?.cancel();
    timerStrobe = null;
    _tick = 0;
    if (on && strobe > 0) {
      timerStrobe = Timer.periodic(Duration(milliseconds: strobeDelay), _timerTick);
    }
  }

  void _timerTick(timer) {
    if (!on) return;
    _tick++;
    _makeFeedback();
  }

  void _makeFeedback() {
    updateScreen?.call();
    TorchControl.turn(on && torchOn && phaseOn);
    if (on && vibrateOn && phaseOn) Vibration.vibrate(duration: 20);
  }
}
