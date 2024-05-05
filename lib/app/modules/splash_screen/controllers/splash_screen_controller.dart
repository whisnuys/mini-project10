import 'package:get/get.dart';

import '../../../data/repository/auth_repository.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final authRepo = Get.put(AuthRepository());

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 3), () {
      authRepo.firebaseUser.value == null
          ? Get.offAllNamed(Routes.LOGIN)
          : Get.offAllNamed(Routes.HOME);
    });
    super.onReady();
  }
}
