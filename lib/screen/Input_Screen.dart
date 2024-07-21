import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:pkm_gastreit/providers/collection_provider.dart';
import 'dart:core'; // Import untuk Stopwatch
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';

Future<List<String>> fetchCollectionNames() async {
  Stopwatch stopwatch = Stopwatch()..start(); // Mulai stopwatch
  List<String> collectionNames = [];
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pH_data').get();
    for (var doc in snapshot.docs) {
      collectionNames.add(doc.id);
    }
  } catch (e) {
    print(e);
  } finally {
    stopwatch.stop(); // Hentikan stopwatch
    print('Time taken to fetch collections: ${stopwatch.elapsedMilliseconds} ms');
  }
  return collectionNames;
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _selectedIndex = 0;
  List<String> _allCollections = [];
  List<String> _filteredCollections = [];
  TextEditingController _searchController = TextEditingController();
  String _computationTime = ''; // Variabel untuk menyimpan waktu komputasi

  @override
  void initState() {
    super.initState();
    _loadCollections();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadCollections() async {
    Stopwatch stopwatch = Stopwatch()..start(); // Mulai stopwatch
    List<String> collections = await fetchCollectionNames();
    setState(() {
      _allCollections = collections;
      _filteredCollections = collections;
      stopwatch.stop(); // Hentikan stopwatch
      _computationTime = 'Time taken to load collections: ${stopwatch.elapsedMilliseconds} ms'; // Simpan waktu komputasi
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    setState(() {
      _filteredCollections = _allCollections
          .where((collection) => collection.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportScreen()),
        );
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addCollection(String collectionName) {
    final collectionProvider = Provider.of<CollectionProvider>(context, listen: false);
    if (!collectionProvider.selectedCollections.contains(collectionName)) {
      collectionProvider.addCollection(collectionName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$collectionName added to the list')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$collectionName is already added')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final collectionProvider = Provider.of<CollectionProvider>(context);
    final selectedCollections = collectionProvider.selectedCollections;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Input',
          style: GoogleFonts.ubuntu(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        leadingWidth: 100,
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/home_light.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/input_black.png')),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/hasil_light.png')),
            label: 'Report',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromRGBO(10, 40, 116, 1),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color.fromRGBO(10, 40, 116, 1)),
                  hintText: 'Search Patient Name...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Menampilkan waktu komputasi di body
          if (_computationTime.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _computationTime,
                style: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black54),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCollections.length,
              itemBuilder: (BuildContext context, int index) {
                String collectionName = _filteredCollections[index];
                bool isAdded = selectedCollections.contains(collectionName);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      collectionName,
                      style: GoogleFonts.ubuntu(fontSize: 16),
                    ),
                    trailing: isAdded
                        ? Icon(Icons.check, color: Colors.green)
                        : IconButton(
                            icon: Icon(Icons.add, color: Color.fromRGBO(10, 40, 116, 1)),
                            onPressed: () => _addCollection(collectionName),
                          ),
                    onTap: () {
                      // Optional: Perform some action on tap
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
