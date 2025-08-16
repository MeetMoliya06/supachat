import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final void Function()? onTap;

  const LoginView({super.key, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                  Icons.message_rounded,
                  size: 70,
              ),

              SizedBox(height: 30,),

              Text('Welcome Back you have been missed',
                style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      ),
                      focusedBorder: OutlineInputBorder(
                      ),
                      filled: true,
                      hintText: 'example@gmail.com',
                      hintStyle: TextStyle(
                      )
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: TextField(
                  obscureText: true,
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      ),
                      focusedBorder: OutlineInputBorder(
                      ),
                      filled: true,
                      hintText: 'password',
                      hintStyle: TextStyle(
                      )
                  ),
                ),
              ),

              SizedBox(height: 20,),

              InkWell(
                onTap: (){
                  controller.login();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFDDD7E0),
                  ),
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text('Login'),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member ? ',
                    style: TextStyle(
                    ),),

                  GestureDetector(
                    onTap: onTap,
                    child: Text('Register Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ],
              ),


            ],
          ),
        )
    );
  }
}
