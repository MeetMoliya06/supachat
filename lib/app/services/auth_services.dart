import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'auth_services.dart';

class AuthServices{

  final _supa = Supabase.instance.client.auth;
  final _supaInsert = Supabase.instance.client;

  Future<void> signinwithemailpassword(String email, String password) async{
    try{
      final response = await _supa.signInWithPassword( email: email,password: password);
      if(response.user != null){
        Get.snackbar("Login Success", 'Welecome to home page');
      }

      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1455117441, // Your App ID
        appSign: "37b309858e442bec882e20194e4534840928e7bc4a318aeadfd03ac639808aae", // Your App Sign
        userID: response.user!.id,
        userName: email,
        plugins: [ZegoUIKitSignalingPlugin()],
      );

      Get.offAllNamed('/home');
    }catch(e){
      print('------$e--------');
      Get.snackbar("Error", 'Error $e');
    }
  }

  Future<void> signUpWithEmailPassword(String email, String password) async{

    try{
      final response = await _supa.signUp(
          password: password,
          email: email
      );
      if(response.user != null){
        Get.snackbar('SignUp Success', "Welcome abord to chat");
      }

      await _supaInsert.from('profiles').insert({
        'id' : response.user?.id,
        'email' : email,
      });

      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1455117441, // Your App ID
        appSign: "37b309858e442bec882e20194e4534840928e7bc4a318aeadfd03ac639808aae", // Your App Sign
        userID: response.user!.id,
        userName: email,
        plugins: [ZegoUIKitSignalingPlugin()],
      );

      Get.offAllNamed('/home');
    }catch(e){
      print('-------------${e}----------');
      Get.snackbar("Error", 'Error $e');
    }
  }

  Future<void> logOut() async{
    try{
      await _supa.signOut();
      Get.offAllNamed('/login');
    }catch(e){}
  }

  User? getCurrentUser(){
    return _supa.currentUser;
  }

}