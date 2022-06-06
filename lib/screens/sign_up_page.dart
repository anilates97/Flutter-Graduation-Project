import 'dart:io';

import 'package:bitirme_proje/providers/firebase_auth_providers.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpPage extends ConsumerStatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mailController = TextEditingController();

  final TextEditingController _sifreController = TextEditingController();

  final TextEditingController _yasController = TextEditingController();

  final TextEditingController _ilgiAlanlariController = TextEditingController();

  final TextEditingController _isimSoyisimController = TextEditingController();

  final TextEditingController _cinsiyet = TextEditingController();

  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _value = false;
  int val = -1;

  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(firebaseAuthServiceProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Kayıt Ol"),
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/LoginPage', (route) => false);
            },
            child: Container(
                width: 10, height: 10, child: const Icon(Icons.arrow_back))),
      ),
      body: createSignUpBackWall(_auth, context),
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
                  : const AssetImage("assets/images/man.png") as ImageProvider,
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

  Container createSignUpBackWall(
      FirebaseAuthService _auth, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/loginBackWall.jpg"),
              fit: BoxFit.fill)),
      height: 750,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: SweepGradient(
                    startAngle: 2,
                    colors: [Colors.red, Colors.white, Colors.black]),
                boxShadow: [BoxShadow(blurRadius: 5)]),
            width: 350,
            height: 600,
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        createImageProfile(
                          context,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        createSignUpNameSurnameText(),
                        SizedBox(
                          height: 10,
                        ),
                        createSignUpEmailText(),
                        const SizedBox(
                          height: 10,
                        ),
                        createSignUpPassText(),
                        const SizedBox(
                          height: 10,
                        ),
                        createSignUpAgeText(),
                        const SizedBox(
                          height: 10,
                        ),
                        createSignUpGenderText(),
                        createSignUpLikeText(),
                        const SizedBox(
                          height: 10,
                        ),
                        buildSignUpButtonWidget(context),
                        SizedBox(
                          height: 15,
                        ),
                        createSignUpTextButton(context),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  TextButton createSignUpTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/LoginPage');
      },
      child: Text(
        "Kaydınız varsa giriş yapmak için tıklayın",
        style: TextStyle(
            color: Colors.white, decoration: TextDecoration.underline),
      ),
    );
  }

  Container createSignUpLikeText() {
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

  Container createSignUpAgeText() {
    return Container(
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Lütfen yaşınızı giriniz";
          }
        }),
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
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            errorStyle: TextStyle(color: Colors.black),
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _yasController,
      ),
    );
  }

  Container createSignUpGenderText() {
    return Container(
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 141, 7, 7),
                  shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle_sharp, color: Colors.white),
              )),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          "Erkek",
                          style: TextStyle(fontSize: 13),
                        ),
                        leading: Radio(
                          value: 1,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value as int;
                              print("val : " + val.toString());
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text("Kadın", style: TextStyle(fontSize: 13)),
                        leading: Radio(
                          value: 2,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value as int;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container createSignUpPassText() {
    return Container(
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        validator: ((value) {
          if (value!.isEmpty) {
            return "Lütfen şifrenizi giriniz";
          } else if (value.length < 6) {
            return "Şifre 6 karakterden az olamaz";
          }
        }),
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.password,
              color: Colors.black45,
            ),
            labelText: "Şifre",
            hintText: "Şifre",
            hintStyle: TextStyle(color: Colors.black45),
            labelStyle: TextStyle(color: Colors.black45),
            icon: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 7, 7),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.password_outlined,
                    color: Colors.white,
                  ),
                )),
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _sifreController,
      ),
    );
  }

  Container createSignUpEmailText() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen mail adresinizi giriniz";
          } else if (!EmailValidator.validate(value)) {
            return "Geçerli bir mail adresi giriniz";
          }
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: Colors.black45,
            ),
            icon: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 7, 7),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_box,
                    color: Colors.white,
                  ),
                )),
            labelText: "E-mail",
            errorStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: Colors.black45),
            hintText: "E-mail",
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: _mailController,
      ),
    );
  }

  Container createSignUpNameSurnameText() {
    return Container(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Lütfen isim ve soy isminizi giriniz";
          }
        },
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.text_fields,
              color: Colors.black45,
            ),
            icon: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 141, 7, 7),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.text_fields,
                    color: Colors.white,
                  ),
                )),
            labelText: "İsim ve Soy isim",
            errorStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: Colors.black45),
            hintText: "İsim ve Soy isim",
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: _isimSoyisimController,
      ),
    );
  }

  Widget buildSignUpButtonWidget(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        child: RoundedLoadingButton(
          color: Color.fromARGB(255, 141, 7, 7),
          width: 500,
          elevation: 4,
          completionDuration: Duration(milliseconds: 2000),
          failedIcon: Icons.error,
          controller: _buttonController,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _buttonController.success();
              Future.delayed(
                Duration(milliseconds: 2000),
                () async {
                  await _authService.signUpWithEmailandPassword(
                    _isimSoyisimController.text,
                    _mailController.text,
                    _sifreController.text,
                    _yasController.text,
                    _ilgiAlanlariController.text,
                    val,
                    _imageFile!,
                  );

                  Navigator.pushReplacementNamed(context, '/HomePage');
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
          child: Text("Kayıt Ol"),
        ),
      ),
    );
  }
}
