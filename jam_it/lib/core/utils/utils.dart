import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void snackBarPopUp(BuildContext context, String content) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickAudio() async {
  try {
    final fileResutPath =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (fileResutPath != null) {
      return File(fileResutPath.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final fileResutPath =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (fileResutPath != null) {
      return File(fileResutPath.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
