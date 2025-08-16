import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supachat/app/services/auth_services.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final supa = AuthServices();

  Future<void> login() async {
    final res = await supa.signinwithemailpassword(emailController.text, passwordController.text);
    passwordController.clear();
    emailController.clear();
  }
}
