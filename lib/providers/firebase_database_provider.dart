import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

FirebaseDatabaseService databaseService = FirebaseDatabaseService();

Stream<QuerySnapshot<Map<String, dynamic>>>? getBooksByShelf(
    User user, String shelfName) {
  return databaseService.fetchBooksByShelf(user, shelfName);
}
