import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final Timestamp timestamp;
  final String status; // Add this line
  final bool isRead; // Add this line

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.status = 'sent', // Default to 'sent' if not provided
    this.isRead= false, // Default to false if not provided
  });

  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return ChatMessage(
      senderId: data?['senderId'] ?? '',
      senderName: data?['senderName'] ?? 'Unknown',
      text: data?['text'] ?? '',
      timestamp: data?['timestamp'] ?? Timestamp.now(),
      status: data?['status'] ?? 'sent', // Default to 'sent' if missing
      isRead: data?['isRead'] ?? false, // Default to false if missing
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp,
      'status': status, // Ensure status is included
      'isRead': isRead, // Ensure isRead is included
    };
  }
}
