import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersRatingAllBooksPage extends StatefulWidget {
  const UsersRatingAllBooksPage({Key? key}) : super(key: key);

  @override
  State<UsersRatingAllBooksPage> createState() =>
      _UsersRatingAllBooksPageState();
}

class _UsersRatingAllBooksPageState extends State<UsersRatingAllBooksPage> {
  final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Kullanıcı Değerlendirmesi"),
    );
  }
}
