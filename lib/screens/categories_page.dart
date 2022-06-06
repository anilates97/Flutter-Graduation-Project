
import 'package:background_app_bar/background_app_bar.dart';
import 'package:bitirme_proje/constants/entire_constants.dart';
import 'package:bitirme_proje/screens/category_with_books.page.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesPage extends StatefulWidget {
  String? bookID;
  String? categoryName;
  CategoriesPage({Key? key, this.bookID}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  FirebaseDatabaseService service = FirebaseDatabaseService();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> categories = [];
  @override
  Widget build(BuildContext context) {
    print("DATAAAAAAAAAAAAAAAAAAAAAAAAAAAA:" + categories.length.toString());
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            expandedHeight: 150,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: BackgroundFlexibleSpaceBar(
              title: Text("Kategoriler",
                  style: EntireConstants.googleFontsCategoriesPageAppBar()),
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
                      image: AssetImage("assets/images/categoryAppBarBack.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          )
        ];
      },
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/categoryBack.jpg"),
                  fit: BoxFit.fill)),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: service.fetchCategory(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                try {
                  if (snapshot.hasData) {
                    List<String> categories = [];
                    snapshot.data!.docs.map((e) {
                      categories.add(e.get('categoryTitle'));
                    }).toList();

                    print("LİST BOYUT : " + categories.length.toString());
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: []),
                        width: 400,
                        height: 520,
                        child: GridView.builder(
                            itemCount: categories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.95, crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              widget.categoryName = categories[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      shadowColor: Colors.red,
                                      elevation: 10,
                                      primary: Colors.white),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                CategoryWithBooksPage(
                                                  categoryName:
                                                      categories[index],
                                                )));
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        categories[index],
                                        style: EntireConstants
                                            .googleFontsCategoriesItems(),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(blurRadius: 4)
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "assets/images/icons/${icons[index]}",
                                            height: 50,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(color: Colors.red));
                  }
                } on FirebaseException catch (e) {
                  print(e.code.toString());
                  return Text("HATA..." + e.toString());
                }
              },
            ),
          ),
        ),
      ),
    ));
  }
}

List<String> icons = [
  'literature.png',
  'monitor.png',
  'cyborg.png',
  'art.png',
  'hearts.png',
  'history.png',
  'health-insurance.png',
  'comic-book.png',
  'koran.png',
  'presentation.png',
  'mystery.png',
  'working.png'
];
