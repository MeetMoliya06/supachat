import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supachat/app/modules/group_chat_room/controllers/group_chat_room_controller.dart';

class GroupChatRoomView extends GetView<GroupChatRoomController> {
  const GroupChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = controller.authServices.getCurrentUser()!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.groupName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                _showGroupInfo(context);
          }, icon: Icon(Icons.info_outline)
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: controller.chatServices.getGroupMessagesStream(controller.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages.'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.scrollToBottom();
                });

                final data = snapshot.data;
                print('Snapshot Data: $data');

                final messages = snapshot.data!.reversed.toList();
                return ListView.builder(
                  controller: controller.scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final bool isCurrentUser = message['senderID'] == currentUserId;

                    // Debug prints
                    print("Message ${index}: ${message['message']}");
                    print("Sender ID: ${message['senderID']}");
                    print("Current User ID: $currentUserId");
                    print("Is Current User: $isCurrentUser");
                    print("Sender Email: ${message['senderEmail']}");
                    print("---");

                    if (message['imgUrl'] != null) {
                      return _GroupChatImageBubble(
                        senderEmail: message['senderEmail'],
                        imageUrl: message['imgUrl'],
                        isCurrentUser: isCurrentUser,
                      );
                    } else {
                      return _GroupChatMessageBubble(
                        senderEmail: message['senderEmail'],
                        message: message['message'],
                        isCurrentUser: isCurrentUser,
                      );
                    }
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Future<void> _showGroupInfo(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Info',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                controller.groupName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(height: 32),
              Text(
                'Members (${controller.groupMembers.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (controller.groupMembers.isEmpty) {
                    return const Center(child: Text('No members found.'));
                  }
                  return ListView.builder(
                    itemCount: controller.groupMembers.length,
                    itemBuilder: (context, index) {
                      final member = controller.groupMembers[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(member['email'] ?? 'No Email'),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
              onPressed: controller.sendGroupMessage,
              icon: const Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }
}

// Custom message bubble for group text messages
class _GroupChatMessageBubble extends StatelessWidget {
  final String senderEmail;
  final String message;
  final bool isCurrentUser;

  const _GroupChatMessageBubble({
    required this.senderEmail,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Show sender's email only if it's NOT the current user
          if (!isCurrentUser) // Fixed: was isCurrentUser
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                senderEmail,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom message bubble for group image messages
class _GroupChatImageBubble extends StatelessWidget {
  final String senderEmail;
  final String imageUrl;
  final bool isCurrentUser;

  const _GroupChatImageBubble({
    required this.senderEmail,
    required this.imageUrl,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              child: Text(
                senderEmail,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          Container(
            height: 300,
            width: 300,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl, fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}