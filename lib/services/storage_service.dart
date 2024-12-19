import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();

  static StorageService get instance => _instance;

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadProfilePhoto(
      {required String uid, required File file}) async {
    try {
      Reference fileRef = await firebaseStorage
          .ref('users/pfps')
          .child('$uid${p.extension(file.path)}');
      UploadTask task = fileRef.putFile(file);
      return task.then(
        (p) {
          if (p.state == TaskState.success) {
            return fileRef.getDownloadURL();
          }
          return null;
        },
      );
    } catch (e) {
      debugPrint(
          'Error while uploading profile photo in Storage service uploadProfilePhoto function');
    }
    return null;
  }

  Future<String?> uploadImageToChat(
      {required String chatId, required File file}) async {
    try {
      Reference fileRef = firebaseStorage.ref('chat/$chatId').child(
          '${DateTime.now().toIso8601String()}${p.extension(file.path)}');
      UploadTask task = fileRef.putFile(file);
      return task.then(
        (p) {
          if (p.state == TaskState.success) {
            return fileRef.getDownloadURL();
          }
          return null;
        },
      );
    } catch (e) {
      debugPrint(
          'Error while uploading profile photo in Storage service uploadProfilePhoto function');
    }
    return null;
  }
}
