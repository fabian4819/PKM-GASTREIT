import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'package:pkm_gastreit/screen/sign_in_screen.dart';
import 'package:pkm_gastreit/providers/collection_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, String>> _getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {
        'fullName': 'N/A',
        'phoneNumber': 'N/A',
        'avatarUrl': '', // Default or empty avatar URL
        'gender': 'N/A', // Default gender
      };
    }

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final data = userDoc.data() as Map<String, dynamic>;

    return {
      'fullName': data['fullName'] ?? 'N/A',
      'phoneNumber': data['phoneNumber'] ?? 'N/A',
      'avatarUrl': user.photoURL ?? '', // Fetch avatar URL from FirebaseAuth
      'gender': data['gender'] ?? 'N/A', // Fetch gender from Firestore
    };
  }

  Future<void> _signOut() async {
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    collectionProvider
        .clearCollections(); // Clear the collections before signing out

    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SignInScreen(), // Navigate back to the sign-in screen
      ),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.ubuntu(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                // Trigger a rebuild of the screen
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, String>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userData = snapshot.data ??
                  {
                    'fullName': 'N/A',
                    'phoneNumber': 'N/A',
                    'avatarUrl': '',
                    'gender': 'N/A',
                  };

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      backgroundImage: userData['avatarUrl']!.isNotEmpty
                          ? (userData['avatarUrl']!.startsWith('http')
                              ? NetworkImage(userData['avatarUrl']!)
                              : AssetImage(userData['avatarUrl']!)
                                  as ImageProvider)
                          : AssetImage(
                              userData['gender'] == 'Male'
                                  ? 'images/avatar1.png' // Gambar default untuk laki-laki
                                  : 'images/avatar2.png', // Gambar default untuk perempuan
                            ) as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Name: ${userData['fullName']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${user?.email ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: ${userData['phoneNumber']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Change Password'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signOut(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Sign Out'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
