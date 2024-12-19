import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  MediaService._();

  static final MediaService _instance = MediaService._();

  static MediaService get instance => _instance;

  final ImagePicker picker = ImagePicker();

  Future<File?> getImageFromGallery() async {
    try {
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        return File(file.path);
      }
      return null;
    } catch (e) {
      debugPrint(
          'Error while picking image from gallery in MediaService getImageFromGallery $e');
    }
    return null;
  }
}
