import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  final void Function()? onTap;

  const RegisterView({super.key, this.onTap});
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

              Text("Let's create a Account for you",
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

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: TextField(
                  obscureText: true,
                  controller: controller.confirmPassController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      ),
                      focusedBorder: OutlineInputBorder(
                      ),
                      filled: true,
                      hintText: 'confirm password',
                      hintStyle: TextStyle(
                      )
                  ),
                ),
              ),

              SizedBox(height: 20,),

              InkWell(
                onTap: (){
                  controller.signUp();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFDDD7E0),
                  ),
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text('Register'),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an Account ',
                    style: TextStyle(
                    ),),

                  GestureDetector(
                    onTap: onTap,
                    child: Text('Login Now',
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
