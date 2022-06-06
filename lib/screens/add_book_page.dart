import 'dart:io';

import 'package:bitirme_proje/providers/firebase_auth_providers.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddBookPage extends ConsumerStatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends ConsumerState<AddBookPage> {
  FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bookNameController = TextEditingController();

  final TextEditingController _bookDescriptionController =
      TextEditingController();

  final TextEditingController _bookAuthorController = TextEditingController();

  final TextEditingController _bookPublishDateController =
      TextEditingController();

  final TextEditingController _bookPageCountController =
      TextEditingController();

  final TextEditingController _bookLanguageContoller = TextEditingController();

  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(firebaseAuthServiceProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Kitap Ekle"),
        //automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          createAddBookBackWall(context, _auth),
        ],
      ),
    );
  }

  Container createAddBookBackWall(
      BuildContext context, FirebaseAuthService _auth) {
    return Container(
      height: 750,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/back.jpg"),
        fit: BoxFit.fill,
      )),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 350,
            height: 620,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: SweepGradient(
                    colors: const [Colors.red, Colors.white, Colors.black]),
                boxShadow: const [BoxShadow(blurRadius: 5)]),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      createImageProfile(context),
                      const SizedBox(
                        height: 10,
                      ),
                      createBookName(),
                      const SizedBox(
                        height: 10,
                      ),
                      createDescription(),
                      const SizedBox(
                        height: 10,
                      ),
                      createBookAuthor(),
                      const SizedBox(
                        height: 10,
                      ),
                      createBookPageCount(),
                      const SizedBox(
                        height: 10,
                      ),
                      createBookLanguage(),
                      const SizedBox(
                        height: 10,
                      ),
                      createAddButton(
                          _auth.getCurrentUser(), _bookNameController.text),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void addImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile?.path != null) {
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    }
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Kitabın kapak resmini seçiniz",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                  onPressed: (() {
                    addImage(ImageSource.camera);
                    Navigator.pop(context);
                  }),
                  icon: const Icon(Icons.camera),
                  label: const Text("Kamera")),
              TextButton.icon(
                  onPressed: (() {
                    addImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }),
                  icon: const Icon(Icons.image),
                  label: const Text("Galeri")),
            ],
          )
        ],
      ),
    );
  }

  Widget createAddButton(User? currentUser, String bookName) {
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
              if (_formKey.currentState!.validate()) {
                if (_imageFile != null) {
                  _buttonController.success();
                  Future.delayed(
                    Duration(milliseconds: 2000),
                    () {
                      firebaseDatabaseService.uploadImageToFirebase(
                          bookName, currentUser!.uid, _imageFile!);
                      firebaseDatabaseService.localBookCreate(
                          currentUser.uid,
                          _imageFile!,
                          _bookNameController.text,
                          _bookDescriptionController.text,
                          [_bookAuthorController.text],
                          _bookPublishDateController.text,
                          _bookLanguageContoller.text,
                          int.parse(_bookPageCountController.text));

                      Navigator.pop(context);
                    },
                  );
                } else {
                  Fluttertoast.showToast(msg: "Resim seçmediniz");
                  _buttonController.error();
                  Future.delayed(Duration(milliseconds: 1000),
                      () => _buttonController.reset());
                }
              } else {
                print("HATAAAAAAA");
                _buttonController.error();
                Future.delayed(
                  Duration(milliseconds: 1000),
                  () => _buttonController.reset(),
                );
              }
              print("Kitap ekle tıklandı");
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

  Container createBookAuthor() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Lütfen alanı boş bırakmayınız';
          } else if (value.length < 6) {
            return "Minimum 6 karakter girmelisiniz";
          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Hatalı Yazar adı";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelText: "Yazar",
            labelStyle: TextStyle(color: Colors.black87),
            errorStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            icon: Container(
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_box,
                    color: Colors.white,
                  ),
                )),
            hintText: "Yazar",
            hintStyle: TextStyle(color: Colors.black87),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _bookAuthorController,
      ),
    );
  }

  Container createDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Lütfen alanı boş bırakmayınız';
          } else if (value.length < 10) {
            return "Minimum 10 karakter girmelisiniz";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelText: "Açıklama",
            hintText: "Açıklama",
            errorStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            icon: Container(
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                  ),
                )),
            hintStyle: TextStyle(color: Colors.black87),
            labelStyle: TextStyle(color: Colors.black87),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _bookDescriptionController,
      ),
    );
  }

  Container createBookName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Lütfen alanı boş bırakmayınız';
          } else if (value.length < 6) {
            return "Minimum 6 karakter girmelisiniz";
          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Hatalı kitap adı";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            labelText: "Kitap Ad",
            hintText: "Kitap Ad",
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
        controller: _bookNameController,
      ),
    );
  }

  Widget createImageProfile(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: (() {
              showModalBottomSheet(
                  context: context, builder: ((_) => bottomSheet(context)));
            }),
            child: CircleAvatar(
              radius: 80,
              backgroundImage: _imageFile != null
                  ? FileImage(File(_imageFile!.path))
                  : const AssetImage("assets/images/default_book.png")
                      as ImageProvider,
            ),
          ),
          const Positioned(
              bottom: 20,
              right: 20,
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28,
              ))
        ],
      ),
    );
  }

  Widget createBookPageCount() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "Sayfa Sayısı",
            hintText: "Sayfa Sayısı",
            icon: Container(
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.numbers,
                    color: Colors.white,
                  ),
                )),
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black87),
            labelStyle: TextStyle(color: Colors.black87),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _bookPageCountController,
      ),
    );
  }

  Widget createBookLanguage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "Dil",
            hintText: "Dil",
            icon: Container(
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                )),
            errorStyle: TextStyle(color: Colors.black),
            hintStyle: TextStyle(color: Colors.black87),
            labelStyle: TextStyle(color: Colors.black87),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _bookLanguageContoller,
      ),
    );
  }
}
