import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/message_model.dart';

class ChatServices {
  final supabase = Supabase.instance.client;

  // Get all users
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .execute()
        .map((users) => users.map((user) => user as Map<String, dynamic>).toList());
  }

  // Send message
  Future<void> sendMessage(String receiverId, String message) async {
    final user = supabase.auth.currentUser;
    final String currentEmail = user!.email!;
    final String currentUid = user.id;

    final newMessage = Message(
      senderID: currentUid,
      senderEmail: currentEmail,
      receiverID: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );

    List<String> ids = [currentUid, receiverId]..sort();
    String chatRoomId = ids.join('_');
    try{
      await supabase.from('messages').insert({
        ...newMessage.toMap(),
        'chat_room_id': chatRoomId,
      });
    }
    catch(e){
      print('Sending message error $e');
    }
  }

  // Get messages stream
  Stream<List<Map<String, dynamic>>>? getMessages(String userID, String otherUserID) {
    try{
      List<String> ids = [userID, otherUserID]..sort();
    String chatRoomId = ids.join('_');

    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_room_id', chatRoomId)
        .order('timestamp', ascending: true)
        .execute()
        .map((rows) => rows.map((row) => row as Map<String, dynamic>).toList());
    }catch(e){
      print('Getting msg $e');
      return null;
    }
    }

  // Send image message
  Future<void> sendImageMessage(String receiverId, String imgUrl) async {
    final user = supabase.auth.currentUser;
    final String currentEmail = user!.email!;
    final String currentUid = user.id;

    final newMessage = Message(
      senderID: currentUid,
      senderEmail: currentEmail,
      receiverID: receiverId,
      message: null,
      imgUrl: imgUrl,
      timestamp: DateTime.now(),
    );

    List<String> ids = [currentUid, receiverId]..sort();
    String chatRoomId = ids.join('_');

    await supabase.from('messages').insert({
      ...newMessage.toMap(),
      'chat_room_id': chatRoomId,
    });
  }

  //Create Group Chat
  Future<String?> createGroup(String name, List<String> memberIds) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      return null;
    }

    try {
      final List<dynamic>? groupResponse = await supabase
          .from('groups')
          .insert({
        'name': name,
        'created_by': currentUser.id,
      }).select('id');

      if (groupResponse == null || groupResponse.isEmpty) {
        return null;
      }

      final groupIdData = groupResponse[0];
      if (groupIdData == null || groupIdData['id'] == null) {
        return null;
      }

      final String groupId = groupIdData['id'];

      final membersToInsert = [...memberIds, currentUser.id]
          .map((userId) => {'group_id': groupId, 'user_id': userId})
          .toList();

      await supabase.from('group_members').insert(membersToInsert);

      return groupId;
    } on PostgrestException catch (e) {
      print('Error creating group: ${e.message}');
      return null;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return null;
    }
  }



  //Get all the group for the current user
  Stream<List<Map<String, dynamic>>> getGroupsStream() {
    return supabase
        .from('groups')
        .stream(primaryKey: ['id'])
        .map((groups) => groups.toList());
  }

  //send grp msg
  Future<void> sendGroupMessage(String groupId, String message) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final newMessage = {
      'senderID': user.id,
      'senderEmail': user.email!,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'group_id': groupId,
      'receiverID': null,
    };

    await supabase.from('messages').insert(newMessage);
  }

  //send Group Image
  Future<void> sendGroupImage(String groupId, String imgUrl) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final newMessage = {
      'senderID': user.id,
      'senderEmail': user.email!,
      'imgUrl': imgUrl,
      'timestamp': DateTime.now().toIso8601String(),
      'group_id': groupId,
      'receiverID': null,
    };

    await supabase.from('messages').insert(newMessage);
  }

  //get all the grp msg
  Stream<List<Map<String, dynamic>>> getGroupMessagesStream(String groupId) {
    final currentUser = supabase.auth.currentUser;
    print("Getting messages for group: $groupId");
    print("Current user ID: ${currentUser?.id}");

    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('group_id', groupId)
        .order('timestamp', ascending: true)
        .execute()
        .map((rows) {
      print("Raw messages from database: $rows");
      return rows.toList();
    });
  }

  //get info of group
  Future<List<Map<String,dynamic>>> getGroupInfo(String groupId) async {
    final res = await supabase
        .from('group_members')
        .select('profiles(id,email)').eq('group_id', groupId);

    if(res == null) return [];
    final members = res.map((e) => e['profiles'] as Map<String, dynamic>).toList();
    return members ;
  }
}