import 'package:flutter/material.dart';
import 'package:jam_it/core/theme/app_pallete.dart';

class HeroImage extends StatelessWidget {
  final int angle;
  const HeroImage({
    super.key,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        const Column(
          children: [
            Text(
              'Jam-IT',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Find Your\nPerfect Jam',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Pallete.subtitleText),
            ),
          ],
        ),
        Transform.rotate(
          angle: angle * 3.14 / 180,
          child: Opacity(
            opacity: 0.2,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/signup.jpg',
                  ).image,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
