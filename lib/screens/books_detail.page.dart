import 'package:background_app_bar/background_app_bar.dart';
import 'package:bitirme_proje/constants/entire_constants.dart';
import 'package:epub_viewer/epub_viewer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/booksModel/books.dart';
import '../providers/application_providers.dart';
import '../widgets/create_bottom_four_items.dart';

class BooksDetailPage extends ConsumerStatefulWidget {
  Object? booksModel;
  BooksDetailPage({Key? key, this.booksModel}) : super(key: key);

  @override
  _BooksDetailPageState createState() => _BooksDetailPageState();
}

class _BooksDetailPageState extends ConsumerState<BooksDetailPage> {
  PaletteGenerator? paletteGenerator;
  Color? baskinRenk;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    baskinRenk = Colors.orangeAccent;
    baskinRengiBul();
  }

  void baskinRengiBul() {
    Future<PaletteGenerator>? fPaletGenerator =
        PaletteGenerator.fromImageProvider(
            (widget.booksModel! as BooksModel).volumeInfo!.imageLinks != null
                ? NetworkImage((widget.booksModel! as BooksModel)
                    .volumeInfo!
                    .imageLinks!
                    .thumbnail!)
                : const AssetImage("assets/images/default.jpg")
                    as ImageProvider);
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
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            actions: [
              Row(
                children: [
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
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100)),
                          child: isDarkMode
                              ? const Icon(Icons.light_mode)
                              : const Icon(Icons.dark_mode)),
                    ),
                  ),
                ],
              )
            ],
            iconTheme: IconThemeData(color: Colors.white),
            expandedHeight: 150,
            floating: false,
            pinned: true,
            snap: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            flexibleSpace: BackgroundFlexibleSpaceBar(
              title: Text("Kitap Detayları",
                  style: EntireConstants.googleFontsCategoriesPageAppBar()),
              centerTitle: true,
              background: ClipRect(
                child: Container(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/bookDetailAppBarBack.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          )
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.9),
                    blurRadius: 5,
                    spreadRadius: 5)
              ]),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 300,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(
                                  image: (widget.booksModel! as BooksModel)
                                              .volumeInfo!
                                              .imageLinks ==
                                          null
                                      ? const AssetImage(
                                          "assets/images/default.jpg")
                                      : NetworkImage(
                                          (widget.booksModel! as BooksModel)
                                              .volumeInfo!
                                              .imageLinks!
                                              .thumbnail!) as ImageProvider),
                              color: baskinRenk,
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  width: 100.w,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      color: Color.fromARGB(255, 150, 19, 9),
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              left: Radius.circular(25))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        EntireConstants.bookTagsTop2[0],
                                        style: EntireConstants
                                            .googleFontsBookDetailBold(),
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
                                  width: 100.w,
                                  height: 4.8.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(255, 85, 21, 16),
                                          width: 2),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(25))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                          (widget.booksModel! as BooksModel)
                                                      .volumeInfo!
                                                      .title ==
                                                  null
                                              ? "-"
                                              : (widget.booksModel!
                                                      as BooksModel)
                                                  .volumeInfo!
                                                  .title!,
                                          maxLines: 1,
                                          style: EntireConstants
                                              .googleFontsBookDetail(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: (widget.booksModel! as BooksModel)
                                    .volumeInfo!
                                    .description ==
                                null
                            ? 12.h
                            : 24.h,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 7,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      color: Color.fromARGB(255, 150, 19, 9),
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                              left: Radius.circular(25))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        EntireConstants.bookTagsTop2[1],
                                        textAlign: TextAlign.center,
                                        style: EntireConstants
                                            .googleFontsBookDetailBold(),
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
                                  height: (widget.booksModel! as BooksModel)
                                              .volumeInfo!
                                              .description ==
                                          null
                                      ? 12.h
                                      : 24.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Color.fromARGB(255, 85, 21, 16),
                                          width: 2),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(25))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(children: [
                                      Center(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            (widget.booksModel! as BooksModel)
                                                        .volumeInfo!
                                                        .description ==
                                                    null
                                                ? "Açıklama yok"
                                                : (widget.booksModel!
                                                        as BooksModel)
                                                    .volumeInfo!
                                                    .description!,
                                            style: EntireConstants
                                                .googleFontsBookDetail(),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CreateBottomFourItems(
                        baskinRenk: baskinRenk,
                        details: (widget.booksModel! as BooksModel).volumeInfo,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: (widget.booksModel! as BooksModel)
                                    .accessInfo!
                                    .pdf!
                                    .isAvailable!
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton.icon(
                                  label: Text("PDF"),
                                  icon: Icon(Icons.account_circle),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 5, primary: Color(0xFB641010)),
                                  onPressed: () {
                                    EpubViewer.setConfig(
                                      themeColor:
                                          Theme.of(context).primaryColor,
                                      identifier: "androidBook",
                                      scrollDirection:
                                          EpubScrollDirection.VERTICAL,
                                      allowSharing: true,
                                      enableTts: true,
                                    );
                                    EpubViewer.open(
                                        (widget.booksModel! as BooksModel)
                                            .accessInfo!
                                            .pdf!
                                            .acsTokenLink!);
                                  }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton.icon(
                              label: (widget.booksModel! as BooksModel)
                                          .saleInfo!
                                          .buyLink !=
                                      null
                                  ? Text("Satın Al")
                                  : Text("Önizle"),
                              icon: Icon(Icons.account_circle),
                              style: ElevatedButton.styleFrom(
                                  elevation: 5, primary: Color(0xFB641010)),
                              onPressed: () {
                                String url = "";
                                print("URL : " +
                                    (widget.booksModel! as BooksModel)
                                        .saleInfo!
                                        .buyLink
                                        .toString());
                                print("PreviewURL : " +
                                    (widget.booksModel! as BooksModel)
                                        .volumeInfo!
                                        .previewLink
                                        .toString());

                                if ((widget.booksModel! as BooksModel)
                                        .saleInfo!
                                        .buyLink !=
                                    null) {
                                  url = (widget.booksModel! as BooksModel)
                                      .saleInfo!
                                      .buyLink!;
                                }

                                String? previewUrl =
                                    (widget.booksModel! as BooksModel)
                                        .volumeInfo!
                                        .previewLink!;
                                if (url.isNotEmpty) {
                                  _launchURL(buyUrl: url);
                                } else if (previewUrl.isNotEmpty) {
                                  _launchURL(previewLink: previewUrl);
                                } else {
                                  throw Exception("Hatalı URL");
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

void _launchURL({String? buyUrl, String? previewLink}) async {
  if (!await launch(buyUrl ?? previewLink!, enableJavaScript: true)) {
    throw 'Could not launch';
  }
}

void _launchPDF({String? pdfLink}) async {
  if (!await launch(pdfLink!, enableJavaScript: true)) {
    throw 'Could not launch';
  }
}
