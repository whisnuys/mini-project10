import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project_task10/app/data/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  //get email user with username from firestore
  Future<String> getEmail(String username) async {
    final snapshot = await _db
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    if (snapshot.docs.isEmpty) {
      Get.snackbar(
        'Error',
        'Username tidak ditemukan',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "";
    } else {
      final email = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
      return email.email;
    }
  }

  createUser(UserModel user) async {
    await _db
        .collection('users')
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar(
            'Success',
            'Sukses membuat akun baru',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: Colors.green,
            colorText: Colors.white,
          ),
        )
        .catchError(
      // ignore: body_might_complete_normally_catch_error
      (error, stackTrace) {
        Get.snackbar(
          'Error',
          'Gagal membuat akun baru $error',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection('users').where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<void> updateSingleField(
      Map<String, dynamic> json, String username) async {
    try {
      await _db
          .collection('users')
          .where('username', isEqualTo: username)
          .get()
          .then((value) => value.docs.forEach((element) {
                _db.collection('users').doc(element.id).update(json);
              }));
    } catch (e) {
      throw 'Error updating user data';
    }
  }

  //upload image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupload gambar, error: $e',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return "";
    }
  }
}
