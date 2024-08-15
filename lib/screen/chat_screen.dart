// screen/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pkm_gastreit/models/chat_message.dart'; 
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';
import 'package:pkm_gastreit/widgets/bottom_navigation_bar.dart';
import 'package:pkm_gastreit/screen/user_list_screen.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;

  ChatScreen({required this.recipientId, required this.recipientName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InputScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ReportScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserListScreen()),
        );
        break;
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        final userName = userDoc['fullName'] ?? 'Unknown';

        final chatMessage = ChatMessage(
          senderId: user.uid,
          senderName: userName,
          text: _messageController.text,
          timestamp: Timestamp.now(),
        );

        await _firestore
            .collection('chats')
            .doc(_generateChatId())
            .collection('messages')
            .add(chatMessage.toMap());
        _messageController.clear();
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  String _generateChatId() {
    final currentUserId = _auth.currentUser!.uid;
    if (currentUserId.compareTo(widget.recipientId) > 0) {
      return '$currentUserId-${widget.recipientId}';
    } else {
      return '${widget.recipientId}-$currentUserId';
    }
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final chatMessage = ChatMessage.fromDocument(doc);
    final isMe = chatMessage.senderId == _auth.currentUser?.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
          boxShadow: isMe
              ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)]
              : [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatMessage.senderName,
              style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.bold, 
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 5),
            Text(
              chatMessage.text,
              style: GoogleFonts.ubuntu(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.recipientName,
          style: GoogleFonts.ubuntu(
            fontSize: 25, 
            fontWeight: FontWeight.w600, 
            color: Colors.white
          ),
        ),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(_generateChatId())
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageItem(messages[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
  children: [
    Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromRGBO(10, 40, 116, 1), // Border color
            width: 2, // Border width
          ),
        ),
        child: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'Type a message...',
            border: InputBorder.none, // Remove default border
          ),
        ),
      ),
    ),
    SizedBox(width: 10),
    IconButton(
      icon: Icon(Icons.send, color: Color.fromRGBO(10, 40, 116, 1)),
      onPressed: _sendMessage,
    ),
  ],
),

          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
