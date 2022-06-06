import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import '../constants/entire_constants.dart';
import '../providers/application_providers.dart';

class CreateBottomFourItems extends ConsumerWidget {
  Color? baskinRenk;
  VolumeInfo? details;
  CreateBottomFourItems({Key? key, required this.details, this.baskinRenk})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Column(
      children: [
        bottomRowOneCreate(details!, baskinRenk, ref, isDarkMode),
        bottomRowTwoCreate(details!, baskinRenk, ref, isDarkMode),
        bottomRowThreeCreate(details!, baskinRenk, ref, isDarkMode),
        bottomRowFourCreate(details!, baskinRenk, ref, isDarkMode)
      ],
    );
  }
}

Row bottomRowOneCreate(
    VolumeInfo data, Color? baskinRenk, WidgetRef ref, bool isDarkMode) {
  return Row(
    children: [
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Color.fromARGB(255, 150, 19, 9),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  EntireConstants.bookTags[0],
                  style: EntireConstants.googleFontsBookDetailBold(),
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 15,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 85, 21, 16), width: 2),
                color: Colors.white,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  data.authors == null ? "Yazar Yok" : data.authors.toString(),
                  style: EntireConstants.googleFontsBookDetail(),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Row bottomRowTwoCreate(
    VolumeInfo data, Color? baskinRenk, WidgetRef ref, bool isDarkMode) {
  return Row(
    children: [
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Color.fromARGB(255, 150, 19, 9),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  EntireConstants.bookTags[1],
                  style: EntireConstants.googleFontsBookDetailBold(),
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 15,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 85, 21, 16), width: 2),
                color: Colors.white,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  data.publishedDate.toString(),
                  style: EntireConstants.googleFontsBookDetail(),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Row bottomRowThreeCreate(
    VolumeInfo data, Color? baskinRenk, WidgetRef ref, bool isDarkMode) {
  return Row(
    children: [
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Color.fromARGB(255, 150, 19, 9),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  EntireConstants.bookTags[2],
                  textAlign: TextAlign.center,
                  style: EntireConstants.googleFontsBookDetailBold(),
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 15,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 85, 21, 16), width: 2),
                color: Colors.white,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  data.pageCount == null
                      ? "Belirtilmemiş"
                      : data.pageCount.toString(),
                  style: EntireConstants.googleFontsBookDetail(),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Row bottomRowFourCreate(
    VolumeInfo data, Color? baskinRenk, WidgetRef ref, bool isDarkMode) {
  return Row(
    children: [
      Expanded(
        flex: 7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: Color.fromARGB(255, 150, 19, 9),
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  EntireConstants.bookTags[3],
                  style: EntireConstants.googleFontsBookDetailBold(),
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 15,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 4.5.h,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromARGB(255, 85, 21, 16), width: 2),
                color: Colors.white,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  data.language!,
                  style: EntireConstants.googleFontsBookDetail(),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
