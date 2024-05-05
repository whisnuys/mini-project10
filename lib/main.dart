import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mini_project_task10/app/data/repository/auth_repository.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCdFBeAIk0eEKISr4tRO9_vit_zHj_P4Q0",
      appId: "1:1085255611181:android:6811ea8969871d465fd9a4",
      messagingSenderId: "1085255611181",
      projectId: "mini-project-ffab1",
      storageBucket: "mini-project-ffab1.appspot.com",
    ),
  ).then((value) {
    Get.put(AuthRepository());
  });
  runApp(
    GetMaterialApp(
      title: "Mini Project - Whisnu",
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
