import 'package:background_app_bar/background_app_bar.dart';
import 'package:bitirme_proje/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/entire_constants.dart';
import 'searched_home_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _editingController = TextEditingController();
  bool aramaDegeriYazar = false;
  bool aramaDegeriAd = false;
  bool aramaDegeriAradigimKitap = false;
  bool freeBook = false;
  bool paidBook = false;
  bool buttonisActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        flexibleSpace: BackgroundFlexibleSpaceBar(
          title: Text("Arama Ekranı",
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
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 16),
            _inputWidget(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(blurRadius: 4)]),
                child: Column(
                  children: [
                    CheckboxListTile(
                        title: Text("Yazara Göre Ara"),
                        value: aramaDegeriYazar,
                        onChanged: (value) {
                          setState(() {
                            aramaDegeriYazar = value!;
                            print("ARAMA DEĞERİ YAZAR BOOL DEĞERİ::: " +
                                aramaDegeriYazar.toString());
                          });
                        }),
                    CheckboxListTile(
                        title: Text("Kitap Adına Göre Ara"),
                        value: aramaDegeriAd,
                        onChanged: (value) {
                          setState(() {
                            aramaDegeriAd = value!;
                          });
                        }),
                    CheckboxListTile(
                        title: Text("Aradığım Kitabı Bul"),
                        value: aramaDegeriAradigimKitap,
                        onChanged: (value) {
                          setState(() {
                            aramaDegeriAradigimKitap = value!;
                            print("aramaDegeriAradigimKitap BOOL DEĞERİ::: " +
                                aramaDegeriYazar.toString());
                          });
                        }),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xFB641010)),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text("Ara", style: TextStyle(fontSize: 16)),
                      ),
                      onPressed: () {
                        final query = _editingController.text.toString();
                        if (query.isNotEmpty) {
                          Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => SearchedHomePage(
                                        gelenQueryAdBool: aramaDegeriAd,
                                        gelenQueryFindBook:
                                            aramaDegeriAradigimKitap,
                                        gelenQueryYazarBool: aramaDegeriYazar,
                                        gelenQuery: query,
                                        gelenQueryYazar: query,
                                      )));
                        }
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14)),
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                elevation: 5,
                              ),
                              onPressed: () {
                                freeBook = true;
                                final query =
                                    _editingController.text.toString();
                                if (query.isNotEmpty) {
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => SearchedHomePage(
                                                gelenQueryAdBool: aramaDegeriAd,
                                                gelenQueryFree: freeBook,
                                                gelenQueryYazarBool:
                                                    aramaDegeriYazar,
                                                gelenQuery: query,
                                                gelenQueryYazar: query,
                                              )));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Kitap adı giriniz");
                                }
                              },
                              icon: Icon(Icons.free_cancellation_outlined),
                              label: Center(
                                  child: Text(
                                "Ücretsiz Kitaplar",
                                textAlign: TextAlign.center,
                              ))),
                        ),
                        Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14)),
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                elevation: 5,
                              ),
                              onPressed: () {
                                paidBook = true;
                                final query =
                                    _editingController.text.toString();
                                if (query.isNotEmpty) {
                                  Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => SearchedHomePage(
                                                gelenQueryAdBool: aramaDegeriAd,
                                                gelenQueryPaid: paidBook,
                                                gelenQueryYazarBool:
                                                    aramaDegeriYazar,
                                                gelenQuery: query,
                                                gelenQueryYazar: query,
                                              )));
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Kitap adı giriniz");
                                }
                              },
                              icon: Icon(Icons.money),
                              label: Center(
                                  child: Text(
                                "Ücretli Kitaplar",
                                textAlign: TextAlign.center,
                              ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(blurRadius: 4)],
                      border: Border.all(width: 2, color: Colors.red),
                      borderRadius: BorderRadius.circular(14),
                      color: Color.fromARGB(255, 109, 19, 12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Not: Aradığınız ada göre ücretsiz veya ücretli kitaplar listelenmektedir."
                      "Herhangi bir şey girmezseniz hata alacaksanız.",
                      textAlign: TextAlign.center,
                      style:
                          GoogleFonts.mali(color: Colors.white, fontSize: 18),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        controller: _editingController,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
        decoration: InputDecoration(
          hintText: aramaDegeriAd
              ? "Kitap "
              : aramaDegeriYazar
                  ? "Yazar"
                  : "",
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFB641010),
            decoration: TextDecoration.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          contentPadding:
              const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 14),
        ),
      ),
    );
  }
}
