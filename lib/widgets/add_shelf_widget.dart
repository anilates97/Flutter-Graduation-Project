import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../model/shelfModel/shelfModel.dart';
import '../services/firebase_database_services.dart';

class AddBookShelfPage extends StatefulWidget {
  const AddBookShelfPage({Key? key}) : super(key: key);

  @override
  State<AddBookShelfPage> createState() => _AddBookShelfPageState();
}

class _AddBookShelfPageState extends State<AddBookShelfPage> {
  final TextEditingController _bookShelfController = TextEditingController();
  FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          child: Container(
        width: 300,
        height: 400,
        child: Column(
          children: [createShelfName(), createAddShelfButton()],
        ),
      )),
    );
  }

  Container createShelfName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Lütfen alanı boş bırakmayınız';
          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Hatalı raf adı";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelText: "Raf Ad",
            hintText: "Raf Ad",
            icon: Container(
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FaIcon(
                    FontAwesomeIcons.bookOpen,
                    color: Colors.white,
                  ),
                )),
            labelStyle: TextStyle(color: Colors.black87),
            hintStyle: TextStyle(color: Colors.black87),
            errorStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: _bookShelfController,
      ),
    );
  }

  Widget createAddShelfButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedLoadingButton(
            width: 500,
            elevation: 4,
            completionDuration: Duration(milliseconds: 2000),
            color: Colors.red,
            failedIcon: Icons.error,
            controller: _buttonController,
            onPressed: () async {
              _buttonController.success();
              firebaseDatabaseService
                  .addShelf(Shelf(_bookShelfController.text, ""));
              Fluttertoast.showToast(msg: "Raf Eklendi");
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Ekle",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
