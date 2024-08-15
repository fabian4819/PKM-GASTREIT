// screen/user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for current user
import 'package:pkm_gastreit/screen/chat_screen.dart'; // Import ChatScreen
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';
import 'package:pkm_gastreit/widgets/bottom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
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

  @override
  Widget build(BuildContext context) {
    // Get the current user ID
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chat',
          style: GoogleFonts.ubuntu(
            fontSize: 25, 
            fontWeight: FontWeight.w600, 
            color: Colors.white
          ),
        ),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, isNotEqualTo: currentUserId) // Exclude current user
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index];
              final userName = userDoc.get('fullName') ?? 'Unknown';

              // Get the gender and avatar URL, handle missing fields
              final userData = userDoc.data() as Map<String, dynamic>?; 
              final userGender = userData?['gender'] ?? 'unknown';
              final userAvatar = userData?['avatarUrl'] ?? '';

              // Determine the default avatar based on gender
              final defaultAvatar = userGender.toLowerCase() == 'female'
                  ? 'images/avatar2.png' // Default for female
                  : 'images/avatar1.png'; // Default for male

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    backgroundImage: userAvatar.isNotEmpty
                        ? (userAvatar.startsWith('http')
                            ? NetworkImage(userAvatar)
                            : AssetImage(userAvatar) as ImageProvider)
                        : AssetImage(defaultAvatar) as ImageProvider, // Use default avatar
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text('Tap to start chat'),
                  trailing: Icon(Icons.message, color: Color.fromRGBO(10, 40, 116, 1)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          recipientId: userDoc.id,
                          recipientName: userName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
