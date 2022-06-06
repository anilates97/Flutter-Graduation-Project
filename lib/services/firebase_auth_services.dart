import 'dart:io';

import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  FirebaseAuthService();

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<String>? uploadImageToFirebase(
      String email, String userID, File? image) async {
    try {
      Reference ref =
          firebaseStorage.ref('/bookApp/$userID/${email.substring(5)}' ".jpg");
      UploadTask uploadTask = ref.putFile(image!.absolute);
      await Future.value(uploadTask);
      var newUrl = await ref.getDownloadURL();
      print("url:" + newUrl);
      return newUrl;
    } on FirebaseException catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String> signUpWithEmailandPassword(
    String nameSurname,
    String email,
    String sifre,
    String yas,
    String ilgiAlanlari,
    int cinsiyet,
    File image,
  ) async {
    //Kayıt olma
    try {
      print("Metot çalıştı");
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: sifre);
      String? userID = user.user!.uid;
      print("Kullanıcı kaydoldu id: " + userID);

      // Veritabanına yazılma
      var ref = firestore.collection("users");
      var document = ref.doc(userID).set({
        'nameSurname': nameSurname,
        'profilImage': await uploadImageToFirebase(email, userID, image),
        'userID': userID,
        'email': email,
        'sifre': sifre,
        'yas': yas,
        'gender': cinsiyet == 1 ? 'Erkek' : 'Kadın',
        'ilgiAlanlari': ilgiAlanlari,
        'loggedIn': true,
        'followers': [],
        'following': [],
        'isLibraryPrivate': false
      });
      return userID;
    } on FirebaseException catch (e) {
      print(e.toString());
      return "HATA VAR";
    }
  }

  /*  Future usersAddToDatabase(
      String email, String sifre, String yas, String ilgiAlanlari) async {
    try {
      String userID = await signUpWithEmailandPassword(email, sifre);
      var ref = firestore.collection("users");
      var document = ref.doc(userID).set({
        'userID': userID,
        'email': email,
        'sifre': sifre,
        'yas': yas,
        'ilgiAlanlari': ilgiAlanlari
      });
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
 */
  Future<bool> signInWithEmailandPassword(String email, String sifre) async {
    try {
      UserCredential user =
          await _auth.signInWithEmailAndPassword(email: email, password: sifre);
      var ref = firestore.collection("users");
      var document = ref.doc(user.user!.uid).update({'loggedIn': true});
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
      return false;
    }
  }

  Future<void> followUser(String userID) async {
    DocumentReference documentReferenceOther =
        FirebaseFirestore.instance.collection('users').doc(userID);

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");

    collectionReference.doc(userID).set(
      {
        'followers': FieldValue.arrayUnion([_auth.currentUser!.uid])
      },
      SetOptions(merge: true),
    );

    collectionReference.doc(_auth.currentUser!.uid).set(
      {
        'following': FieldValue.arrayUnion([userID])
      },
      SetOptions(merge: true),
    );

    DocumentReference documentReferenceMy = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshotOther =
              await transaction.get(documentReferenceOther);
          DocumentSnapshot snapshotMy =
              await transaction.get(documentReferenceMy);

          if (!snapshotOther.exists && !snapshotMy.exists) {
            throw Exception("User does not exist!");
          }

          // Update the follower count based on the current count
          // Note: this could be done without a transaction
          // by updating the population using FieldValue.increment()

          int newFollowerCountOther = (snapshotOther)['followersCount'];
          int newFollowingCountMy = (snapshotMy)['followingCount'];

          newFollowerCountOther++;
          newFollowingCountMy++;

          // Perform an update on the document
          transaction.update(documentReferenceOther,
              {'followersCount': newFollowerCountOther});

          transaction.update(
              documentReferenceMy, {'followingCount': newFollowingCountMy});

          // Return the new count
          return newFollowerCountOther;
        })
        .then((value) => print("Follower count updated to $value"))
        .catchError(
            (error) => print("Failed to update user followers: $error"));
  }

  Future<void> unFollowUser(String userID) async {
    DocumentReference documentReferenceOther =
        FirebaseFirestore.instance.collection('users').doc(userID);

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users");

    collectionReference.doc(userID).set(
      {
        'followers': FieldValue.arrayRemove([_auth.currentUser!.uid])
      },
      SetOptions(merge: true),
    );

    collectionReference.doc(_auth.currentUser!.uid).set(
      {
        'following': FieldValue.arrayRemove([userID])
      },
      SetOptions(merge: true),
    );

    DocumentReference documentReferenceMy = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          // Get the document
          DocumentSnapshot snapshotOther =
              await transaction.get(documentReferenceOther);
          DocumentSnapshot snapshotMy =
              await transaction.get(documentReferenceMy);

          if (!snapshotOther.exists && !snapshotMy.exists) {
            throw Exception("User does not exist!");
          }

          // Update the follower count based on the current count
          // Note: this could be done without a transaction
          // by updating the population using FieldValue.increment()

          int newFollowerCountOther = (snapshotOther)['followersCount'];
          int newFollowingCountMy = (snapshotMy)['followingCount'];

          if (newFollowerCountOther > 0) {
            newFollowerCountOther--;
          }

          if (newFollowingCountMy > 0) {
            newFollowingCountMy--;
          }

          // Perform an update on the document
          transaction.update(documentReferenceOther,
              {'followersCount': newFollowerCountOther});

          transaction.update(
              documentReferenceMy, {'followingCount': newFollowingCountMy});

          // Return the new count
          return newFollowerCountOther;
        })
        .then((value) => print("Follower count updated to $value"))
        .catchError(
            (error) => print("Failed to update user followers: $error"));
  }

  Future<void> logOut() async {
    var ref = firestore.collection("users");
    var document = ref.doc(getCurrentUser()!.uid).update({'loggedIn': false});
    await _auth.signOut();
  }
}
