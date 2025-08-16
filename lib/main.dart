import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supachat/app/modules/home/controllers/home_controller.dart';
import 'package:supachat/app/modules/register/controllers/register_controller.dart';
import 'package:supachat/app/routes/app_pages.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'app/modules/login/controllers/login_controller.dart';
import 'app/services/auth_services.dart';

const supabaseUrl = 'https://xnkyjqiiqgeihpghjmfg.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhua3lqcWlpcWdlaWhwZ2hqbWZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM3NzcyMDIsImV4cCI6MjA2OTM1MzIwMn0.oW6sAeR9Sm2d723LyytOnsImzKM4JGtJutlEXTP-BEY';
final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // ConnectycubeFlutterCallKit.instance.init();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  // final authServices = AuthServices();
  // final currentUser = authServices.getCurrentUser();
  //
  // ZegoUIKitPrebuiltCallInvitationService().init(
  //   appID: 1455117441, // Your AppID
  //   appSign: "37b309858e442bec882e20194e4534840928e7bc4a318aeadfd03ac639808aae", // Your AppSign
  //   userID: 'your_current_user_id', // IMPORTANT: MUST be unique for each user
  //   userName: 'user_your_current_user_id',
  //   plugins: [ZegoUIKitSignalingPlugin()],
  // );

  Get.put(LoginController());
  Get.put(RegisterController());
  Get.put(HomeController());


  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      // builder: (context, child) {
      //   return ZegoUIKitPrebuiltCallWithInvitation(
      //     child: child!,
      //   );
      // },
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}

