import 'package:get/get.dart';

import '../controllers/group_chat_room_controller.dart';

class GroupChatRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupChatRoomController>(
      () => GroupChatRoomController(),
    );
  }
}
