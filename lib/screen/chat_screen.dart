// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
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
      final userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      final userName = userDoc['fullName'] ?? 'Unknown';

      final chatMessage = ChatMessage(
        senderId: user.uid,
        senderName: userName,
        text: _messageController.text,
        timestamp: Timestamp.now(),
        status: 'sent', // Initially set the status to 'sent'
      );

      await _firestore
          .collection('chats')
          .doc(_generateChatId())
          .collection('messages')
          .add(chatMessage.toMap())
          .then((docRef) {
        // Mark the message as delivered after it's sent
        docRef.update({'status': 'delivered'});
      });

      // Clear the message controller only after the message is successfully sent
      _messageController.clear();
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}


  String _generateChatId() {
    final currentUserId = _auth.currentUser!.uid;
    return currentUserId.compareTo(widget.recipientId) > 0
        ? '$currentUserId-${widget.recipientId}'
        : '${widget.recipientId}-$currentUserId';
  }

  Stream<DocumentSnapshot> _getRecipientStatus() {
    return _firestore.collection('users').doc(widget.recipientId).snapshots();
  }

  Widget _buildRecipientStatus(Stream<DocumentSnapshot> stream) {
    return StreamBuilder<DocumentSnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        
        final recipientData = snapshot.data!.data() as Map<String, dynamic>?;
        final userName = recipientData?['fullName'] ?? widget.recipientName;
        final userGender = recipientData?['gender'] ?? 'unknown';
        final userAvatar = recipientData?['avatarUrl'] ?? '';

        final defaultAvatar = userGender.toLowerCase() == 'female'
            ? 'images/avatar2.png' // Default for female
            : 'images/avatar1.png'; // Default for male

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              backgroundImage: userAvatar.isNotEmpty
                  ? (userAvatar.startsWith('http')
                      ? NetworkImage(userAvatar)
                      : AssetImage(userAvatar) as ImageProvider)
                  : AssetImage(defaultAvatar) as ImageProvider,
            ),
            SizedBox(width: 10),
            Text(
              userName,
              style: GoogleFonts.ubuntu(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  // void _sendTypingStatus(bool isTyping) {
  //   _firestore.collection('chats').doc(_generateChatId()).update({
  //     'typing${_auth.currentUser!.uid}': isTyping,
  //   });
  // }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final chatMessage = ChatMessage.fromDocument(doc);
    final isMe = chatMessage.senderId == _auth.currentUser?.uid;
    final isRead = chatMessage.isRead;

    IconData statusIcon;
    Color? iconColor;

    if (isRead) {
      statusIcon = Icons.done_all; // Change to 'read' icon
      iconColor = Colors.blue;
    } else {
      statusIcon = Icons.done_all; // Default to 'sent' icon
      iconColor = Colors.grey;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[200] : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              boxShadow: isMe
                  ? [
                BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2)
              ]
                  : [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit the width of the message
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
                  softWrap: true, // Allow text to wrap
                  overflow: TextOverflow.clip, // Clip the text if it overflows
                ),
              ],
            ),
          ),
          if (isMe)
            Icon(statusIcon, color: iconColor), // Display status icon for sent messages
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _buildRecipientStatus(_getRecipientStatus()),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('chats')
                      .doc(_generateChatId())
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool isTyping = false;
                    if (snapshot.hasData && snapshot.data!.exists) {
                      var data = snapshot.data!.data() as Map<String, dynamic>?;
                      isTyping = data?['typing${widget.recipientId}'] ?? false;
                    }
                    return isTyping
                        ? Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.recipientName} is typing...',
                          style: GoogleFonts.ubuntu(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink();
                  },
                ),
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
                        return Center(
                            child: Text('Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red)));
                      }
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final messageDoc = messages[index];
                          final chatMessage = ChatMessage.fromDocument(messageDoc);

                          final isMe = chatMessage.senderId == _auth.currentUser?.uid;

                          // Mark the message as read if it's not sent by the current user and it's not read yet
                          if (!isMe && !chatMessage.isRead) {
                            _firestore
                                .collection('chats')
                                .doc(_generateChatId())
                                .collection('messages')
                                .doc(messageDoc.id)
                                .update({'isRead': true});
                          }

                          return _buildMessageItem(messageDoc);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
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
                      maxLines: null, // Allow the TextField to expand vertically
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none, // Remove default border
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Color.fromRGBO(10, 40, 116, 1), // Icon color
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
