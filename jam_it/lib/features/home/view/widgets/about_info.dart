import 'package:flutter/material.dart';

class AboutInfo extends StatelessWidget {
  const AboutInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: "Jam-It!",
      applicationIcon: Image.asset(
        "assets/images/appicon.png",
        height: 80,
        width: 80,
      ),
      applicationVersion: "0.1.3",
      applicationLegalese: "© Made by Harikrishna.",
      children: const [
        Text("A Crowd source initiative"),
        Text(
          "Support the project on GitHub",
          style: TextStyle(fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
