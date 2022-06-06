import 'package:bitirme_proje/model/categoryModel/categoryModel.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:menu_button/menu_button.dart';

import '../themes/themes.dart';

class AddCategoriesWidget extends StatefulWidget {
  AddCategoriesWidget({Key? key}) : super(key: key);

  @override
  State<AddCategoriesWidget> createState() => _AddCategoriesWidgetState();
}

class _AddCategoriesWidgetState extends State<AddCategoriesWidget> {
  final TextEditingController _bookCategoryController = TextEditingController();
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
          children: [createCategoryName(), createAddCategoryButton()],
        ),
      )),
    );
  }

  Container createCategoryName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Lütfen alanı boş bırakmayınız';
          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Hatalı kategori adı";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelText: "Kategori Ad",
            hintText: "Kategori Ad",
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
        controller: _bookCategoryController,
      ),
    );
  }

  Widget createAddCategoryButton() {
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
                  .addCategory(Category(_bookCategoryController.text, ""));
              Fluttertoast.showToast(msg: "Kategori Eklendi");
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
