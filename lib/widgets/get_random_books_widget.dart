import 'dart:math';

import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../providers/api_providers.dart';

class GetRandomBook extends ConsumerStatefulWidget {
  List<BooksModel> allBooks;
  GetRandomBook({Key? key, required this.allBooks}) : super(key: key);

  @override
  _GetRandomBookState createState() => _GetRandomBookState();
}

class _GetRandomBookState extends ConsumerState<GetRandomBook> {
  @override
  Widget build(BuildContext context) {
    if (widget.allBooks.isEmpty) {
      print("LİSTE BOŞ!!");
    } else {
      print("LİSTE DOLU");
    }

    List<String> booksModel = [];
    for (BooksModel model in widget.allBooks) {
      booksModel.add(model.id!);

      /* print("************************* \n *************** ");
      print("BOOKSMODEL: " + model.id!); */
    }

    int randomIndex = Random().nextInt(booksModel.length);

    print("RANDOM INDEX : " + randomIndex.toString());

    final provider =
        ref.watch(getBookByIDProvider(widget.allBooks[randomIndex].id!));

    return provider.when(
        data: (data) {
          print("DATAAAAAAAAAAAAAA: " + data.id.toString());
          return Container(
              child: Expanded(
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: data.volumeInfo!.imageLinks == null
                        ? Image.asset("assets/images/default.jpg")
                        : Image.network(
                            data.volumeInfo!.imageLinks!.thumbnail!,
                            width: 128,
                            height: 200,
                            scale: 1,
                            fit: BoxFit.fill,
                          )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                child: Text("Kitap Adı",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12))),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  data.volumeInfo!.title == null
                                      ? "Belirtilmemiş"
                                      : data.volumeInfo!.title!,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            ),
                          )),
                    ),
                  ],
                ),
                /*   Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Kitap Açıklama",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 12)),
                          )),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(blurRadius: 4, spreadRadius: 4)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  data.volumeInfo!.description == null
                                      ? "Açıklama yok"
                                      : data.volumeInfo!.description!,
                                  style:
                                      TextStyle(color: Colors.red, fontSize: 12)),
                            )),
                      ),
                    ),
                  ],
                ), */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Yazar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  data.volumeInfo!.authors == null
                                      ? "Belirtilmemiş"
                                      : data.volumeInfo!.authors.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Yayınlanma",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                data.volumeInfo!.publishedDate == null
                                    ? "-"
                                    : data.volumeInfo!.publishedDate!,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12)),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Sayfa Sayısı",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 35.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(blurRadius: 4, spreadRadius: 4)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                data.volumeInfo!.pageCount == null
                                    ? "Belirtilmemiş"
                                    : data.volumeInfo!.pageCount!.toString(),
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12)),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ));
        },
        error: (e, s) => Text("HATAAAA" + s.toString()),
        loading: () {
          return Center(child: Lottie.asset("assets/images/lucky.json"));
        });
  }
}
