import 'dart:async';

import 'package:bitirme_proje/screens/library_of_user_page.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sizer/sizer.dart';

class OtherProfilesPage extends ConsumerStatefulWidget {
  DocumentSnapshot<Object?> elemenAt;
  OtherProfilesPage({Key? key, required this.elemenAt}) : super(key: key);

  @override
  _OtherProfilesPageState createState() => _OtherProfilesPageState();
}

class _OtherProfilesPageState extends ConsumerState<OtherProfilesPage> {
  final StreamController<bool> _controller = StreamController();
  String infoFollow = "Takip Et";
  String infoFollows = "";
  bool visibleButtonFollow = true;
  bool visibleButtonFollowing = false;
  PaletteGenerator? paletteGenerator;
  Color? baskinRenk;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FirebaseDatabaseService _firebaseDatabaseService =
      FirebaseDatabaseService();

  void baskinRengiBul() {
    Future<PaletteGenerator>? fPaletGenerator =
        PaletteGenerator.fromImageProvider(
            NetworkImage(widget.elemenAt.get('profilImage')));
    fPaletGenerator.then((value) {
      paletteGenerator = value;
      // debugPrint("secilen renk :" + paletteGenerator.dominantColor.color.toString());

      if (paletteGenerator != null && paletteGenerator!.vibrantColor != null) {
        baskinRenk = paletteGenerator!.vibrantColor!.color;
        setState(() {});
      } else if (paletteGenerator != null &&
          paletteGenerator!.dominantColor != null) {
        baskinRenk = paletteGenerator!.dominantColor!.color;
        setState(() {});
      } else {
        debugPrint("NULL COLOR");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    baskinRenk = Colors.orangeAccent;
    baskinRengiBul();
  }

  @override
  Widget build(BuildContext context) {
    var collectionReference = FirebaseFirestore.instance.collection('users');

    print("baskın renk: " + baskinRenk.toString());
    return AbsorbPointer(
      absorbing: false,
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: _firebaseDatabaseService
                .fetchSelectedUser(widget.elemenAt.get("userID")),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!
                    .get('followers')
                    .toString()
                    .contains(_firebaseAuthService.getCurrentUser()!.uid)) {
                  infoFollow = "Takip Ediliyor";
                } else if (!snapshot.data!
                    .get('followers')
                    .toString()
                    .contains(_firebaseAuthService.getCurrentUser()!.uid)) {
                  infoFollow = "Takip Et";
                }
                return Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Stack(alignment: Alignment.topCenter, children: [
                          Opacity(
                            opacity: 0.5,
                            child: ClipPath(
                              clipper: WaveClipperUp(),
                              child: Container(
                                color: baskinRenk,
                                height: 250,
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: WaveClipperUp(),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(widget.elemenAt.get('nameSurname'),
                                  style: GoogleFonts.mali(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              color: baskinRenk,
                              height: 230,
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Container(
                              height: 75.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 300,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        image: DecorationImage(
                                            image: NetworkImage(widget.elemenAt
                                                .get('profilImage'))),
                                        color: baskinRenk,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: firstRowWidget(snapshot),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  secondRowWidget(),
                                  thirdRowWidget(),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: collectionReference
                                                .doc(widget.elemenAt
                                                    .get('userID'))
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return !snapshot.data!
                                                        .get('isLibraryPrivate')
                                                    ? ElevatedButton.icon(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                shadowColor:
                                                                    Colors.red,
                                                                primary: Colors
                                                                    .white),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) => LibraryPageOfUser(
                                                                      userID: widget
                                                                          .elemenAt
                                                                          .get(
                                                                              'userID'))));
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .local_library_sharp,
                                                          color: Colors.red,
                                                        ),
                                                        label: Center(
                                                          child: Text(
                                                            "Kitap Arşivi",
                                                            style: GoogleFonts
                                                                .mali(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ))
                                                    : Container();
                                              } else {
                                                return Center(
                                                  child: Container(),
                                                );
                                              }
                                            }),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Stack(
                                          children: [
                                            Visibility(
                                              visible: visibleButtonFollow,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      shadowColor: Colors.red,
                                                      primary: infoFollow ==
                                                              "Takip Ediliyor"
                                                          ? Colors.red
                                                          : Colors.white),
                                                  onPressed: () async {
                                                    _firebaseAuthService
                                                        .followUser(widget
                                                            .elemenAt
                                                            .get('userID'));
                                                    setState(() {
                                                      infoFollow =
                                                          "Takip Ediliyor";
                                                      visibleButtonFollow =
                                                          false;
                                                      visibleButtonFollowing =
                                                          true;
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text(infoFollow,
                                                        style: GoogleFonts.mali(
                                                            color: infoFollow !=
                                                                    "Takip Ediliyor"
                                                                ? Colors.red
                                                                : Colors
                                                                    .white)),
                                                  )),
                                            ),
                                            //***************************************************************** */
                                            Visibility(
                                              visible: visibleButtonFollowing,
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shadowColor:
                                                              Colors.red,
                                                          primary: Colors.red),
                                                  onPressed: () async {
                                                    _displayDialog(
                                                        context,
                                                        _firebaseAuthService,
                                                        widget.elemenAt
                                                            .get('userID'));
                                                    setState(() {
                                                      infoFollow = "Takip Et";
                                                      visibleButtonFollow =
                                                          true;
                                                      visibleButtonFollowing =
                                                          false;
                                                    });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                        "Takip Ediliyor",
                                                        style: GoogleFonts.mali(
                                                            color:
                                                                Colors.white)),
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(blurRadius: 3, spreadRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
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
            }),
      ),
    );
  }

  Row firstRowWidget(AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
    List<dynamic> followers = snapshot.data!.get('followers');
    List<dynamic> following = snapshot.data!.get('following');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 17.w,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 2)],
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(14)),
                  color: Color.fromARGB(255, 37, 20, 18)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Takipçi",
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 10)),
              )),
          Container(
              width: 15.w,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 2)],
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(14)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(followers.length.toString(),
                      style:
                          GoogleFonts.mali(color: Colors.black, fontSize: 10)),
                ),
              )),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 25.w,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 2)],
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(14)),
                  color: Color.fromARGB(255, 37, 20, 18)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Takip Edilen",
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 10)),
              )),
          Container(
              width: 20.w,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 4, spreadRadius: 2)],
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(14)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(following.length.toString(),
                      style:
                          GoogleFonts.mali(color: Colors.black, fontSize: 10)),
                ),
              )),
        ]),
      ],
    );
  }

  Row thirdRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Email",
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 11),
                  )),
                ),
                width: 25.w,
                height: 7.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Color.fromARGB(255, 146, 21, 12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(widget.elemenAt.get('email'),
                style: GoogleFonts.mali(fontSize: 11))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "İlgi Alanları",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 11),
                  )),
                ),
                width: 25.w,
                height: 7.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Color.fromARGB(255, 146, 21, 12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(widget.elemenAt.get('ilgiAlanlari'),
                style: GoogleFonts.mali(fontSize: 11))
          ],
        ),
      ],
    );
  }

  Row secondRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Ad Soyad",
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 11),
                  )),
                ),
                width: 25.w,
                height: 7.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Color.fromARGB(255, 146, 21, 12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              widget.elemenAt.get('nameSurname'),
              style: GoogleFonts.mali(fontSize: 11),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Yaş",
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 11),
                  )),
                ),
                width: 25.w,
                height: 7.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Color.fromARGB(255, 146, 21, 12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(widget.elemenAt.get('yas'),
                style: GoogleFonts.mali(fontSize: 11))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    "Cinsiyet",
                    style: GoogleFonts.mali(color: Colors.white, fontSize: 11),
                  )),
                ),
                width: 25.w,
                height: 7.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Color.fromARGB(255, 146, 21, 12),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(widget.elemenAt.get('gender'),
                style: GoogleFonts.mali(fontSize: 11))
          ],
        ),
      ],
    );
  }

  Future<String> asyncCall() async {
    var result = "result";
    await Future.delayed(Duration(seconds: 10));
    _controller.add(false);
    return result;
  }
}

bool _displayDialog(BuildContext context, _firebaseAuthService, String userID) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
                onPressed: () {
                  _firebaseAuthService.unFollowUser(userID);
                  Navigator.pop(context);
                },
                child: Text("Evet"))
          ],
          content: Text("Takipten çıkmak istediğinizden emin misiniz?"),
        );
      });
  return true;
}

class WaveClipperUp extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);

    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 5), size.height - 105);

    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WaveClipperDown extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width / 5, size.height);

    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 5), size.height - 105);

    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
