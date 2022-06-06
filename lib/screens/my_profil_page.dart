import 'package:bitirme_proje/providers/firebase_database_provider.dart';
import 'package:bitirme_proje/screens/home_page.dart';
import 'package:bitirme_proje/screens/my_library_page.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyProfilPage extends ConsumerStatefulWidget {
  const MyProfilPage({Key? key}) : super(key: key);

  @override
  _MyProfilPageState createState() => _MyProfilPageState();
}

class _MyProfilPageState extends ConsumerState<MyProfilPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _yasController;

  late TextEditingController _ilgiAlanlariController;

  late TextEditingController _emailController;

  late PersistentTabController _controller;

  RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  final FirebaseDatabaseService _service = FirebaseDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    print("MyProfilPage BUILD TETİKLENDİ!!!!!!!!!!!!!!!!");
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_circle_left),
          onPressed: () {
            Navigator.pushNamed(context, '/HomePage');
          },
        ),
        appBar: AppBar(

            //automaticallyImplyLeading: false,
            title: const Text("Profil Sayfası")),
        body: StreamBuilder(
          stream:
              _service.fetchUsersFromFirebase(_authService.getCurrentUser()!),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            _yasController =
                TextEditingController(text: snapshot.data?.get('yas'));
            _ilgiAlanlariController =
                TextEditingController(text: snapshot.data?.get('ilgiAlanlari'));

            _emailController =
                TextEditingController(text: snapshot.data?.get('email'));

            //   print("SNAPSHOOOTT:: " + snapshot.data?.get('email'));
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/loginBackWall.jpg"),
                      fit: BoxFit.fill)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: SweepGradient(startAngle: 2, colors: const [
                          Colors.red,
                          Colors.white,
                          Colors.black
                        ]),
                        boxShadow: const [BoxShadow(blurRadius: 5)]),
                    width: 350,
                    height: 600,
                    child: Center(
                        child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  createLoginPageMail(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  //
                                  createLoginPageYas(),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //
                                  createLoginPageIlgiAlan(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  createLoginPageButton(),
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: collectionReference
                                          .doc(_authService
                                              .getCurrentUser()!
                                              .uid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Kütüphanemi Gizle",
                                                style: GoogleFonts.mali(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                              Switch(
                                                  value: snapshot.data!
                                                      .get('isLibraryPrivate'),
                                                  onChanged: (deger) {
                                                    if (deger) {
                                                      _service.hideLibrary(
                                                          _authService
                                                              .getCurrentUser()!
                                                              .uid);
                                                    } else {
                                                      _service.showLibrary(
                                                          _authService
                                                              .getCurrentUser()!
                                                              .uid);
                                                    }
                                                  }),
                                            ],
                                          );

                                          /* return ElevatedButton(
                                              onPressed: () {
                                                !snapshot.data!
                                                        .get('isLibraryPrivate')
                                                    ? _service.hideLibrary(
                                                        _authService
                                                            .getCurrentUser()!
                                                            .uid)
                                                    : _service.showLibrary(
                                                        _authService
                                                            .getCurrentUser()!
                                                            .uid);
                                              },
                                              child: !snapshot.data!
                                                      .get('isLibraryPrivate')
                                                  ? Text("Kütüphanemi Gizle")
                                                  : Text("Kütüphanemi Göster"));
                                        } else {
                                          return Container();
                                        } */
                                        } else {
                                          return Container();
                                        }
                                      })
                                ],
                              ),
                            ))),
                  ),
                ),
              ),
            );
          },
        ));
  }

  Align createLoginPageButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        child: RoundedLoadingButton(
          color: Color.fromARGB(255, 141, 7, 7),
          width: 500,
          elevation: 4,
          completionDuration: Duration(milliseconds: 1500),
          failedIcon: Icons.error,
          controller: _buttonController,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _buttonController.success();

              Future.delayed(
                Duration(milliseconds: 1000),
                () async {
                  _buttonController.reset();
                  _service.updateUser(
                      userID: _authService.getCurrentUser()!.uid,
                      ilgiAlanlari: _ilgiAlanlariController.text,
                      yas: _yasController.text);
                },
              );
            } else {
              print("HATAAAAAAA");
              _buttonController.error();
              Future.delayed(
                Duration(milliseconds: 1000),
                () {
                  _buttonController.reset();
                },
              );
            }
            print("kayıt ol tıklandı");
          },
          child: Text("Güncelle"),
        ),
      ),
    );
  }

  Container createLoginPageIlgiAlan() {
    return Container(
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            return "Lütfen ilgi alanlarınızı giriniz";
          } else if (value.length < 3) {
            return "İlgi alanı 6 karakterden az olamaz";
          }
        }),
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.favorite,
              color: Colors.black45,
            ),
            icon: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 7, 7),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                )),
            labelText: "İlgi Alanları",
            hintText: "İlgi Alanları",
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _ilgiAlanlariController,
      ),
    );
  }

  Container createLoginPageYas() {
    return Container(
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            return "Lütfen yaşınızı giriniz";
          }
        }),
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.inbox,
              color: Colors.black45,
            ),
            icon: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 7, 7),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.inbox,
                    color: Colors.white,
                  ),
                )),
            labelText: "Yaş",
            hintText: "Yaş",
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _yasController,
      ),
    );
  }

  Container createLoginPageMail() {
    return Container(
      child: TextFormField(
        readOnly: true,
        controller: _emailController,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black45,
            ),
            icon: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 7, 7),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                )),
            labelText: "Email",
            hintText: "Email",
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
      ),
    );
  }

  List<Widget> _createBottomItem() {
    return [
      Icon(Icons.home),
      Icon(Icons.library_books),
      Icon(Icons.account_box)
    ];
  }
}
