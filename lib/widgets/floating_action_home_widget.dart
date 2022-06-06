import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';

import 'package:flutter/material.dart';

import 'create_speed_children_items_home.dart';

class FloatinButtonsHome extends StatefulWidget {
  List<BooksModel> booksModel;
  String bookQuery;
  FloatinButtonsHome(
      {Key? key, required this.booksModel, required this.bookQuery})
      : super(key: key);

  @override
  _FloatinButtonsHomeState createState() => _FloatinButtonsHomeState();
}

class _FloatinButtonsHomeState extends State<FloatinButtonsHome> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return CreateSpeedChildrenHome(
      gelenQuery: widget.bookQuery,
      user: _auth,
      booksModel: widget.booksModel,
    );
  }
}
