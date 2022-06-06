import 'package:bitirme_proje/constants/entire_constants.dart';
import 'package:flutter/material.dart';

class MyCustomGridViewCategoryWithBook extends StatelessWidget {
  final Widget? thumbnail;
  final String title;
  final String? description;
  final String author;

  const MyCustomGridViewCategoryWithBook(
      {Key? key,
      required this.thumbnail,
      required this.title,
      this.description,
      required this.author})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Stack(
        children: [
          Container(
            child: thumbnail!,
            color: Colors.red,
            width: double.infinity,
          ),
          Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
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
              ))
        ],
      ),
    );
  }
}
