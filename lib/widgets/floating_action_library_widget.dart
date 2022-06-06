import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/widgets/create_speed_children_items_library.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'create_speed_children_items_home.dart';

class FloatinButtonsLibrary extends StatefulWidget {
  String bookID;
  FloatinButtonsLibrary({Key? key, required this.bookID}) : super(key: key);

  @override
  _FloatinButtonsHomeState createState() => _FloatinButtonsHomeState();
}

class _FloatinButtonsHomeState extends State<FloatinButtonsLibrary> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return CreateSpeedChildrenLibrary(
      bookID: widget.bookID,
      user: _auth,
    );
  }
}
