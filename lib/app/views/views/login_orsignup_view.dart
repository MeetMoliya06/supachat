import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../modules/login/views/login_view.dart';
import '../../modules/register/views/register_view.dart';

class LoginOrsignupView extends GetView {
  const LoginOrsignupView({super.key});
  static final RxBool showLoginPage = true.obs;

  @override
  Widget build(BuildContext context) {
    print(showLoginPage);
    return Obx((){
      void togglePages(){
        print('function is calling');
        showLoginPage.value = !showLoginPage.value;
      }
      if(showLoginPage.value){
        print('login is working');
        return LoginView(
          onTap : togglePages,
        );
      }
      else{
        print('register is working');
        return RegisterView(
          onTap : togglePages,
        );
      }
    });
  }
}
