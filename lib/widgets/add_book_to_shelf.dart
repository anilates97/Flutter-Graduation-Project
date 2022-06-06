import 'package:bitirme_proje/model/categoryModel/categoryModel.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:menu_button/menu_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../themes/themes.dart';

class AddBookToShelfWidget extends ConsumerStatefulWidget {
  String bookID;
  AddBookToShelfWidget({Key? key, required this.bookID}) : super(key: key);

  @override
  _AddBookToShelfWidgetState createState() => _AddBookToShelfWidgetState();
}

class _AddBookToShelfWidgetState extends ConsumerState<AddBookToShelfWidget> {
  final TextEditingController _bookShelfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          child: Container(
        width: 300,
        height: 400,
        child: Column(
          children: [
            CreateDropDownWidget(bookID: widget.bookID),
          ],
        ),
      )),
    );
  }
}

class CreateDropDownWidget extends StatefulWidget {
  String selectedItem = "Yeniler";
  String? bookID;
  CreateDropDownWidget({Key? key, this.bookID}) : super(key: key);

  @override
  State<CreateDropDownWidget> createState() => _CreateDropDownWidgetState();
}

class _CreateDropDownWidgetState extends State<CreateDropDownWidget> {
  FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: firebaseDatabaseService.fetcShelf(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<String> shelf = [];
              snapshot.data!.docs.map((e) {
                shelf.add(e.get('shelfTitle'));
              }).toList();

              return MenuButton(
                selectedItem: widget.selectedItem,
                onItemSelected: (String e) {
                  setState(() {
                    print("SET STATE ÇALIŞTI");
                  });
                  widget.selectedItem = e;
                },
                child: normalChildButton(widget.selectedItem),
                items: shelf,
                itemBuilder: (e) {
                  return Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16),
                      child: Text(e as String));
                },
              );
            } else {
              return Text("HATA");
            }
          },
        ),
        createAddShelfButton(widget.selectedItem)
      ],
    );
  }

  Widget normalChildButton(String selectedItem) {
    return SizedBox(
      width: 120,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Text(selectedItem, overflow: TextOverflow.ellipsis)),
            const SizedBox(
              width: 12,
              height: 17,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createAddShelfButton(String selectedItem) {
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
              firebaseDatabaseService.booksAddToShelf(
                  widget.bookID!, _authService.getCurrentUser()!, selectedItem);
              Fluttertoast.showToast(msg: "Kitap ilgili rafa eklendi");

              Future.delayed(
                Duration(milliseconds: 500),
                () {
                  _buttonController.reset();
                },
              );
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
