import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../views/views/call_view.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    String senderID = controller.authServices.getCurrentUser()!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.receiverEmail,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => CallView(
                userID: senderID,
                callID: controller.callId(),
                isVideo: true,
              ));
            },
            icon: Icon(Icons.videocam_outlined),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => CallView(
                userID: senderID,
                callID: controller.callId(),
                isVideo : false,
              ));
            },
            icon: Icon(Icons.call),
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: controller.chatServices
                  .getMessages(controller.receiverUid, senderID),
              builder: (context, snapshot) {
                // Error
                if (snapshot.hasError) {
                  print('Getting msg error${snapshot.error}');
                  return const Text('Error');
                }

                // Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ListView of messages
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.scrollToBottom();
                });
                return ListView(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(16.0),
                  reverse: true,
                  children: snapshot.data!.reversed.map<Widget>((doc) {
                    Map<String, dynamic> data =
                    doc as Map<String, dynamic>;
                    bool isCurrentUser = data['senderID'] == senderID;

                    // return true ? _ChatImageBubble(
                    //   message : data['imgUrl'],
                    //   isCurrentUser : isCurrentUser,
                    // ) :
                    //   _ChatMessageBubble(
                    //   message: data['message'],
                    //   isCurrentUser: isCurrentUser,
                    // );
                    if (data['imgUrl'] != null) {
                      return _ChatImageBubble(
                        message: data['imgUrl'] ?? '',
                        isCurrentUser: isCurrentUser,
                      );
                    } else {
                      return _ChatMessageBubble(
                        message: data['message'] ?? '',
                        isCurrentUser: isCurrentUser,
                      );
                    }
                  }).toList(),
                );
              },
            ),
          ),

          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:30.0, left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),

                ),
                filled: true,
                hintText: 'Type a message...',
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: controller.bottomSheet,
              icon: Icon(
                Icons.photo,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: controller.sendMessage,
              icon: Icon(
                Icons.send,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const _ChatMessageBubble({
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    var bubbleColor = isCurrentUser
        ? Colors.blue
        : Colors.white;

    var textColor = isCurrentUser
        ? Colors.white
        : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}



class _ChatImageBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const _ChatImageBubble({
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    var bubbleColor = isCurrentUser
        ? Colors.blue
        : Colors.white;

    var textColor = isCurrentUser
        ? Colors.white
        : Colors.black;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        height: 300,
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.network(message, fit:BoxFit.fill)
      ),
    );
  }
}
