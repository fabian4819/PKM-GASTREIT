import 'package:flutter/material.dart';

class CollectionProvider with ChangeNotifier {
  List<String> _selectedCollections = [];

  List<String> get selectedCollections => _selectedCollections;

  void addCollection(String collectionName) {
    if (!_selectedCollections.contains(collectionName)) {
      _selectedCollections.add(collectionName);
      notifyListeners();
    }
  }

  void removeCollection(String collectionName) {
    if (_selectedCollections.contains(collectionName)) {
      _selectedCollections.remove(collectionName);
      notifyListeners();
    }
  }

  // Method to replace all selected collections
  void replaceCollections(List<String> collections) {
    _selectedCollections = collections;
    notifyListeners();
  }

  // Method to clear all selected collections
  void clearCollections() {
    _selectedCollections.clear();
    notifyListeners();
  }
}
