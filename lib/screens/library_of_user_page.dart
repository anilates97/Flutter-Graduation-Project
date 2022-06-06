import 'dart:io';

import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:bitirme_proje/widgets/my_custom_gridview_other_user_library.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

import 'other_profiles_page.dart';

class LibraryPageOfUser extends ConsumerStatefulWidget {
  String userID;
  LibraryPageOfUser({Key? key, required this.userID}) : super(key: key);

  @override
  _LibraryPageOfUserState createState() => _LibraryPageOfUserState();
}

class _LibraryPageOfUserState extends ConsumerState<LibraryPageOfUser> {
  final FirebaseDatabaseService _firebaseDatabaseService =
      FirebaseDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Stack(alignment: Alignment.topCenter, children: [
            Opacity(
              opacity: 0.5,
              child: ClipPath(
                clipper: WaveClipperUp(),
                child: Container(
                  color: Colors.red,
                  height: 200,
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipperUp(),
              child: Container(
                color: Color.fromARGB(255, 160, 24, 15),
                alignment: Alignment.center,
                child: Text(
                  "Kullanıcı Kütüphanesi",
                  style: GoogleFonts.mali(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                height: 180,
              ),
            ),
          ]),
          Column(
            children: [
              StreamBuilder(
                stream:
                    _firebaseDatabaseService.fetchLibraryOfUser(widget.userID),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print("USERID: " + widget.userID);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(blurRadius: 5, spreadRadius: 3)
                              ]),
                          height: 50.h,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.size,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.7, crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                print("AAAAAAAAAAAAAAAAAAAAAAAAAA:" +
                                    snapshot.data!.docs
                                        .elementAt(index)
                                        .get("bookTitle"));
                                return MyCustomGridViewOtherUserLibrary(
                                    thumbnail: Image.network(
                                      snapshot.data!.docs
                                          .elementAt(index)
                                          .get('thumbnail'),
                                      fit: BoxFit.fitWidth,
                                    ),
                                    title: snapshot.data!.docs
                                        .elementAt(index)
                                        .get('bookTitle'),
                                    author: snapshot.data!.docs
                                        .elementAt(index)
                                        .get('bookAuthor')
                                        .toString());
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
