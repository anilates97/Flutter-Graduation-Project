// ignore: must_be_immutable
import 'dart:math';

import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:bitirme_proje/providers/api_providers.dart';
import 'package:bitirme_proje/screens/login_page.dart';
import 'package:bitirme_proje/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants/entire_constants.dart';
import '../providers/application_providers.dart';
import '../screens/home_page.dart';
import '../screens/login_page2.dart';
import '../services/api_services.dart';
import '../services/firebase_auth_services.dart';
import '../screens/search_page.dart';
import 'get_random_books_widget.dart';

class CreateSpeedChildrenHome extends ConsumerStatefulWidget {
  FirebaseAuthService user;
  List<BooksModel> booksModel;
  String gelenQuery;
  CreateSpeedChildrenHome(
      {Key? key,
      required this.user,
      required this.booksModel,
      required this.gelenQuery})
      : super(key: key);

  @override
  _CreateSpeedChildrenState createState() => _CreateSpeedChildrenState();
}

class _CreateSpeedChildrenState extends ConsumerState<CreateSpeedChildrenHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int randomIndex = Random().nextInt(2);

    final dataProvider = ref.watch(getBooksProvider("insan"));
    final isDarkMode = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);

    return SpeedDial(
      backgroundColor: isDarkMode
          ? AppTheme.darkTheme.floatingActionButtonTheme.backgroundColor
          : AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
      foregroundColor: isDarkMode
          ? AppTheme.darkTheme.floatingActionButtonTheme.foregroundColor
          : AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
      overlayColor: Colors.black.withOpacity(0.9),
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        /* SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            child: widget.user.getCurrentUser() != null
                ? const Icon(Icons.logout)
                : const Icon(Icons.supervised_user_circle),
            label: widget.user.getCurrentUser() == null ? label : label,
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            onTap: () {
              if (widget.user.getCurrentUser() != null) {
                setState(() {
                  widget.user.logOut();
                });
              } else {
                Navigator.pushNamed(context, '/LoginPage');
              }
            }), */
        SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              debugPrint("Kitap Ara tıklandı");
              Navigator.pushNamed(context, '/SearchPage');
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.search_sharp),
            label: "Kitap Ara"),
        /*  SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              debugPrint("My Library  tıklandı");
              if (widget.user.getCurrentUser() != null) {
                Navigator.pushNamed(context, '/MyLibraryPage');
              } else {
                SnackBar snackBar =
                    SnackBar(content: Text("Lütfen giriş yapınız"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.my_library_books),
            label: "Kütüphane Dünyam"), */
        SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              debugPrint("Kullanıcı Bilgileri  tıklandı");
              if (widget.user.getCurrentUser() != null) {
                Navigator.pushReplacementNamed(context, '/MyProfilPage');
              } else {
                SnackBar snackBar =
                    SnackBar(content: Text("Lütfen giriş yapınız"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.add_task),
            label: "Kullanıcı Bilgileri"),
        /* SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginPage2()));
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.collections_bookmark),
            label: "Giriş Yap"), */

        //
      ],
    );
  }

  void _openSearchBottomSheet() {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        barrierColor: Colors.transparent,
        elevation: 10,
        isScrollControlled: true,
        builder: (_) {
          return FractionallySizedBox(
            heightFactor:
                MediaQuery.of(context).viewInsets.bottom == 0 ? 0.3 : 0.7,
            child: SearchPage(),
          );
        }).then((value) {
      if (value != null) {
        try {
          APIBookServices service = APIBookServices();
          service.query = value;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            print(service.query);
            return HomePage(
              gelenQuery: service.query!,
            );
          }));
        } catch (e) {
          print("HATA : " + e.toString());
        }
      }
    });
  }
}
