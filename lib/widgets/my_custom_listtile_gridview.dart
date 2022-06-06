import 'package:bitirme_proje/constants/entire_constants.dart';
import 'package:flutter/material.dart';

class MyCustomListTileGridView extends StatelessWidget {
  bool isBookPrivate;
  final Widget? thumbnail;
  final String title;
  final String? description;
  final String author;

  MyCustomListTileGridView(
      {Key? key,
      required this.thumbnail,
      required this.title,
      this.description,
      required this.author,
      required this.isBookPrivate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: !isBookPrivate ? Colors.white70 : Colors.black.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: thumbnail!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white70),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(title,
                                style: EntireConstants
                                    .googleFontsMyLibraryPageTitle()))),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
