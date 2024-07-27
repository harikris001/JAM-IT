import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  final bool? isHiddenText;

  const CustomField({
    super.key,
    required this.hintext,
    required this.controller,
    this.isHiddenText,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isHiddenText ?? false,
      controller: controller,
      decoration: InputDecoration(
        labelText: hintext,
      ),
      validator: (val) {
        if (val!.trim().isEmpty) {
          return "$hintext is missing";
        }
        return null;
      },
    );
  }
}
