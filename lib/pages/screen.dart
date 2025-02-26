import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state.dart';
import 'dashboard.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key, required this.appState}) : super(key: key);

  final AppState appState;

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  Color backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    widget.appState.screenState = this; // circular link: screenState <--> appState
  }

  void setScreenColor(Color color) {
    setState(() {
      backgroundColor = color;
    });
  }

  void showDashboard() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      backgroundColor: Colors.blue[100],
//          barrierColor: Colors.blue[900],
      builder: (context) => Dashboard(appState: widget.appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      // appBar: AppBar(title: Text('Top Flashlight')),
      backgroundColor: backgroundColor,
      body: InkWell(
        child: const Center(
          child: Text(
            "Tap for settings",
            style: TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        onTap: showDashboard,
      ),
    );
  }
}
