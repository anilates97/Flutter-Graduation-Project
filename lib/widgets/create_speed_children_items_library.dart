// ignore: must_be_immutable
import 'dart:ui';

import 'package:bitirme_proje/constants/entire_constants.dart';
import 'package:bitirme_proje/screens/categories_page.dart';
import 'package:bitirme_proje/themes/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../providers/application_providers.dart';
import '../screens/home_page.dart';
import '../screens/shelf_page.dart';
import '../services/api_services.dart';
import '../services/firebase_auth_services.dart';
import '../screens/search_page.dart';
import 'add_categories_widget.dart';

class CreateSpeedChildrenLibrary extends ConsumerStatefulWidget {
  FirebaseAuthService user;
  String bookID;

  CreateSpeedChildrenLibrary({
    Key? key,
    required this.user,
    required this.bookID,
  }) : super(key: key);

  @override
  _CreateSpeedChildrenState createState() => _CreateSpeedChildrenState();
}

class _CreateSpeedChildrenState
    extends ConsumerState<CreateSpeedChildrenLibrary> {
  String? label;

  @override
  void initState() {
    super.initState();
    label = widget.user.getCurrentUser() == null ? "Giriş Yap" : "Çıkış Yap";
  }

  @override
  Widget build(BuildContext context) {
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
        SpeedDialChild(
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
                Navigator.pushNamed(context, '/HomePage');
              }
            }),
        SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              debugPrint("Kütüphanemde Kitap Ekle tıklandı");
              Navigator.pushNamed(context, '/AddBookPage');
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.book),
            label: "Kitap Ekle"),

        //
        SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              debugPrint("Raflar tıklandı");
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => BookShelfPage()));
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.bookmarks),
            label: "Raflar"),
        SpeedDialChild(
            labelStyle: !isDarkMode
                ? EntireConstants.googleFontsFloatingButtonsLight()
                : EntireConstants.googleFontsFloatingButtonsDark(),
            onTap: () {
              debugPrint("Kategoriler tıklandı");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CategoriesPage(
                            bookID: widget.bookID,
                          )));
            },
            backgroundColor:
                !isDarkMode ? const Color(0xFBBEEDED) : Colors.redAccent,
            child: const Icon(Icons.category),
            label: "Kategoriler"),
      ],
    );
  }

  Future<void> _showMyDialog() async {
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
          title: Text("Kategori Ekle"),
          content: AddCategoriesWidget(),
        );
      },
    );
  }
}
