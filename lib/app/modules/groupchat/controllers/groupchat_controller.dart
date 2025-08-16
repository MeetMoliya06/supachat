
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../services/auth_services.dart';
import '../../../services/chat_services.dart';

class GroupchatController extends GetxController {
  // Initialize to true, but onInit will update it.
  var isAnyGroup = true.obs;
  final chatServices = ChatServices();
  final authServices = AuthServices();

  final selectedUsers = <String>{}.obs;
  final groupNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkIfUserHasGroups();
  }

  void _checkIfUserHasGroups() {
    chatServices.getGroupsStream().listen((groups) {
      if (groups.isNotEmpty) {
        isAnyGroup.value = false;
      } else {
        isAnyGroup.value = true;
      }
    });
  }


  void toggleUserSelection(String userId) {
    if (selectedUsers.contains(userId)) {
      selectedUsers.remove(userId);
    } else {
      selectedUsers.add(userId);
    }
  }

  void createGroup() async {
    if (groupNameController.text.isEmpty || selectedUsers.isEmpty) {
      Get.snackbar('Error', 'Group name and members are required.');
      return;
    }

    final groupId = await chatServices.createGroup(
      groupNameController.text,
      selectedUsers.toList(),
    );

    if (groupId != null) {
      Get.back();
      Get.snackbar('Success', 'Group created successfully!');
      // isAnyGroup.value = false;
    } else {
      Get.snackbar('Error', 'Failed to create group.');
    }
  }

  @override
  void onClose() {
    groupNameController.dispose();
    super.onClose();
  }
}