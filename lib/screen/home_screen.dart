// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pkm_gastreit/screen/user_list_screen.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pkm_gastreit/screen/profile_screen.dart';
import 'package:pkm_gastreit/screen/landing_screen.dart';
import 'package:pkm_gastreit/screen/information_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pkm_gastreit/widgets/bottom_navigation_bar.dart';
import 'package:pkm_gastreit/providers/collection_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Import untuk SystemNavigator.pop()

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? currentUserRole;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Do nothing, since we are already on HomeScreen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InputScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListScreen()),
        );
    }
  }

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
  
  Future<String> _getUserFullName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = userDoc.data();
        // Pastikan data['fullName'] ada dan bukan null
        return data?['fullName'] ?? user.displayName ?? 'User';
      } catch (e) {
        print('Error fetching user data: $e');
        return 'User'; // Default value in case of error
      }
    }
    return 'User';
  }

  // String _getNameFromEmail(String email) {
  // final namePart = email.split('@').first;
  // final name = namePart
  //     .split('.')
  //     .map((s) => s[0].toUpperCase() + s.substring(1))
  //     .join(' ');
  // return name;
  // }

  // Future<void> _signOut() async {
  // await FirebaseAuth.instance.signOut();
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: Text('Sign Out'),
  //       content: Text('You have successfully signed out.'),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text('OK'),
  //           onPressed: () {
  //             Navigator.of(context).pop(); // Menutup dialog
  //             Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SignInScreen(), // Navigasi kembali ke layar login
  //               ),
  //               (Route<dynamic> route) => false, // Menghapus semua layar sebelumnya
  //             );
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );
  // }

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
            LandingScreen(), // Navigate back to the sign-in screen
      ),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  // Future<void> _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Sign Out'),
  //         content: Text('You have successfully signed out.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) =>
  //                         SignInScreen()), // Navigasi kembali ke layar login
  //               );
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  List<InfoItem> getInfoItems() {
    return [
      InfoItem(
        imageUrl: 'images/informasimenarik1.png',
        title: 'Apa Itu GERD?',
        description:
            'GERD (Gastroesophageal Reflux Disease) adalah kondisi medis yang ditandai dengan aliran balik asam lambung ke dalam kerongkongan, yang menyebabkan iritasi pada dinding kerongkongan. Kondisi ini sering menyebabkan gejala seperti nyeri ulu hati yang tajam, regurgitasi asam, dan sensasi terbakar di dada. Jika tidak diobati, GERD dapat mengakibatkan komplikasi serius, seperti esofagitis atau bahkan kerusakan permanen pada kerongkongan.\n\nGejala GERD dapat bervariasi dari ringan hingga berat. Beberapa orang mungkin mengalami batuk kronis, rasa asam di mulut, atau suara serak. Penting untuk memahami gejala ini dan mencari diagnosis yang tepat untuk mengelola kondisi ini secara efektif.\n\nPerawatan GERD umumnya melibatkan perubahan gaya hidup, obat-obatan, dan dalam kasus tertentu, prosedur medis. Mengidentifikasi pemicu dan mengadopsi kebiasaan makan yang sehat bisa membantu mengurangi gejala dan meningkatkan kualitas hidup.',
      ),
      InfoItem(
        imageUrl: 'images/informasimenarik2.png',
        title: 'Faktor Risiko dan Penyebab GERD',
        description:
            'Beberapa faktor risiko dapat meningkatkan kemungkinan seseorang mengembangkan GERD. Obesitas adalah salah satu penyebab utama, karena tekanan ekstra pada perut dapat memaksa asam lambung kembali ke kerongkongan. Konsumsi alkohol, makanan berlemak, dan makanan pedas juga dapat memicu gejala GERD dengan melemahkan otot sfingter esofagus bagian bawah yang seharusnya mencegah asam lambung naik.\n\nKebiasaan makan seperti makan dalam jumlah besar atau makan sebelum tidur dapat memperburuk kondisi ini. Selain itu, merokok juga diketahui dapat meningkatkan risiko GERD dengan merelaksasi otot sfingter esofagus dan mempengaruhi produksi asam lambung.\n\nMengidentifikasi dan mengelola faktor risiko ini dapat membantu mencegah timbulnya GERD atau mengurangi keparahan gejala. Pendekatan seperti perubahan diet, penurunan berat badan, dan berhenti merokok dapat menjadi langkah penting dalam pengelolaan kondisi ini.',
      ),
      InfoItem(
        imageUrl: 'images/informasimenarik3.png',
        title: 'Gejala GERD dan Cara Mengenalinya',
        description:
            'Gejala GERD sering kali mirip dengan kondisi medis lainnya, sehingga diagnosis yang tepat bisa menantang. Gejala utama GERD termasuk nyeri ulu hati yang terasa seperti terbakar, regurgitasi asam yang mungkin disertai dengan rasa pahit di mulut, dan kesulitan menelan. Gejala ini bisa datang setelah makan atau saat berbaring, dan sering kali terasa lebih buruk pada malam hari.\n\nSelain gejala utama, beberapa penderita mungkin mengalami batuk kronis, suara serak, atau sensasi ada benjolan di tenggorokan. Gejala ini mungkin diperburuk oleh makanan tertentu, seperti makanan pedas atau berlemak, serta minuman beralkohol dan berkafein.\n\nJika Anda mengalami gejala ini secara teratur dan mengganggu aktivitas sehari-hari, penting untuk berkonsultasi dengan dokter untuk evaluasi dan pengelolaan yang tepat. Diagnosis awal dan perawatan yang efektif dapat membantu mengurangi risiko komplikasi dan meningkatkan kualitas hidup.',
      ),
      InfoItem(
        imageUrl: 'images/informasimenarik4.png',
        title: 'Kebiasaan Makan yang Mempengaruhi Kesehatan Lambung',
        description:
            'Kebiasaan makan dapat memainkan peran penting dalam kesehatan lambung dan risiko GERD. Makan terlalu cepat atau dalam porsi besar dapat memberikan tekanan berlebih pada perut, memaksa asam lambung naik ke kerongkongan. Selain itu, makan sebelum tidur dapat meningkatkan risiko refluks asam karena posisi berbaring memudahkan asam untuk naik kembali.\n\nMengonsumsi makanan tertentu seperti makanan pedas, berlemak, atau berkafein dapat memperburuk gejala GERD. Menghindari makanan ini dan menggantinya dengan makanan yang lebih ramah lambung, seperti sayuran, buah-buahan non-asam, dan protein tanpa lemak, dapat membantu mengurangi gejala.\n\nMempraktikkan kebiasaan makan sehat, seperti makan dalam porsi kecil, menghindari makan larut malam, dan mengurangi konsumsi makanan pemicu, dapat membantu menjaga kesehatan lambung dan mencegah timbulnya GERD.',
      ),
      InfoItem(
        imageUrl: 'images/informasimenarik5.png',
        title: 'Pengelolaan GERD melalui Perubahan Gaya Hidup',
        description:
            'Mengelola GERD memerlukan pendekatan komprehensif yang mencakup perubahan gaya hidup. Salah satu langkah utama adalah memperbaiki pola makan, dengan menghindari makanan dan minuman yang dapat memicu gejala, seperti makanan berlemak, pedas, dan alkohol. Memilih makanan yang lebih sehat, seperti makanan rendah asam dan tinggi serat, dapat membantu mengurangi gejala.\n\nSelain perubahan diet, peningkatan aktivitas fisik dan pengelolaan stres juga dapat membantu mengatasi GERD. Aktivitas fisik yang teratur membantu menjaga berat badan yang sehat, sementara teknik pengelolaan stres seperti yoga atau meditasi dapat mengurangi frekuensi gejala.\n\nMengadopsi kebiasaan hidup sehat, seperti makan dengan porsi kecil, menghindari makan sebelum tidur, dan tidak berbaring segera setelah makan, dapat berkontribusi pada pengelolaan GERD yang efektif dan meningkatkan kualitas hidup secara keseluruhan.',
      ),
    ];
  }

  // Future<String> _getUserName() async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   return user?.displayName?.split(' ').first ?? 'User';
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); // This will close the app
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Home',
            style: GoogleFonts.ubuntu(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
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
              icon: Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: _signOut,
            ),
          ],
        ),
        body: Column(
          children: [
            ClipPath(
              clipper: InwardAppBarClipper(),
              child: Container(
                height: 220,
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: _getUserFullName(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black));
                            } else if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Text(
                                  'Hi, ${snapshot.data}!',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              );
                            } else {
                              return Text('Hi, User!',
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black));
                            }
                          },
                        ),
                        Text(
                          currentUserRole == 'Doctor'
                              ? 'Pantau Lambung Pasien'
                              : 'Pantau Kesehatan Lambungmu',
                          style: GoogleFonts.ubuntu(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF041E60)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
  child: SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
  padding: EdgeInsets.all(0.0), // Hilangkan padding di sekitar tombol
  child: Align(
    alignment: Alignment.topCenter,
    child: OutlinedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserListScreen()),
        );
      },
      icon: Icon(Icons.message_rounded, color: Colors.blue),
      label: Text(
        currentUserRole == 'Doctor'
            ? 'Konsultasi Pasien'
            : 'Konsultasi Dokter',
        style: GoogleFonts.ubuntu(
          fontSize: 18, // Ukuran font
          fontWeight: FontWeight.bold, // Ketebalan font
          color: Colors.blue, // Warna font
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.blue[100], // Tombol akan memiliki latar belakang putih
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        side: BorderSide(color: Colors.blue, width: 2), // Border berwarna biru
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Sesuaikan padding
        minimumSize: Size(370, 50), // Atur lebar dan tinggi tombol
      ),
    ),
  ),
),




          SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CategoryButton(
                            image: Image.asset(
                              "images/Icon-InputCitra.png",
                              width: 130,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            label: 'Input Citra',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InputScreen(),
                                ),
                              );
                            },
                          ),
                          CategoryButton(
                            image: Image.asset(
                              "images/Icon-HasilCitra.png",
                              width: 130,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            label: 'Hasil Citra',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 380,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  'Informasi Menarik',
                                  style: GoogleFonts.ubuntu(
                                    color: Color(0xFF041E60),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  children: getInfoItems()
                                      .map((item) => InfoCard(item: item))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final Image image;
  final String label;
  final VoidCallback onPressed;

  CategoryButton({
    required this.image,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.all(20),
            side: BorderSide(color: Colors.blue, width: 2),
          ),
          child: Column(
            children: [
              image,
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 20, color: Colors.blue)),
            ],
          ),
        ),
      ],
    );
  }
}


class InwardAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height - 100);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


class InfoItem {
  final String imageUrl;
  final String title;
  final String description;

  InfoItem({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

class InfoCard extends StatelessWidget {
  final InfoItem item;

  InfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InformationScreen(
                imageUrl: item.imageUrl,
                title: item.title,
                description: item.description,
              ),
            ),
          );
        },
        child: Container(
          width: 150,
          height: 200,
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 100,
                    width: 600,
                    child: Image.asset(
                      item.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
