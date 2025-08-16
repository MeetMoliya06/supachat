import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../modules/home/views/home_view.dart';
import 'login_orsignup_view.dart';

class AuthGateView extends GetView {
  const AuthGateView({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final session = Supabase.instance.client.auth.currentSession;

          if (session != null) {
            return const HomeView();
          } else {
            return const LoginOrsignupView();
          }
        },
      ),
    );
  }

}
