import 'dart:io';
import 'dart:math';

import 'package:bitirme_proje/model/myBooksModel.dart';
import 'package:bitirme_proje/model/shelfModel/shelfModel.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/booksModel/books.dart';
import '../model/categoryModel/categoryModel.dart';

class FirebaseDatabaseService {
  List bookList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuthService _authService = FirebaseAuthService();

  /*  String getBookID(User user) {
    print("user id: " + user.uid);
    var ref = firestore.collection("books");
    var docs = ref.doc(user.uid).collection("bookID").get();
    String? id;
    docs.then((value) => {
          if (value.docs.isNotEmpty)
            {
              print("DATA:::::::::" + value.docs[0].data()['id'].toString()),
              id = value.docs[0].data()['id'].toString()
            }
        });
    return id!;
  } */

  Future<bool> isDuplicateUniqueName(String uniqueName, User? user) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('books')
        .doc(user!.uid)
        .collection("allBooks")
        .where('id', isEqualTo: uniqueName)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<void> addCategory(Category kategori) async {
    var ref = firestore.collection("categories");
    ref.doc().set({'categoryTitle': kategori.categoryTitle, 'bookID': ""});
  }

  Future<void> hideLibrary(String userID) async {
    var ref = firestore.collection("users");
    ref.doc(userID).update({'isLibraryPrivate': true});
  }

  Future<void> showLibrary(String userID) async {
    var ref = firestore.collection("users");
    ref.doc(userID).update({'isLibraryPrivate': false});
  }

  Future<void> addShelf(Shelf shelf) async {
    var ref = firestore.collection("shelves");

    ref.doc().set({
      'shelfTitle': shelf.shelfTitle,
      'addedDate': DateTime.now(),
    });
  }

  Future<void> booksAddToShelf(
      String bookID, User user, String shelfName) async {
    var ref = firestore
        .collection("books")
        .doc(user.uid)
        .collection("allBooks")
        .doc(bookID)
        .update({
      'shelf': FieldValue.arrayUnion([shelfName])
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchCategory() {
    var ref = firestore.collection("categories");
    return ref.snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? fetchUserFollow(
      String userID) {
    var ref = firestore.collection("userFollow").doc(userID);
    return ref.snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchUsers() {
    var ref = firestore.collection("users");
    return ref.snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? fetchSignedUser() {
    if (_authService.getCurrentUser() != null) {
      var ref =
          firestore.collection("users").doc(_authService.getCurrentUser()!.uid);
      return ref.snapshots();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? fetchSelectedUser(
      String userID) {
    if (_authService.getCurrentUser() != null) {
      var ref = firestore.collection("users").doc(userID);
      return ref.snapshots();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchLibraryOfUser(
      String userID) {
    var ref = firestore.collection("books");
    var snapshot = ref
        .doc(userID)
        .collection("allBooks")
        .where('isBookPrivate', isEqualTo: false)
        .orderBy('addedDate', descending: true)
        .snapshots();

    return snapshot;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetcShelf() {
    var ref = firestore.collection("shelves").orderBy('addedDate');
    return ref.snapshots();
  }

  Future<List<MyBooksModel>> booksAddToDatabase(
      BooksModel book, User user) async {
    try {
      List<MyBooksModel> myBooks = [];

      print("user id: " + user.uid);
      var ref = firestore.collection("books");
      var docs = ref.doc(user.uid).collection("allBooks").get();

      ref.doc(user.uid).collection("allBooks").doc(book.id).set({
        'userID': user.uid,
        'id': book.id,
        'bookTitle': book.volumeInfo!.title,
        'bookAuthor': book.volumeInfo!.authors,
        'bookDescription': book.volumeInfo!.description ?? "-",
        'bookPublishDate': book.volumeInfo!.publishedDate ?? "-",
        'bookPageCount': book.volumeInfo!.pageCount ?? "-",
        'bookLanguage': book.volumeInfo!.language ?? "-",
        'okunduMu': false,
        'isBookPrivate': false,
        'isLibraryPrivate': false,
        'addedDate': DateTime.now(),
        'thumbnail': book.volumeInfo!.imageLinks == null
            ? "https://firebasestorage.googleapis.com/v0/b/my-library-4d1a6.appspot.com/o/default.jpg?alt=media&token=623b3ebb-a622-4610-a1ce-3b9a0beabf3f"
            : book.volumeInfo!.imageLinks!.thumbnail,
        'bookBuyLink': book.saleInfo!.buyLink ?? "-",
        'bookPreviewLink': book.volumeInfo!.previewLink ?? "-"
      });

      myBooks.add(MyBooksModel(
          bookTitle: book.volumeInfo!.title,
          bookAddedDate: DateTime.now().toString(),
          bookAuthor: book.volumeInfo!.authors,
          bookDescription: book.volumeInfo!.description,
          bookPublishDate: book.volumeInfo!.publishedDate));

      return myBooks;
    } catch (e) {
      print(e.toString());
      throw Exception("hata");
    }
  }

  Future<void> ratingBooksAddToDatabase(
      {String? userID,
      String? thumbnail,
      String? bookID,
      double? bookRating,
      String? bookTitle,
      String? bookDescription,
      List<dynamic>? bookAuthor,
      String? bookPublishDate,
      String? bookBuyLink,
      String? bookPreviewLink,
      String? bookLanguage,
      int? bookPageCount}) async {
    try {
      List<MyBooksModel> myBooks = [];

      print("user id: " + userID!);
      var ref = firestore.collection("ratingBooks");

      ref
          .doc(_authService.getCurrentUser()!.uid)
          .collection("books")
          .doc(bookID)
          .set({
        'userID': userID,
        'id': bookID,
        'bookTitle': bookTitle,
        'bookAuthor': bookAuthor,
        'bookDescription': bookDescription,
        'bookPublishDate': bookPublishDate,
        'bookPageCount': bookPageCount,
        'bookLanguage': bookLanguage,
        'okunduMu': false,
        'isBookPrivate': false,
        'isLibraryPrivate': false,
        'addedDate': DateTime.now(),
        'thumbnail': thumbnail,
        'bookBuyLink': bookBuyLink,
        'bookPreviewLink': bookPreviewLink,
        'bookRating': bookRating
      });
    } catch (e) {
      print(e.toString());
      throw Exception("hata");
    }
  }

  Future<void> ratingBooksAddToDatabase2(
      {String? userID,
      String? thumbnail,
      String? bookID,
      double? bookRating,
      String? bookTitle,
      String? bookDescription,
      List<dynamic>? bookAuthor,
      String? bookPublishDate,
      String? bookBuyLink,
      String? bookPreviewLink,
      String? bookLanguage,
      int? bookPageCount}) async {
    try {
      List<MyBooksModel> myBooks = [];

      print("user id: " + userID!);
      var ref = firestore.collection("ratingBooks");

      ref.doc(_authService.getCurrentUser()!.uid).set({
        'books': [
          {'id': bookID, 'userID': userID, 'rating': bookRating},
          SetOptions(merge: true)
        ]
      });
    } catch (e) {
      print(e.toString());
      throw Exception("hata");
    }
  }

  Future<void> calculateAndShowRatingBooks({
    String? userID,
    String? bookID,
    double? bookRating,
  }) async {
    try {
      print("user id: " + userID!);
      var ref = firestore.collection("ratedBooks");

      ref
          .doc(bookID)
          .collection("allBooks")
          .doc()
          .set({'bookRating': bookRating});
    } catch (e) {
      print(e.toString());
      throw Exception("hata");
    }
  }

  Future<String>? uploadImageToFirebase(
      String bookName, String userID, File? image) async {
    try {
      Reference ref = firebaseStorage.ref('/bookApp/$userID/$bookName' ".jpg");
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

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future<void> localBookCreate(
      String userID,
      File image,
      String bookTitle,
      String bookDescription,
      List<String> bookAuthor,
      String bookPublishDate,
      String bookLanguage,
      int bookPageCount) async {
    var ref = firestore.collection("books");
    var bookID = generateRandomString(12);
    print("BOOOKIDDD : " + bookID.toString());

    ref.doc(userID).collection("allBooks").doc(bookID).set({
      'userID': userID,
      'id': bookID,
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'bookDescription': bookDescription,
      'bookPublishDate': bookPublishDate,
      'bookPageCount': bookPageCount,
      'bookLanguage': bookLanguage,
      'okunduMu': false,
      'isBookPrivate': false,
      'isLibraryPrivate': false,
      'addedDate': DateTime.now(),
      'thumbnail': await uploadImageToFirebase(bookTitle, userID, image),
    });
  }

  /*  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future<void> uploadImageToStorage() async {
    File imageName = await getImageFileFromAssets("images/default.jpg");

    FirebaseStorage.instance
        .ref()
        .child("photos")
        .child("defaultImage")
        .putFile(imageName);
  }
 */
  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchBooksFromFirebase(
      User user) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = firestore
          .collection("books")
          .doc(user.uid)
          .collection("allBooks")
          .orderBy('addedDate', descending: true)
          .snapshots();

      return querySnapshot;
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchBooksByShelf(
      User user, String shelfName) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Stream<QuerySnapshot<Map<String, dynamic>>> querySnapshot = firestore
          .collection("books")
          .doc(user.uid)
          .collection("allBooks")
          .where('shelf', arrayContains: shelfName)
          .snapshots();

      return querySnapshot;
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchBooksByCategory(
      User user, String category) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference = firestore.collection("books");

    return collectionReference
        .doc(user.uid)
        .collection('allBooks')
        .where('category', isEqualTo: category)
        .snapshots();

    /*  try {
      collectionReference.doc(user.uid).collection('allBooks').snapshots();
    } on FirebaseException catch (e) {
      print(e.code.toString());
    } */
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? fetchUsersFromFirebase(
      User user) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Stream<DocumentSnapshot<Map<String, dynamic>>> querySnapshot =
          firestore.collection("users").doc(user.uid).snapshots();

      return querySnapshot;
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>>? getRatedBooks(User user) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      Stream<DocumentSnapshot<Map<String, dynamic>>> querySnapshot = firestore
          .collection("ratingBooks")
          .doc(user.uid)
          .collection("books")
          .doc()
          .snapshots();

      return querySnapshot;
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateUser(
      {String? userID, String? yas, String? ilgiAlanlari}) async {
    var ref = firestore.collection("users");

    ref.doc(userID).update({'yas': yas, 'ilgiAlanlari': ilgiAlanlari});
  }

  Future<void> hiddenBook({String? userID, String? bookID}) async {
    var ref = firestore.collection("books");

    ref
        .doc(userID)
        .collection('allBooks')
        .doc(bookID)
        .update({'isBookPrivate': true});
  }

  Future<void> showbook({String? userID, String? bookID}) async {
    var ref = firestore.collection("books");

    ref
        .doc(userID)
        .collection('allBooks')
        .doc(bookID)
        .update({'isBookPrivate': false});
  }

  Future<void> updateBooks(
      {String? userID,
      File? image,
      String? bookTitle,
      String? bookDescription,
      List<String>? bookAuthor,
      String? bookID,
      String? bookPublishDate}) async {
    var ref = firestore.collection("books");

    print("BOOOKIDDD : " + bookID.toString());

    ref.doc(userID).collection("allBooks").doc(bookID).update({
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'bookDescription': bookDescription,
      'bookPublishDate': bookPublishDate,
      'okunduMu': false,
      'addedDate': DateTime.now(),
      'thumbnail': await uploadImageToFirebase(bookTitle!, userID!, image),
    });
  }

  Future<void> deleteBook(String? userID, String bookID) async {
    var ref = firestore.collection("books");

    ref.doc(userID).collection("allBooks").doc(bookID).delete();
  }

  Future<void> deleteShelf(String shelfName) async {
    try {
      var collection = FirebaseFirestore.instance.collection('shelves');
      var snapshot =
          await collection.where('shelfTitle', isEqualTo: shelfName).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      print("RAF SİLİNME İŞLEMİ");
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
