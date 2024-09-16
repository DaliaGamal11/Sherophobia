import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchViewModel extends ChangeNotifier {
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

  // Getters
  String get searchQuery => _searchQuery;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  // Update the search query
  void updateSearchQuery(String query) {
    _searchQuery = query.trim(); // Ensure no leading/trailing whitespace affects search
    _performSearch();
    notifyListeners();
  }

  // Perform search operation
  void _performSearch() async {
    if (_searchQuery.isEmpty) {
      _searchResults = [];
    } else {
      try {
        // Search in 'Pharmacy' collection
        final pharmacySnapshot = await FirebaseFirestore.instance
            .collection('Pharmacy')
            .where('searchableFields', arrayContains: _searchQuery.toLowerCase())
            .get();

        // Search in 'hospital' collection
        final hospitalSnapshot = await FirebaseFirestore.instance
            .collection('hospital')
            .where('searchableFields', arrayContains: _searchQuery.toLowerCase())
            .get();

        // Combine results from both collections
        List<Map<String, dynamic>> combinedResults = [];
        combinedResults.addAll(pharmacySnapshot.docs.map((doc) => doc.data()));
        combinedResults.addAll(hospitalSnapshot.docs.map((doc) => doc.data()));

        _searchResults = combinedResults;
      } catch (e) {
        print('Error searching: $e');
        _searchResults = [];
      }
    }
    notifyListeners();
  }
}
