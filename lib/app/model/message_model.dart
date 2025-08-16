// app/model/message_model.dart

class Message {
  final String senderID;
  final String senderEmail;
  // Make receiverID nullable
  final String? receiverID;
  final String? message;
  final String? imgUrl;
  final DateTime timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    // It's no longer required
    this.receiverID,
    this.message,
    this.imgUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'imgUrl': imgUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}