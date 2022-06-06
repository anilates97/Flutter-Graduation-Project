import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthRepository {
  void signUpWithEmail(String email, String sifre);

  static initialize() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      var actionCodeSettings = ActionCodeSettings(
        url: 'https://www.example.com/?email=${user.email}',
        dynamicLinkDomain: 'example.page.link',
        androidPackageName: 'com.example.android',
        androidInstallApp: true,
        androidMinimumVersion: '12',
        iOSBundleId: 'com.example.ios',
        handleCodeInApp: true,
      );

      await user.sendEmailVerification(actionCodeSettings);
    }
  }
}

class AuthRepository extends FirebaseAuthRepository {
  @override
  void signUpWithEmail(String email, String sifre) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: sifre);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Maile karşılık gelen kullanıcı bulunamadı');
      } else if (e.code == 'wrong-password') {
        print('Hatalı şifre');
      }
    }
  }
}
