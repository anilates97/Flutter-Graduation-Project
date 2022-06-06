import 'package:background_app_bar/background_app_bar.dart';
import 'package:bitirme_proje/providers/firebase_database_provider.dart';
import 'package:bitirme_proje/screens/edit_book_page.dart';
import 'package:bitirme_proje/screens/login_page.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:bitirme_proje/themes/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';

import 'package:url_launcher/url_launcher.dart';

import '../constants/entire_constants.dart';
import '../providers/application_providers.dart';
import '../widgets/add_book_to_shelf.dart';
import '../widgets/add_categories_widget.dart';
import '../widgets/appbar_drawer_widget.dart';
import '../widgets/floating_action_library_widget.dart';
import '../widgets/my_custom_listtile_gridview.dart';

class MyLibraryPage extends ConsumerStatefulWidget {
  const MyLibraryPage({Key? key}) : super(key: key);

  @override
  _MyLibraryPageState createState() => _MyLibraryPageState();
}

class _MyLibraryPageState extends ConsumerState<MyLibraryPage> {
  // bool alive = true;
  var _currentIndex = 1;
  String bookID = "";

  @override
  Widget build(BuildContext context) {
    //final data = ModalRoute.of(context)!.settings.arguments as String;

    bool loading = false;

    final isDarkMode = ref.watch(isDarkModeProvider);
    FirebaseDatabaseService service = FirebaseDatabaseService();
    FirebaseAuth _auth = FirebaseAuth.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: service.fetchBooksFromFirebase(_auth.currentUser!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        try {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData) {
            loading = false;
            print("bookID::" + bookID.toString());
            return Scaffold(
                drawer: _auth.currentUser != null ? AppDrawer() : null,
                floatingActionButton: FloatinButtonsLibrary(
                  bookID: bookID,
                ),
                /* appBar: AppBar(
                  actions: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (isDarkMode) {
                              ref.read(changeThemeProvider.state).state =
                                  ThemeMode.light;
                            } else {
                              ref.read(changeThemeProvider.state).state =
                                  ThemeMode.dark;
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100)),
                                child: isDarkMode
                                    ? const Icon(Icons.light_mode)
                                    : const Icon(Icons.dark_mode)),
                          ),
                        ),
                      ],
                    )
                  ],
                  title: Text("Kütüphane Dünyam"),
                ), */
                body: CustomScrollView(
                  key: Key("appBarKey"),
                  slivers: [
                    SliverAppBar(
                      actions: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (isDarkMode) {
                                  ref.read(changeThemeProvider.state).state =
                                      ThemeMode.light;
                                } else {
                                  ref.read(changeThemeProvider.state).state =
                                      ThemeMode.dark;
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: isDarkMode
                                        ? const Icon(Icons.light_mode)
                                        : const Icon(Icons.dark_mode)),
                              ),
                            ),
                          ],
                        )
                      ],
                      iconTheme: IconThemeData(color: Colors.white),
                      expandedHeight: 150,
                      floating: true,
                      pinned: true,
                      snap: false,
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: BackgroundFlexibleSpaceBar(
                        title: Text("Kütüphane Dünyası",
                            style: EntireConstants
                                .googleFontsMyLibraryPageAppBar()),
                        centerTitle: true,
                        background: ClipRect(
                          child: Container(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/myLibraryPageAppBarBack.jpg"),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: Color.fromARGB(255, 190, 25, 3),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 4,
                                      spreadRadius: 4)
                                ],
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                    "Kütüphanedeki dünyamdaki \n kitap sayısı: " +
                                        snapshot.data!.size.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mali(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.6, crossAxisCount: 2),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final _dialog = RatingDialog(
                                  initialRating: 1.0,
                                  // your app's name?
                                  title: Text(
                                    'Kütüphane Dünyası',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // encourage your user to leave a high rating?
                                  message: Text(
                                    'Bu kitabı değerlendirin ve dilerseniz yorumlarınızla destekleyin.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  // your app's logo?
                                  image: const FlutterLogo(size: 100),
                                  submitButtonText: 'Değerlendir',
                                  commentHint: 'Değerledir',
                                  onCancelled: () => print('İpta edildi'),
                                  onSubmitted: (response) {
                                    print(
                                        'rating: ${response.rating}, comment: ${response.comment}');

                                    double rating = response.rating;

                                    service.ratingBooksAddToDatabase(
                                        bookAuthor: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookAuthor'),
                                        bookBuyLink: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookBuyLink'),
                                        bookDescription: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookDescription'),
                                        bookID: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('id'),
                                        bookLanguage: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookLanguage'),
                                        bookPageCount: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookPageCount'),
                                        bookPreviewLink: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookPreviewLink'),
                                        bookPublishDate: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookPublishDate'),
                                        bookRating: response.rating,
                                        bookTitle: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('bookTitle'),
                                        thumbnail: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('thumbnail'),
                                        userID:
                                            snapshot.data!.docs.elementAt(index).get('userID'));

                                    /*  databaseService.ratingBooksAddToDatabase2(
                                        bookID: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('id'),
                                        userID: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('userID'),
                                        bookRating: response.rating); */
                                  },
                                );

                                bookID = snapshot.data!.docs
                                    .elementAt(index)
                                    .get('id');

                                //print("bookID::" + bookID.toString());
                                return FocusedMenuHolder(
                                  blurSize: 5,
                                  animateMenuItems: true,
                                  menuBoxDecoration: BoxDecoration(
                                      color: Colors.indigo,
                                      borderRadius: BorderRadius.circular(14)),
                                  menuItems: [
                                    FocusedMenuItem(
                                        trailingIcon:
                                            const Icon(Icons.library_books),
                                        title: Text(
                                          "Kitabı rafa ekle",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () async {
                                          _showMyDialog(
                                              context,
                                              snapshot.data!.docs
                                                  .elementAt(index)
                                                  .get('id'));
                                        }),
                                    FocusedMenuItem(
                                        trailingIcon:
                                            const Icon(Icons.security_rounded),
                                        title: Text(
                                            !snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get('isBookPrivate')
                                                ? "Kitabı Kullanıcılardan Gizle"
                                                : "Kitabı Göster",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onPressed: () async {
                                          {
                                            if (!snapshot.data!.docs
                                                .elementAt(index)
                                                .get('isBookPrivate')) {
                                              service.hiddenBook(
                                                  bookID: snapshot.data!.docs
                                                      .elementAt(index)
                                                      .get('id'),
                                                  userID:
                                                      _auth.currentUser!.uid);
                                            } else {
                                              service.showbook(
                                                  bookID: snapshot.data!.docs
                                                      .elementAt(index)
                                                      .get('id'),
                                                  userID:
                                                      _auth.currentUser!.uid);
                                            }
                                          }
                                        }),
                                    FocusedMenuItem(
                                        trailingIcon: const Icon(Icons.share),
                                        title: Text("Paylaş",
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onPressed: () async {
                                          {
                                            Share.share(
                                                "Kitap adı ${snapshot.data!.docs.elementAt(index).get('bookTitle')} olan \n"
                                                "Yazarı ${snapshot.data!.docs.elementAt(index).get('bookAuthor').toString()} olan kitabı tavsiye ederim.");
                                          }
                                        }),
                                  ],
                                  onPressed: () {},
                                  child: Slidable(
                                    direction: Axis.horizontal,
                                    dragStartBehavior: DragStartBehavior.down,
                                    child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(blurRadius: 3)
                                                ],
                                                color: isDarkMode
                                                    ? AppTheme
                                                        .darkTheme.cardColor
                                                    : AppTheme
                                                        .lightTheme.cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(14)),
                                            child: InkWell(
                                              onTap: () {
                                                _onAlertButtonPressed(
                                                    context,
                                                    snapshot,
                                                    index,
                                                    isDarkMode);
                                              },
                                              hoverColor: Colors.red,
                                              /* onLongPress: (() {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        EditBookPage(
                                                            context: context,
                                                            queryDocumentSnapshot:
                                                                snapshot
                                                                    .data!.docs
                                                                    .elementAt(
                                                                        index)),
                                                  ));
                                            }), */
                                              child: MyCustomListTileGridView(
                                                isBookPrivate: snapshot
                                                    .data!.docs
                                                    .elementAt(index)
                                                    .get('isBookPrivate'),
                                                thumbnail: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Center(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 5),
                                                              decoration: BoxDecoration(
                                                                  color: !isDarkMode
                                                                      ? Colors
                                                                          .black38
                                                                      : Colors
                                                                          .black26,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30)),
                                                              height: 190,
                                                              width: 130,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  child:
                                                                      FadeInImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    placeholder:
                                                                        const AssetImage(
                                                                            "assets/images/default.jpg"),
                                                                    image:
                                                                        NetworkImage(
                                                                      snapshot
                                                                          .data!
                                                                          .docs
                                                                          .elementAt(
                                                                              index)
                                                                          .get(
                                                                              "thumbnail"),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ]),
                                                    )),
                                                title: snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get("bookTitle"),
                                                author: snapshot.data!.docs
                                                    .elementAt(index)
                                                    .get("bookAuthor")
                                                    .toString(),
                                              ),
                                            ))),
                                    key: const ValueKey(1),
                                    startActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        dragDismissible: true,
                                        children: [
                                          SlidableAction(
                                            key: UniqueKey(),
                                            onPressed: (context) {
                                              service.deleteBook(
                                                  _auth.currentUser!.uid,
                                                  snapshot.data!.docs
                                                      .elementAt(index)
                                                      .get("id"));
                                            },
                                            backgroundColor: isDarkMode
                                                ? Color.fromARGB(
                                                    255, 43, 32, 32)
                                                : Color.fromARGB(
                                                    255, 250, 60, 60),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                          ),
                                          SlidableAction(
                                            key: UniqueKey(),
                                            onPressed: (context) {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        EditBookPage(
                                                            context: context,
                                                            queryDocumentSnapshot:
                                                                snapshot
                                                                    .data!.docs
                                                                    .elementAt(
                                                                        index)),
                                                  ));
                                            },
                                            backgroundColor: isDarkMode
                                                ? Color.fromARGB(
                                                    255, 92, 70, 70)
                                                : Color.fromARGB(
                                                    255, 183, 190, 186),
                                            foregroundColor: Colors.white,
                                            icon: Icons.edit,
                                          ),
                                        ]),
                                  ),
                                );
                              }),
                        ],
                      ),
                    )
                  ],
                ));
          } else {
            loading = true;
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          }
        } catch (e) {
          loading = false;
          print("hata:::::::::::" + e.toString());
          return Text(e.toString());
        }
      },
    );
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
          "Kitabı arkadaşlarınla paylaş",
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
                  Navigator.pop(context);
                }),
                icon: const Icon(Icons.camera),
                label: const Text("Instagram")),
            TextButton.icon(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: const Icon(Icons.image),
                label: const Text("WhatsApp")),
          ],
        )
      ],
    ),
  );
}

// Alert with single button.
_onAlertButtonPressed(context, snapshot, index, bool isDarkMode) {
  Alert(
    context: context,
    type: AlertType.info,
    title: snapshot.data!.docs.elementAt(index).get("bookTitle"),
    desc: snapshot.data!.docs.elementAt(index).get("bookDescription"),
    style: AlertStyle(
        alertPadding: EdgeInsets.all(4),
        isCloseButton: true,
        descTextAlign: TextAlign.justify,
        animationType: AnimationType.grow,
        alertElevation: 4,
        descStyle: EntireConstants.googleFontsMyLibraryPageDescription()),
    buttons: [
      DialogButton(
        child: Text(
          "Satın Al",
          style: !isDarkMode
              ? AppTheme.darkTheme.primaryTextTheme.bodyText2
              : AppTheme.lightTheme.primaryTextTheme.bodyText2,
        ),
        onPressed: () {
          String url = snapshot.data!.docs.elementAt(index).get("bookBuyLink");
          _launchURL(buyUrl: url);
        },
        width: 120,
      )
    ],
  ).show();
}

Future<void> _showMyDialog(BuildContext context, String bookID) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
        titleTextStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.all(16),
        insetPadding: EdgeInsets.symmetric(vertical: 150),
        title: Text("KRafa Ekle"),
        content: AddBookToShelfWidget(bookID: bookID),
      );
    },
  );
}

Widget fadeAlertAnimation(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}

void _launchURL({String? buyUrl}) async {
  if (!await launch(buyUrl!, enableJavaScript: true)) {
    throw 'Could not launch';
  }
}

List<Widget> _createBottomItem() {
  return [Icon(Icons.home), Icon(Icons.library_books), Icon(Icons.account_box)];
}
