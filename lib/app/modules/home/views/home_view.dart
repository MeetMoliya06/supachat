import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.supa.getCurrentUser()!.email!),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: Icon(
                      Icons.message,
                      size: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    title: Text(
                      'H O M E',
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    title: Text(
                      'G R O U P  C H A T',
                    ),
                    onTap: () {
                      Get.back();
                      Get.toNamed('/groupchat');
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 15),
              child: ListTile(
                title: Text(
                  'L O G O U T',
                ),
                leading: Icon(Icons.logout,),
                onTap: () {
                  controller.logOut();
                },
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: controller.chatServices.getUserStream(),
        builder: (context, snapshot) {
          // Error
          if (snapshot.hasError) {
            print('--------------Error in homeview-----${snapshot.error}-----------');
            return const Text('Error');
          }

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print('User stream data: ${snapshot.data}');
          // ListView of users
          return ListView(
            padding: const EdgeInsets.all(12),
            children: snapshot.data!.map<Widget>((userData) {

              if (userData['email'] != controller.authServices.getCurrentUser()?.email) {
                return _UserTile(
                  text: userData['email'],
                  onTap: () {
                    controller.chatRoom(userData['id']);
                    Get.toNamed('/chat', arguments: [userData['email'], userData['id']]);
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const _UserTile({
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Icon(Icons.person,),

            const SizedBox(width: 20),

            // User email
            Text(
              text,
            ),
          ],
        ),
      ),
    );
  }
}