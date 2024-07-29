import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final Timestamp timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    return ChatMessage(
      senderId: doc['senderId'],
      senderName: doc['senderName'],
      text: doc['text'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
