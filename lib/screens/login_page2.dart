import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../providers/firebase_auth_providers.dart';

class LoginPage2 extends ConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  LoginPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    print("LOGIN BUILD TETIKLENDI");
    final _auth = ref.watch(firebaseAuthServiceProvider);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Giriş Yap"),
      ),
      body: ListView(
        children: [
          buildLoginBackWall(_auth, context),
        ],
      ),
    );
  }

  Container buildLoginBackWall(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                createLoginImage(),
                Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          createLoginEmailText(),
                          const SizedBox(
                            height: 10,
                          ),
                          createLoginPasswordText(),
                          const SizedBox(
                            height: 10,
                          ),
                          createLoginButtonWidget(
                              buttonController: _buttonController,
                              formKey: _formKey,
                              mailController: _mailController,
                              sifreController: _sifreController,
                              auth: _auth),
                          SizedBox(
                            height: 15,
                          ),
                          createTextButton(context),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton createTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/SignUpPage');
      },
      child: Text(
        "Kaydınız yoksa oluşturmak için tıklayın",
        style: TextStyle(
            color: Colors.white,
            overflow: TextOverflow.fade,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Container createLoginPasswordText() {
    return Container(
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            return "Lütfen şifrenizi giriniz";
          } else if (value.length < 6) {
            return "Şifre 6 karakterden az olamaz";
          }
        }),
        style: TextStyle(color: Colors.black),
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.password,
              color: Colors.black45,
            ),
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
            labelText: "Şifre",
            hintStyle: TextStyle(color: Colors.black45),
            hintText: "Şifre",
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            errorStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(15))),
        controller: _sifreController,
      ),
    );
  }

  Container createLoginEmailText() {
    return Container(
      child: TextFormField(
        validator: ((value) {
          if (value!.isEmpty) {
            return "Lütfen mail adresinizi giriniz";
          } else if (!EmailValidator.validate(value)) {
            return "Geçerli bir mail adresi giriniz";
          }
        }),
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
            hintText: "E-mail",
            errorStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.black45),
            fillColor: Colors.white,
            filled: true,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        controller: _mailController,
      ),
    );
  }

  Container createLoginImage() {
    return Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient:
                SweepGradient(colors: [Colors.red, Colors.white, Colors.black]),
            boxShadow: [BoxShadow(blurRadius: 5)]),
        child: Center(
          child: Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/loginBack.png"))),
          ),
        ));
  }
}

class createLoginButtonWidget extends StatelessWidget {
  const createLoginButtonWidget({
    Key? key,
    required RoundedLoadingButtonController buttonController,
    required GlobalKey<FormState> formKey,
    required TextEditingController mailController,
    required TextEditingController sifreController,
    required FirebaseAuthService auth,
  })  : _buttonController = buttonController,
        _formKey = formKey,
        _mailController = mailController,
        _sifreController = sifreController,
        _auth = auth,
        super(key: key);

  final RoundedLoadingButtonController _buttonController;
  final GlobalKey<FormState> _formKey;
  final TextEditingController _mailController;
  final TextEditingController _sifreController;
  final FirebaseAuthService _auth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        child: RoundedLoadingButton(
          width: 500,
          elevation: 4,
          completionDuration: Duration(milliseconds: 2000),
          failedIcon: Icons.error,
          color: Color.fromARGB(255, 141, 7, 7),
          controller: _buttonController,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Future.delayed(
                Duration(milliseconds: 2000),
                () async {
                  final email = _mailController.text;
                  final sifre = _sifreController.text;
                  bool oturum =
                      await _auth.signInWithEmailandPassword(email, sifre);

                  if (oturum) {
                    Future.delayed(
                      Duration(milliseconds: 1000),
                      () {
                        _buttonController.success();
                      },
                    );
                    Navigator.pushReplacementNamed(context, '/HomePage');
                  } else {
                    _buttonController.error();
                    Future.delayed(
                      Duration(milliseconds: 1000),
                      () {
                        _buttonController.reset();
                      },
                    );
                    return null;
                  }
                },
              );
            } else {
              _buttonController.error();
              Future.delayed(
                Duration(milliseconds: 1000),
                () {
                  _buttonController.reset();
                },
              );
            }
          },
          child: Text("Giriş Yap"),
        ),
      ),
    );
  }
}
