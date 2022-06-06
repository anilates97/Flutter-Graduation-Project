import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants/entire_constants.dart';
import '../themes/themes.dart';
import '../widgets/add_shelf_widget.dart';
import 'shelf_with_books_page.dart';

class BookShelfPage extends StatefulWidget {
  String? shelfName;
  BookShelfPage({Key? key, this.shelfName}) : super(key: key);

  @override
  State<BookShelfPage> createState() => _BookShelfPageState();
}

class _BookShelfPageState extends State<BookShelfPage> {
  final FirebaseDatabaseService _service = FirebaseDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog(context);
        },
        child: Icon(Icons.bookmark_add),
      ),
      appBar: AppBar(
        title: Text("Raflar"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _service.fetcShelf(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  itemCount: snapshot.data!.size,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.6, crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FocusedMenuHolder(
                        blurSize: 5,
                        animateMenuItems: true,
                        menuBoxDecoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(14)),
                        onPressed: () {},
                        menuItems: [
                          FocusedMenuItem(
                              trailingIcon: const Icon(Icons.bookmark_remove),
                              title: Text("Rafı Sil"),
                              onPressed: () async {
                                await _service.deleteShelf(snapshot.data!.docs
                                    .elementAt(index)
                                    .get('shelfTitle'));
                              })
                        ],
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => ShelfWithBooksPage(
                                        shelfName: snapshot.data!.docs
                                            .elementAt(index)
                                            .get('shelfTitle'))));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/shelfBookBack.jpg"),
                                    fit: BoxFit.fill),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: [BoxShadow(blurRadius: 4)],
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    snapshot.data!.docs
                                        .elementAt(index)
                                        .get('shelfTitle'),
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.mali(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.red,
              ));
            }
          },
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shelfPageBack.jpg"),
                fit: BoxFit.fill,
                repeat: ImageRepeat.repeatX)),
      ),
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 4,
          titleTextStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.symmetric(vertical: 150),
          title: Center(
              child:
                  Text("Şanslı Kitap", style: GoogleFonts.mali(fontSize: 24))),
          content: AddBookShelfPage());
    },
  );
}
