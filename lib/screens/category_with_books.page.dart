import 'dart:ui';

import 'package:background_app_bar/background_app_bar.dart';
import 'package:bitirme_proje/providers/api_providers.dart';
import 'package:bitirme_proje/screens/books_detail.page.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/entire_constants.dart';
import '../widgets/my_custom_listtile_gridview.dart';
import '../widgets/my_custom_listtile_gridview_category_with_book_widget.dart';

class CategoryWithBooksPage extends ConsumerStatefulWidget {
  String categoryName;
  CategoryWithBooksPage({Key? key, required this.categoryName})
      : super(key: key);

  @override
  _CategoryWithBooksPageState createState() => _CategoryWithBooksPageState();
}

class _CategoryWithBooksPageState extends ConsumerState<CategoryWithBooksPage> {
  FirebaseDatabaseService firebaseDatabaseService = FirebaseDatabaseService();
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final books =
        ref.watch(getBookByCategory(widget.categoryName.split(' ').first));

    return books.when(
        data: (data) {
          return Scaffold(
              /* appBar: AppBar(
        title: Text(widget.categoryName),
      ), */
              body: Container(
            color: Colors.black,
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      iconTheme: IconThemeData(color: Colors.white),
                      expandedHeight: 150,
                      floating: true,
                      pinned: true,
                      snap: false,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: BackgroundFlexibleSpaceBar(
                        title: Text(widget.categoryName,
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
                                    "assets/images/adventureBack.jpg"),
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
                                  "assets/images/categoryWithBooksBack.jpg"),
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
                      child: GridView.builder(
                          itemCount: data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7, crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    boxShadow: [BoxShadow(blurRadius: 3)]),
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: InkWell(
                                    onTap: (() {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (_) => BooksDetailPage(
                                                    booksModel: data[index],
                                                  )));
                                    }),
                                    child: MyCustomGridViewCategoryWithBook(
                                        author: "snapshot.data!.docs"
                                            """.elementAt(index)"""
                                            """."get("bookAuthor")""",
                                        thumbnail: ClipRRect(
                                            child: FadeInImage(
                                          fit: BoxFit.fitWidth,
                                          placeholder: const AssetImage(
                                              "assets/images/default.jpg"),
                                          image: data[index]
                                                      .volumeInfo!
                                                      .imageLinks !=
                                                  null
                                              ? NetworkImage(
                                                  data[index]
                                                      .volumeInfo!
                                                      .imageLinks!
                                                      .thumbnail!,
                                                  scale: 0.5)
                                              : AssetImage(
                                                      "assets/images/default.jpg")
                                                  as ImageProvider,
                                        )),
                                        title: data[index].volumeInfo!.title ==
                                                null
                                            ? "Belirtilmemiş"
                                            : data[index].volumeInfo!.title!,
                                        description: data[index]
                                                    .volumeInfo!
                                                    .description ==
                                                null
                                            ? "Açıklama yok"
                                            : data[index]
                                                .volumeInfo!
                                                .description!),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ))),
          ));
        },
        error: (e, s) => Text(e.toString()),
        loading: () => Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ));
  }
}
