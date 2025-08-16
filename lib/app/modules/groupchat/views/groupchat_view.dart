import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/groupchat_controller.dart';

class GroupchatView extends GetView<GroupchatController> {
  const GroupchatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group chat'),
        centerTitle: true,
      ),
      body: Obx((){
        return controller.isAnyGroup.value ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  _showCreateGroupDialog(context);
                } ,
                icon: Icon(Icons.add),),
              Text('Create New Group'),
            ],
          ),
        )
            :
        StreamBuilder<List<Map<String, dynamic>>>(
            stream: controller.chatServices.getGroupsStream(),
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No groups found. Create one!'));
              }

              final groups = snapshot.data!;

              return ListView.builder(
                  itemCount: groups.length + 1,
                  itemBuilder: (context, index){
                    if (index == groups.length) {
                      return Center(child:
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          Divider(),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap: (){
                              _showCreateGroupDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline),
                                SizedBox(width: 10,),
                                Text('Create an other group'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      );
                    }
                    final group = groups[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                          child: Text(group['name'][0], style: TextStyle(color: Colors.black))
                      ),
                      title: Text(group['name']),
                      onTap: (){
                        Get.toNamed('/group-chat-room', arguments: [group['id'], group['name']]);
                      },
                    );
                  }
              );
            }
        );
      }),
    );
  }

  Future<void> _showCreateGroupDialog(BuildContext context) {
    controller.groupNameController.clear();
    controller.selectedUsers.clear();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a New Group',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.groupNameController,
                  decoration: const InputDecoration(
                    labelText: 'Group Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.group),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select Members',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder(
                    stream: controller.chatServices.getUserStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('Error while loading users ${snapshot.error}');
                        return const Center(child: Text('Error loading users'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final users = snapshot.data!
                          .where((userData) =>
                      userData['id'] !=
                          controller.authServices.getCurrentUser()?.id)
                          .toList();

                      if (users.isEmpty) {
                        return const Center(child: Text('No other users found.'));
                      }

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Obx(() => CheckboxListTile(
                            secondary: const Icon(Icons.person),
                            title: Text(user['email']),
                            value: controller.selectedUsers.contains(user['id']),
                            onChanged: (bool? isSelected) {
                              controller.toggleUserSelection(user['id']);
                            },
                          ));
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black),),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: controller.createGroup,
                      child: const Text('Create Group', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }}

