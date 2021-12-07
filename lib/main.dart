import 'package:flutter/material.dart';

import 'state.dart';
import 'pages/screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppState state = AppState();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Torcher flashlight lamp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Screen(appState: state),
    );
  }
}
