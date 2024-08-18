import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pkm_gastreit/screen/chat_screen.dart';
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
  String? currentUserRole;

  @override
  void initState() {
    super.initState();
    _getCurrentUserRole();
  }

  Future<void> _getCurrentUserRole() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      final currentUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      setState(() {
        currentUserRole = currentUserDoc.get('role') ?? '';
      });
    }
  }

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

    if (currentUserRole == null) {
      // Show loading indicator until the role is fetched
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Chat',
            style: GoogleFonts.ubuntu(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(10, 40, 116, 1),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chat',
          style: GoogleFonts.ubuntu(
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, isNotEqualTo: currentUserId)
            .where('role',
                isEqualTo: currentUserRole == 'Doctor'
                    ? 'Patient'
                    : 'Doctor') // Filter based on the current user's role
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
              final userData = userDoc.data() as Map<String, dynamic>;

              final userName = userData['fullName'] ?? 'Unknown';
              final userGender = userData['gender'] ?? 'unknown';
              final userAvatar = userData['avatarUrl'] ?? '';
              final userRole = userData['role'] ?? 'Unknown';

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
                        : AssetImage(defaultAvatar)
                            as ImageProvider, // Use default avatar
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text('Tap to start chat'),
                  trailing: Icon(Icons.message,
                      color: Color.fromRGBO(10, 40, 116, 1)),
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
