import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pkm_gastreit/screen/chat_screen.dart';
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/input_screen.dart';
import 'package:provider/provider.dart';
import 'package:pkm_gastreit/providers/collection_provider.dart';
import 'dart:core';
import 'package:pkm_gastreit/widgets/bottom_navigation_bar.dart'; // Import widget bottom navigation bar



class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> reportDataList = [];
  List<String> documentIds = [];
  String computationTime = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    Stopwatch stopwatch = Stopwatch()..start();
    final collectionProvider = Provider.of<CollectionProvider>(context, listen: false);
    List<String> selectedCollections = collectionProvider.selectedCollections;

    List<Map<String, dynamic>> tempDataList = [];
    List<String> tempDocumentIds = [];

    for (String collectionName in selectedCollections) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('pH_data').doc(collectionName).get();
        if (snapshot.exists) {
          tempDataList.add(snapshot.data() as Map<String, dynamic>);
          tempDocumentIds.add(snapshot.id);
        }
      } catch (e) {
        print(e);
      }
    }

    stopwatch.stop();
    setState(() {
      reportDataList = tempDataList;
      documentIds = tempDocumentIds;
      computationTime = 'Time taken to fetch data: ${stopwatch.elapsedMilliseconds} ms';
      isLoading = false;
    });
  }

  void _deleteCollection(String collectionName) {
    final collectionProvider = Provider.of<CollectionProvider>(context, listen: false);
    collectionProvider.removeCollection(collectionName);

    setState(() {
      int index = documentIds.indexOf(collectionName);
      if (index != -1) {
        reportDataList.removeAt(index);
        documentIds.removeAt(index);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Collection removed from the list')));
  }

  Future<void> _showDeleteConfirmationDialog(String collectionName) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to remove this collection from the list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCollection(collectionName);
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
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
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
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
              color: Colors.white),
        ),
        leadingWidth: 100,
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      body: Column(
        children: [
          if (computationTime.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                computationTime,
                style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black54),
              ),
            ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : reportDataList.isEmpty
                    ? Center(child: Text('No data available', style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.black54)))
                    : ListView.builder(
                        itemCount: reportDataList.length,
                        itemBuilder: (context, index) {
                          var reportData = reportDataList[index];
                          var documentId = documentIds[index];
                          return Card(
                            margin: EdgeInsets.all(10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
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
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmationDialog(documentId),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
