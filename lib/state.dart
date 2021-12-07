import 'dart:async';
import 'dart:ui';

import 'package:torch_control/torch_control.dart';
import 'package:torcher/pages/screen.dart';
import 'package:vibration/vibration.dart';
import 'utils/swatches.dart';

class AppState {
  AppState() {
    _init();
  }

  bool hasTorch = false;
  bool hasVibrator = false;

  void _init() async {
    hasTorch = await TorchControl.ready();
    hasVibrator = await Vibration.hasVibrator() ?? false;
  }

  // ********** Property: on/off **********

  bool _on = false;
  bool get on => _on;

  void toggle() {
    _on = !_on;
    _tick = _on ? 0 : 1; // even,odd phase
    _checkFeedback(true);
    _checkTimer();
  }

  // ********** Property: strobe delay (blinks per second) **********

  int _strobeDelay = 0;
  int get strobeDelay => _strobeDelay;
  set strobeDelay(int value) {
    _strobeDelay = value;
    _tick = 0;
    _checkFeedback(true);
    _checkTimer();
  }

  // ********** Property: (screen) color **********

  int _colorIndex = 0;
  int get colorIndex => _colorIndex;
  set colorIndex(value) {
    _colorIndex = value;
    _updateScreen();
  }

  Color get _screenColor =>
      _on && phaseOn && screenOn ? Swatches.screenOnColor(_colorIndex) : Swatches.screenOffColor(_colorIndex);

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
    _updateScreen();
  }

  ScreenState? screenState;

  void _updateScreen() {
    screenState?.setScreenColor(_screenColor);
  }

  // ********** Feedback: vibrate **********

  bool _vibrateOn = false;
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

  // ********** Timer **********

  Timer? timer;

  int _tick = 0;
  int get tick => _tick;
  bool get phaseOn => tick % 2 == 0; // alternating on/even and off/odd phases

  void _checkTimer() {
    if (timer != null) timer?.cancel();
    timer = null;
    if (_on && _strobeDelay > 0) {
      timer = Timer.periodic(Duration(milliseconds: strobeDelay), _timerTick);
    }
  }

  void _timerTick(timer) {
    if (!_on) return;
    _tick++;
    _checkFeedback(false);
  }

  void _checkFeedback(bool forceScreenUpdate) {
    if (forceScreenUpdate || _screenOn) _updateScreen();
    TorchControl.turn(_on && _torchOn && phaseOn);
    if (_on && _vibrateOn && phaseOn) Vibration.vibrate(duration: 20);
  }
}
