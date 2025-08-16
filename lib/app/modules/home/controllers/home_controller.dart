import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supachat/app/services/auth_services.dart';
import 'package:supachat/app/services/chat_services.dart';

class HomeController extends GetxController {
  final supa = AuthServices();
  final chatServices = ChatServices();
  final authServices = AuthServices();
  final _supaInsert = Supabase.instance.client;

  void logOut(){
    supa.logOut();
  }

  Future<void> chatRoom(String receiverId) async {
    final String currentUid = supa.getCurrentUser()!.id;
    List<String> ids = [currentUid, receiverId]..sort();
    String chatRoomId = ids.join('_');

    // Check if chat room already exists
    final existing = await _supaInsert
        .from('chat_rooms')
        .select()
        .eq('id', chatRoomId)
        .maybeSingle();

    if (existing == null) {
      await _supaInsert.from('chat_rooms').insert({
        'id': chatRoomId,
        'user1_id': ids[0],
        'user2_id': ids[1],
      });
    } else {
      print("Chat room already exists: $chatRoomId");
    }
  }


}
