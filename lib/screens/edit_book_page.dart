import 'dart:io';

import 'package:bitirme_proje/providers/firebase_auth_providers.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../services/firebase_auth_services.dart';

class EditBookPage extends ConsumerStatefulWidget {
  QueryDocumentSnapshot? queryDocumentSnapshot;
  BuildContext context;
  EditBookPage({Key? key, required this.context, this.queryDocumentSnapshot})
      : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends ConsumerState<EditBookPage> {
  FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  TextEditingController? _bookNameController;
  TextEditingController? _bookDescriptionController;
  TextEditingController? _bookAuthorController;
  TextEditingController? _bookPublishDateController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabaseService service = FirebaseDatabaseService();
  CollectionReference? reference;
  final FirebaseAuthService _authService = FirebaseAuthService();

  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _bookNameController = TextEditingController(
        text: widget.queryDocumentSnapshot!.get('bookTitle'));
    _bookDescriptionController = TextEditingController(
        text: widget.queryDocumentSnapshot!.get('bookDescription'));
    _bookAuthorController = TextEditingController(
        text: widget.queryDocumentSnapshot!.get('bookAuthor').toString());
    _bookPublishDateController = TextEditingController(
        text: widget.queryDocumentSnapshot!.get('bookPublishDate'));
  }

  @override
  Widget build(BuildContext context) {
    print("EDIT BOOK BUILD TETİKLENDİ!!!!!!!!!!!!!!!!");

    //print("USERRRRR" + _auth.getCurrentUser().toString());
    /* .doc("${_auth.getCurrentUser()}")
        .collection("allBooks"); */
    /* QueryDocumentSnapshot queryData =
        ModalRoute.of(context)?.settings.arguments as QueryDocumentSnapshot;
 */
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.queryDocumentSnapshot!.get('bookTitle')),
        //automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: firestore
            .collection("books")
            .doc(_authService.getCurrentUser()!.uid)
            .collection("allBooks")
            .doc(widget.queryDocumentSnapshot!.get('id'))
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          print("SNAPSHOOOTT:: " +
              widget.queryDocumentSnapshot!.get('bookTitle'));
          return ListView(
            children: [
              Container(
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
                      height: 600,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: SweepGradient(
                              colors: [Colors.red, Colors.white, Colors.black]),
                          boxShadow: [BoxShadow(blurRadius: 5)]),
                      child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                editImageProfile(
                                    context,
                                    widget.queryDocumentSnapshot!
                                        .get('thumbnail')),
                                const SizedBox(
                                  height: 10,
                                ),
                                editBookName(),
                                const SizedBox(
                                  height: 10,
                                ),
                                editDescription(),
                                const SizedBox(
                                  height: 10,
                                ),
                                editBookAuthor(),
                                const SizedBox(
                                  height: 10,
                                ),
                                editBookPublishDate(),
                                const SizedBox(
                                  height: 10,
                                ),
                                createUpdateButton(
                                    _authService.getCurrentUser(),
                                    _bookNameController!.text),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
                  }),
                  icon: const Icon(Icons.camera),
                  label: const Text("Kamera")),
              TextButton.icon(
                  onPressed: (() {
                    addImage(ImageSource.gallery);
                  }),
                  icon: const Icon(Icons.image),
                  label: const Text("Galeri")),
            ],
          )
        ],
      ),
    );
  }

  Widget createUpdateButton(User? currentUser, String bookName) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RoundedLoadingButton(
            controller: _buttonController,
            width: 500,
            elevation: 4,
            completionDuration: Duration(milliseconds: 2000),
            color: Colors.red,
            failedIcon: Icons.error,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (_imageFile != null) {
                  Future.delayed(
                    Duration(milliseconds: 2000),
                    () {
                      _buttonController.success();
                      firebaseDatabaseService.uploadImageToFirebase(
                          bookName, currentUser!.uid, _imageFile);
                      firebaseDatabaseService.updateBooks(
                          userID: currentUser.uid,
                          bookTitle: _bookNameController!.text,
                          image: _imageFile,
                          bookAuthor: [_bookAuthorController!.text],
                          bookID: widget.queryDocumentSnapshot!.get('id'),
                          bookDescription: _bookDescriptionController!.text,
                          bookPublishDate: _bookPublishDateController!.text);
                      Navigator.pop(context);
                    },
                  );
                } else {
                  Fluttertoast.showToast(msg: "Resim seçmediniz");
                  _buttonController.error();
                  Future.delayed(Duration(milliseconds: 1000),
                      () => _buttonController.reset());
                }

                Future.delayed(
                  Duration(milliseconds: 2000),
                  () {},
                );

                /*
                 currentUser!.uid,
                    _imageFile,
                    ,
                    
                    ,
                    ,
                    ;
                */
              } else {
                print("HATAAAAAAA");
                _buttonController.error();
                Future.delayed(Duration(milliseconds: 1000),
                    () => _buttonController.reset());
              }
              print("kayıt ol tıklandı");
            },
            child: const Text("Düzenle"),
          ),
        ),
      ),
    );
  }

  Container editBookAuthor() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "Yazar",
            labelStyle: TextStyle(color: Colors.black87),
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

  Container editDescription() {
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
            icon: Container(
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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

  Container editBookName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Lütfen alanı boş bırakmayınız';
          } else if (value.length < 6) {
            return "Minimum 6 karakter girmelisiniz";
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
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.red))),
        controller: _bookNameController,
      ),
    );
  }

  Widget editImageProfile(BuildContext context, data) {
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: (() {
              showModalBottomSheet(
                  context: context, builder: ((_) => bottomSheet(context)));
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(30)),
              height: 190,
              width: 130,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FadeInImage(
                    fit: BoxFit.fill,
                    placeholder: const AssetImage("assets/images/default.jpg"),
                    image: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : NetworkImage(data.toString()) as ImageProvider,
                  )),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(14)),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget editBookPublishDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            labelText: "Yayınlanma",
            hintText: "Yayınlanma",
            icon: Container(
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.published_with_changes_sharp,
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
        controller: _bookPublishDateController,
      ),
    );
  }
}



/*

*/


/*



*/