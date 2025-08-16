import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../services/auth_services.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  final supa = AuthServices();

  Future<void> signUp() async {
    if(confirmPassController.text == passwordController.text) {
      final res = await supa.signUpWithEmailPassword(emailController.text, passwordController.text);
      passwordController.clear();
      emailController.clear();
      confirmPassController.clear();
    }
    else{
      Get.snackbar('Failed', 'Password not matching');
    }
  }
}
