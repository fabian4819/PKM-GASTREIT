import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:provider/provider.dart';
import 'package:pkm_gastreit/providers/collection_provider.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> reportDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  void _fetchReportData() async {
    final collectionProvider = Provider.of<CollectionProvider>(context, listen: false);
    List<String> selectedCollections = collectionProvider.selectedCollections;

    for (String collectionName in selectedCollections) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('pH_data').doc(collectionName).get();
        if (snapshot.exists) {
          setState(() {
            reportDataList.add(snapshot.data() as Map<String, dynamic>);
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InputScreen()),
        );
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Report',
          style: GoogleFonts.ubuntu(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(10, 40, 116, 1)),
        ),
        leadingWidth: 100,
        backgroundColor: Colors.blue,
      ),
      body: reportDataList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reportDataList.length,
              itemBuilder: (context, index) {
                var reportData = reportDataList[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (reportData['plot_url'] != null)
                          Image.network(reportData['plot_url']),
                        if (reportData['mean_ph'] != null)
                          Text(
                            'Mean pH: ${reportData['mean_ph']}',
                            style: GoogleFonts.ubuntu(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/home_light.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/input_light.png')),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/hasil_black.png')),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}