import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:bitirme_proje/providers/api_providers.dart';
import 'package:bitirme_proje/screens/books_detail.page.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/entire_constants.dart';
import '../widgets/my_custom_listtile_gridview.dart';
import '../widgets/my_custom_listtile_gridview_category_with_book_widget.dart';
import 'books_detail_page_shelf.dart';

class ShelfWithBooksPage extends ConsumerStatefulWidget {
  String shelfName;
  ShelfWithBooksPage({Key? key, required this.shelfName}) : super(key: key);

  @override
  _ShelfWithBooksPageState createState() => _ShelfWithBooksPageState();
}

class _ShelfWithBooksPageState extends ConsumerState<ShelfWithBooksPage> {
  FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebaseDatabaseService.fetchBooksByShelf(
            _firebaseAuthService.getCurrentUser()!, widget.shelfName),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: Container(
              color: Colors.black,
              child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        iconTheme: IconThemeData(color: Colors.white),
                        expandedHeight: 150,
                        pinned: true,
                        snap: false,
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: BackgroundFlexibleSpaceBar(
                          title: Text(widget.shelfName,
                              style: EntireConstants
                                  .googleFontsCategoriesPageAppBar()),
                          centerTitle: true,
                          background: ClipRect(
                            child: Container(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/myLibraryPageAppBarBack.jpg"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/shelfPageBack.jpg"),
                                fit: BoxFit.fill),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.white,
                                  spreadRadius: 10)
                            ],
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(14),
                                top: Radius.circular(14))),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 4,
                                        spreadRadius: 4)
                                  ],
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                      "Raftaki kitap sayısı: " +
                                          snapshot.data!.size.toString(),
                                      style: GoogleFonts.mali(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                            GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.6,
                                        crossAxisCount: 4),
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          boxShadow: [
                                            BoxShadow(blurRadius: 3)
                                          ]),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (_) =>
                                                      BooksDetailShelfPage(
                                                          booksModel: [
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'thumbnail'),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookTitle'),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookDescription'),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookAuthor')[0],
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookPublishDate'),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookPageCount')
                                                                .toString(),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookLanguage'),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookBuyLink'),
                                                            snapshot.data!.docs
                                                                .elementAt(
                                                                    index)
                                                                .get(
                                                                    'bookPreviewLink'),
                                                          ])));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: Image.network(
                                            snapshot.data!.docs
                                                .elementAt(index)
                                                .get('thumbnail'),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ))),
            ));
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
        });
  }
}
