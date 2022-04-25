import 'package:flutter/material.dart';

Widget buildAboutDialog(BuildContext context) {
  return AboutDialog(
    applicationIcon: const Image(
        width: 64, height: 64, image: AssetImage('assets/app/icon.png')),
    applicationName: "Flashlight Torcher",
    applicationVersion: 'Version 0.1',
    applicationLegalese: '© 2022 TopAppField',
    children: <Widget>[
      Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: const Text("The flashlight lamp you may torch.",
            textAlign: TextAlign.center),
      )
    ],
  );
}
