import 'package:bitirme_proje/screens/login_page.dart';
import 'package:bitirme_proje/services/firebase_auth_services.dart';
import 'package:bitirme_proje/services/firebase_database_services.dart';
import 'package:bitirme_proje/widgets/nav_bar_widget%20copy.dart';
import 'package:bitirme_proje/widgets/nav_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/application_providers.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  final FirebaseDatabaseService _firebaseDatabaseService =
      FirebaseDatabaseService();
  final FirebaseAuthService _authService = FirebaseAuthService();
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return StreamBuilder<DocumentSnapshot>(
        stream: _firebaseDatabaseService.fetchSignedUser(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Drawer(
              backgroundColor: !isDarkMode
                  ? Color.fromARGB(255, 252, 243, 242)
                  : Color.fromARGB(255, 48, 9, 5),
              elevation: 10,
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 104, 11, 11),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              CircleAvatar(
                                  radius: 50,
                                  foregroundImage: NetworkImage(
                                    snapshot.data!.get('profilImage'),
                                  )),
                            ]),
                            Column(children: [
                              Text(
                                snapshot.data!.get('nameSurname'),
                                style: GoogleFonts.mali(
                                    fontSize: 14, color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapshot.data!.get('email'),
                                style: GoogleFonts.mali(
                                    fontSize: 14, color: Colors.white),
                              )
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (() =>
                        Navigator.pushNamed(context, '/MyLibraryPage')),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kütüphane Dünyası",
                            style:
                                GoogleFonts.mali(fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.local_library,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/MyProfilPage'),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profilim",
                            style:
                                GoogleFonts.mali(fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.account_box,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: !isDarkMode ? Colors.black : Colors.white,
                  ),
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
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              !isDarkMode ? "Gece Modu" : "Gündüz Modu",
                              style: !isDarkMode
                                  ? GoogleFonts.mali(
                                      fontWeight: FontWeight.bold)
                                  : GoogleFonts.mali(
                                      fontWeight: FontWeight.bold),
                            ),
                            isDarkMode
                                ? const Icon(
                                    Icons.light_mode,
                                    color: Colors.red,
                                  )
                                : const Icon(
                                    Icons.dark_mode,
                                    color: Colors.red,
                                  ),
                          ],
                        )),
                  ),
                  Container(
                    height: 1,
                    color: !isDarkMode ? Colors.black : Colors.white,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/ContactUsPage'),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bize Ulaşın",
                            style:
                                GoogleFonts.mali(fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.chat,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_authService.getCurrentUser() != null) {
                        _authService.logOut();
                        Navigator.pop(context);
                      } else {}
                    },
                    child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Çıkış Yap",
                              style:
                                  GoogleFonts.mali(fontWeight: FontWeight.bold),
                            ),
                            const Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            )
                          ],
                        )),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
