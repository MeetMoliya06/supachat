import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supachat/app/services/auth_services.dart';
import 'package:supachat/app/services/chat_services.dart';

class GroupChatRoomController extends GetxController {
  final ChatServices chatServices = ChatServices();
  final AuthServices authServices = AuthServices();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  late final String groupId;
  late final String groupName;

  var groupMembers = <Map<String,dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final groupData = Get.arguments;
    groupId = groupData[0];
    groupName = groupData[1];
    fetchGroupInfo();
  }

  void fetchGroupInfo() async{
    try{
      var members = await chatServices.getGroupInfo(groupId);
      groupMembers.value = members;
      print('Group Members info $groupMembers');
    }catch(e){
      print('Error while fetching members info $e');
    }
  }


  void sendGroupMessage() async {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      await chatServices.sendGroupMessage(groupId, message);
      messageController.clear();
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void bottomSheet() {
    final ImagePicker picker = ImagePicker();

    if (Get.context != null) {
      showModalBottomSheet(
        context: Get.context!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text('Pick from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        File file = File(image.path);
                        print("Picked from gallery: ${file.path}");

                        final String filePath = 'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

                        final storage = Supabase.instance.client.storage;
                        final response = await storage.from('images').upload(filePath, file);

                        if (response != null) {
                          final String publicURL = storage.from('images').getPublicUrl(filePath);
                          await chatServices.sendGroupImage(groupId, publicURL);
                        } else {
                          print('❌ Failed to upload image to Supabase.');
                        }
                      }
                    } catch (e) {
                      print('❌ Error during Supabase upload: $e');
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Capture from Camera'),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      final XFile? image = await picker.pickImage(source: ImageSource.camera); // use camera
                      if (image != null) {
                        File file = File(image.path);
                        print("Captured image: ${file.path}");

                        final String filePath = 'user_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

                        final storage = Supabase.instance.client.storage;
                        final response = await storage.from('images').upload(filePath, file);

                        if (response != null) {
                          final String publicURL = storage.from('images').getPublicUrl(filePath);
                          await chatServices.sendGroupImage(groupId, publicURL);
                        } else {
                          print('❌ Failed to upload camera image to Supabase.');
                        }
                      }
                    } catch (e) {
                      print('❌ Error during Supabase camera upload: $e');
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      print("⚠️ Get.context is null. Make sure this is called inside widget lifecycle.");
    }
  }

}