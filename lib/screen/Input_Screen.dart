import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:pkm_gastreit/providers/collection_provider.dart';
import 'package:pkm_gastreit/screen/home_screen.dart';
import 'package:pkm_gastreit/screen/report_screen.dart';
import 'package:pkm_gastreit/widgets/bottom_navigation_bar.dart';
import 'package:pkm_gastreit/screen/user_list_screen.dart';
import 'package:pkm_gastreit/screen/chat_screen.dart';


class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  int _selectedIndex = 1;
  List<Map<String, dynamic>> _allCollections = [];
  List<Map<String, dynamic>> _filteredCollections = [];
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
    List<Map<String, dynamic>> collections = await _fetchCollectionDetails();
    setState(() {
      _allCollections = collections;
      _filteredCollections = collections;
      stopwatch.stop(); // Hentikan stopwatch
      _computationTime =
          'Time taken to load collections: ${stopwatch.elapsedMilliseconds} ms'; // Simpan waktu komputasi
    });
    print('Loaded collections: ${_allCollections.length}');
    _loadSelectedCollections(); // Load selected collections
  }

  Future<List<Map<String, dynamic>>> _fetchCollectionDetails() async {
    Stopwatch stopwatch = Stopwatch()..start(); // Mulai stopwatch
    List<Map<String, dynamic>> collectionDetails = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('pH_data').get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (doc.exists && data.containsKey('pin')) {
          collectionDetails
              .add({'id': doc.id, 'pin': data['pin'].toString().trim()});
        } else {
          print('Document does not exist or missing pin field: ${doc.id}');
        }
      }
    } catch (e) {
      print('Error fetching collections: $e');
    } finally {
      stopwatch.stop(); // Hentikan stopwatch
      print(
          'Time taken to fetch collections: ${stopwatch.elapsedMilliseconds} ms');
    }
    return collectionDetails;
  }

  Future<void> _loadSelectedCollections() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists && doc.data() != null) {
        List<String> selectedCollections = List<String>.from(
            (doc.data() as Map<String, dynamic>)['selectedCollections'] ?? []);
        Provider.of<CollectionProvider>(context, listen: false)
            .replaceCollections(selectedCollections);
        // Optionally, update the UI if necessary
        setState(() {
          // Any additional UI updates if needed
        });
      }
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    setState(() {
      _filteredCollections = _allCollections
          .where((collection) =>
              collection['id'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _saveSelectedCollectionsToFirestore() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final collectionProvider =
          Provider.of<CollectionProvider>(context, listen: false);

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'selectedCollections': collectionProvider.selectedCollections,
      }).catchError((error) async {
        // Jika dokumen belum ada, buat dokumen baru
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'selectedCollections': collectionProvider.selectedCollections,
        }, SetOptions(merge: true));
      });
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addCollection(String collectionName) async {
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    final collectionDetails = _allCollections
        .firstWhere((collection) => collection['id'] == collectionName);

    if (!collectionProvider.selectedCollections.contains(collectionName)) {
      String? inputPin = await _showPinDialog();
      String firestorePin = collectionDetails['pin']
          .toString()
          .trim(); // Pastikan tipe data adalah String dan hapus whitespace
      inputPin = inputPin?.trim(); // Hapus whitespace dari input pengguna

      print('Input PIN: $inputPin'); // Log input PIN
      print('Firestore PIN: $firestorePin'); // Log Firestore PIN

      if (inputPin == firestorePin) {
        collectionProvider.addCollection(collectionName);
        await _saveSelectedCollectionsToFirestore(); // Simpan ke Firestore setelah menambahkan koleksi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$collectionName added to the list')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect PIN')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$collectionName is already added')),
      );
    }
  }

  Future<String?> _showPinDialog() {
    TextEditingController pinController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter PIN'),
          content: TextField(
            controller: pinController,
            decoration: InputDecoration(hintText: 'PIN'),
            obscureText: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(pinController.text);
              },
            ),
          ],
        );
      },
    );
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
              fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        leadingWidth: 100,
        backgroundColor: Color.fromRGBO(10, 40, 116, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _loadCollections(); // Memuat ulang koleksi
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
                  prefixIcon:
                      Icon(Icons.search, color: Color.fromRGBO(10, 40, 116, 1)),
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
                String collectionName = _filteredCollections[index]['id'];
                bool isAdded = selectedCollections.contains(collectionName);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                            icon: Icon(Icons.add,
                                color: Color.fromRGBO(10, 40, 116, 1)),
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
