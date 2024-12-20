import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

  Future<File?> getVideoFromGallery() async {
    try {
      final XFile? file = await picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        return File(file.path);
      }
      return null;
    } catch (e) {
      debugPrint(
          'Error while picking image from gallery in MediaService getVideoFromGallery $e');
    }
    return null;
  }

  Future<File?> getPdfFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      debugPrint('Error while picking PDF file in MediaService getPdfFile: $e');
      return null;
    }
  }
}
