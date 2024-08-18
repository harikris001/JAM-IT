import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintext;
  final TextEditingController? controller;
  final bool? isHiddenText;
  final bool? isReadOnly;
  final VoidCallback? onTap;

  const CustomField({
    this.isReadOnly,
    super.key,
    required this.hintext,
    this.controller,
    this.isHiddenText,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: isReadOnly ?? false,
      obscureText: isHiddenText ?? false,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintext,
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
