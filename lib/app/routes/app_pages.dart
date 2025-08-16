import 'package:get/get.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/group_chat_room/bindings/group_chat_room_binding.dart';
import '../modules/group_chat_room/views/group_chat_room_view.dart';
import '../modules/groupchat/bindings/groupchat_binding.dart';
import '../modules/groupchat/views/groupchat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../views/views/auth_gate_view.dart';
import '../views/views/call_view.dart';
import '../views/views/login_orsignup_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTHGATE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.AUTHGATE,
      page: () => const AuthGateView(),
    ),
    GetPage(
      name: _Paths.LOGINORSIGNUP,
      page: () => const LoginOrsignupView(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.GROUPCHAT,
      page: () => const GroupchatView(),
      binding: GroupchatBinding(),
    ),
    GetPage(
      name: _Paths.CALL,
      page: () => const CallView(
        userID: '',
        callID: '',
        isVideo: true,
      ),
    ),
    GetPage(
      name: _Paths.GROUP_CHAT_ROOM,
      page: () => const GroupChatRoomView(),
      binding: GroupChatRoomBinding(),
    ),
  ];
}
