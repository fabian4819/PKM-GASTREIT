import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pkm_gastreit/screen/profile_screen.dart'; // Import layar profil
import 'package:pkm_gastreit/screen/sign_in_screen.dart'; // Import layar login
import 'package:pkm_gastreit/screen/information_screen.dart'; // Import layar detail informasi

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
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()), // Navigasi kembali ke layar login
    );
  }

  List<InfoItem> getInfoItems() {
    return [
      InfoItem(
  imageUrl: 'images/informasimenarik1.png',
  title: 'Apa Itu GERD?',
  description: 'GERD (Gastroesophageal Reflux Disease) adalah kondisi medis yang ditandai dengan aliran balik asam lambung ke dalam kerongkongan, yang menyebabkan iritasi pada dinding kerongkongan. Kondisi ini sering menyebabkan gejala seperti nyeri ulu hati yang tajam, regurgitasi asam, dan sensasi terbakar di dada. Jika tidak diobati, GERD dapat mengakibatkan komplikasi serius, seperti esofagitis atau bahkan kerusakan permanen pada kerongkongan.\n\nGejala GERD dapat bervariasi dari ringan hingga berat. Beberapa orang mungkin mengalami batuk kronis, rasa asam di mulut, atau suara serak. Penting untuk memahami gejala ini dan mencari diagnosis yang tepat untuk mengelola kondisi ini secara efektif.\n\nPerawatan GERD umumnya melibatkan perubahan gaya hidup, obat-obatan, dan dalam kasus tertentu, prosedur medis. Mengidentifikasi pemicu dan mengadopsi kebiasaan makan yang sehat bisa membantu mengurangi gejala dan meningkatkan kualitas hidup.',
),
InfoItem(
  imageUrl: 'images/informasimenarik2.png',
  title: 'Faktor Risiko dan Penyebab GERD',
  description: 'Beberapa faktor risiko dapat meningkatkan kemungkinan seseorang mengembangkan GERD. Obesitas adalah salah satu penyebab utama, karena tekanan ekstra pada perut dapat memaksa asam lambung kembali ke kerongkongan. Konsumsi alkohol, makanan berlemak, dan makanan pedas juga dapat memicu gejala GERD dengan melemahkan otot sfingter esofagus bagian bawah yang seharusnya mencegah asam lambung naik.\n\nKebiasaan makan seperti makan dalam jumlah besar atau makan sebelum tidur dapat memperburuk kondisi ini. Selain itu, merokok juga diketahui dapat meningkatkan risiko GERD dengan merelaksasi otot sfingter esofagus dan mempengaruhi produksi asam lambung.\n\nMengidentifikasi dan mengelola faktor risiko ini dapat membantu mencegah timbulnya GERD atau mengurangi keparahan gejala. Pendekatan seperti perubahan diet, penurunan berat badan, dan berhenti merokok dapat menjadi langkah penting dalam pengelolaan kondisi ini.',
),
InfoItem(
  imageUrl: 'images/informasimenarik1.png',
  title: 'Gejala GERD dan Cara Mengenalinya',
  description: 'Gejala GERD sering kali mirip dengan kondisi medis lainnya, sehingga diagnosis yang tepat bisa menantang. Gejala utama GERD termasuk nyeri ulu hati yang terasa seperti terbakar, regurgitasi asam yang mungkin disertai dengan rasa pahit di mulut, dan kesulitan menelan. Gejala ini bisa datang setelah makan atau saat berbaring, dan sering kali terasa lebih buruk pada malam hari.\n\nSelain gejala utama, beberapa penderita mungkin mengalami batuk kronis, suara serak, atau sensasi ada benjolan di tenggorokan. Gejala ini mungkin diperburuk oleh makanan tertentu, seperti makanan pedas atau berlemak, serta minuman beralkohol dan berkafein.\n\nJika Anda mengalami gejala ini secara teratur dan mengganggu aktivitas sehari-hari, penting untuk berkonsultasi dengan dokter untuk evaluasi dan pengelolaan yang tepat. Diagnosis awal dan perawatan yang efektif dapat membantu mengurangi risiko komplikasi dan meningkatkan kualitas hidup.',
),
InfoItem(
  imageUrl: 'images/informasimenarik2.png',
  title: 'Kebiasaan Makan yang Mempengaruhi Kesehatan Lambung',
  description: 'Kebiasaan makan dapat memainkan peran penting dalam kesehatan lambung dan risiko GERD. Makan terlalu cepat atau dalam porsi besar dapat memberikan tekanan berlebih pada perut, memaksa asam lambung naik ke kerongkongan. Selain itu, makan sebelum tidur dapat meningkatkan risiko refluks asam karena posisi berbaring memudahkan asam untuk naik kembali.\n\nMengonsumsi makanan tertentu seperti makanan pedas, berlemak, atau berkafein dapat memperburuk gejala GERD. Menghindari makanan ini dan menggantinya dengan makanan yang lebih ramah lambung, seperti sayuran, buah-buahan non-asam, dan protein tanpa lemak, dapat membantu mengurangi gejala.\n\nMempraktikkan kebiasaan makan sehat, seperti makan dalam porsi kecil, menghindari makan larut malam, dan mengurangi konsumsi makanan pemicu, dapat membantu menjaga kesehatan lambung dan mencegah timbulnya GERD.',
),
InfoItem(
  imageUrl: 'images/informasimenarik1.png',
  title: 'Pengelolaan GERD melalui Perubahan Gaya Hidup',
  description: 'Mengelola GERD memerlukan pendekatan komprehensif yang mencakup perubahan gaya hidup. Salah satu langkah utama adalah memperbaiki pola makan, dengan menghindari makanan dan minuman yang dapat memicu gejala, seperti makanan berlemak, pedas, dan alkohol. Memilih makanan yang lebih sehat, seperti makanan rendah asam dan tinggi serat, dapat membantu mengurangi gejala.\n\nSelain perubahan diet, peningkatan aktivitas fisik dan pengelolaan stres juga dapat membantu mengatasi GERD. Aktivitas fisik yang teratur membantu menjaga berat badan yang sehat, sementara teknik pengelolaan stres seperti yoga atau meditasi dapat mengurangi frekuensi gejala.\n\nMengadopsi kebiasaan hidup sehat, seperti makan dengan porsi kecil, menghindari makan sebelum tidur, dan tidak berbaring segera setelah makan, dapat berkontribusi pada pengelolaan GERD yang efektif dan meningkatkan kualitas hidup secara keseluruhan.',
),

    ];
  }

  Future<String> _getUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.displayName?.split(' ').first ?? 'User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: GoogleFonts.ubuntu(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
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
                  child: FutureBuilder<String>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Hi, loading...\nWelcome back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Hi, User\nWelcome back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          'Hi, ${snapshot.data}\nWelcome back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Rekam Citra Medis'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CategoryButton(
                          image: Image.asset(
                            "images/Icon-InputCitra.png",
                            width: 100,
                            height: 100,
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
                            width: 100,
                            height: 100,
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
                    SizedBox(height: 40),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Informasi Menarik',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 200, // Set the height for horizontal scroll area
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              children: getInfoItems().map((item) => InfoCard(item: item)).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/home_black.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/input_light.png')),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/hasil_light.png')),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                item.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
