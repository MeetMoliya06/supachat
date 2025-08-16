import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/auth_services.dart';
import '../../../services/chat_services.dart';
import '../../../views/views/call_view.dart';

class ChatController extends GetxController {

  final supabase = Supabase.instance.client;

  final homeArgument = Get.arguments;

  late final String receiverUid;
  late final String receiverEmail;
  final chatServices = ChatServices();
  final authServices = AuthServices();

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  late String senderID = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as List;
    receiverEmail = args[0];
    receiverUid = args[1];
    final currentUser = authServices.getCurrentUser();
    senderID = currentUser?.id ?? '';
    super.onInit();
  }

  String callId(){
    final String currentUid = authServices.getCurrentUser()!.id;
    List<String> ids = [currentUid, receiverUid]..sort();
    String chatRoomId = ids.join('_');
    return chatRoomId;
  }

  @override
  void onReady() {
    super.onReady();
    scrollToBottom();
  }


  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() async {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      await chatServices.sendMessage(receiverUid, message);
      messageController.clear();
      scrollToBottom();
      // await sendPushNotification(receiverUid, message);
    }
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
                          await chatServices.sendImageMessage(receiverUid, publicURL);
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
                          await chatServices.sendImageMessage(receiverUid, publicURL);
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

  // Future<void> initiateCall(String receiverID, bool isVideo) async {
  //   final currentUserID = authServices.getCurrentUser()!.id ?? '';
  //   final callID = '${currentUserID}_$authServices${DateTime.now().millisecondsSinceEpoch}';
  //
  //   await supabase.from('calls').insert({
  //     'caller_id': currentUserID,
  //     'receiver_id': receiverID,
  //     'call_id': callID,
  //     'type': isVideo ? 'video' : 'voice',
  //     'timestamp': DateTime.now().toIso8601String(),
  //     'is_handled': false,
  //   });
  //
  //   Get.to(() => CallView(
  //     userID: currentUserID,
  //     callID: callID,
  //     isVideo: isVideo,
  //   ));
  // }
  //
  // void listenForIncomingCalls() {
  //   final currentUserID = supabase.auth.currentUser?.id ?? '';
  //
  //   supabase
  //       .from('calls')
  //       .stream(primaryKey: ['id'])
  //       .eq('receiver_id, is_handled', {currentUserID, false})
  //       .listen((data) {
  //     if (data.isEmpty) return;
  //
  //     final call = data.last;
  //     final callID = call['call_id'];
  //     final callerID = call['caller_id'];
  //     final isVideo = call['type'] == 'video';
  //
  //     ConnectycubeFlutterCallKit.showCallNotification(
  //       CallEvent.fromJson(jsonEncode({
  //         'id': callID,
  //         'name': 'Incoming ${isVideo ? "Video" : "Voice"} Call',
  //         'app_name': 'My App',
  //         'handle': callerID,
  //         'type': isVideo ? 1 : 0, // 1 = video, 0 = audio
  //         'duration': 30000,
  //         'textAccept': 'Accept',
  //         'textDecline': 'Decline',
  //         'textMissedCall': 'Missed Call',
  //         'textCallback': 'Call back',
  //         'extra': {
  //           'user_id': callerID,
  //           'is_video': isVideo,
  //         },
  //       })),
  //     );
  //     // Optionally mark the call as handled
  //     supabase.from('calls').update({'is_handled': true}).eq('call_id', callID);
  //   });
  // }


}
