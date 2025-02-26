import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void launchWeb(String url) async {
  final Uri uri = Uri.parse(url);
  await launchUrl(uri);
}

Widget buildAboutDialog(BuildContext context) {
  return AboutDialog(
    applicationIcon: const Image(width: 64, height: 64, image: AssetImage('assets/app/icon.png')),
    applicationName: "Flashlight Torcher",
    applicationVersion: 'Version 1.3',
    applicationLegalese: '© 2022-2025 TopAppField',
    children: <Widget>[
      Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Column(
          children: [
            const Text("The mobile flashlight lamp you may torch forever and ever.",
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            InkWell(
              onTap: () =>
                  launchWeb('https://play.google.com/store/apps/dev?id=5830013704268208202'),
              child: Text('Tap here to see all apps from TopAppField',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue)),
            ),
          ],
        ),
      )
    ],
  );
}
