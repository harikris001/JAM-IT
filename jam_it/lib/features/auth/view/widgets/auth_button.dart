import 'package:flutter/material.dart';
import 'package:jam_it/core/theme/app_pallete.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AuthButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.topRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
          fixedSize: const Size(320, 60),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
