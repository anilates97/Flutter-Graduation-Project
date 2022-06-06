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

class ContactUsPage extends ConsumerStatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends ConsumerState<ContactUsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _oneriController;

  late TextEditingController _sorunController;

  late TextEditingController _emailController;

  late PersistentTabController _controller;

  RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  final FirebaseDatabaseService _service = FirebaseDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("books");

  @override
  Widget build(BuildContext context) {
    _oneriController = TextEditingController(text: "Anıl Ateş");
    _sorunController = TextEditingController(text: "05318308542");
    _emailController =
        TextEditingController(text: "kutuphanesimulasyonu@gmail.com");
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
            title: const Text("Bize Ulaşın")),
        body: Container(
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
                    gradient: SweepGradient(
                        startAngle: 2,
                        colors: const [Colors.red, Colors.white, Colors.black]),
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
                              //
                              createLoginPageYas(),
                              SizedBox(
                                height: 15,
                              ),
                              createLoginPageMail(),
                              SizedBox(
                                height: 15,
                              ),

                              //
                              createLoginPageIlgiAlan(),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ))),
              ),
            ),
          ),
        ));
  }

  Container createLoginPageIlgiAlan() {
    return Container(
      child: TextFormField(
        readOnly: true,
        validator: ((value) {}),
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
            labelText: "Sorun Bildir",
            hintText: "Sorun Bildir",
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _sorunController,
      ),
    );
  }

  Container createLoginPageYas() {
    return Container(
      child: TextFormField(
        readOnly: true,
        validator: ((value) {}),
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
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _oneriController,
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
