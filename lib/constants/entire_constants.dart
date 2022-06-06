
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EntireConstants {
  EntireConstants._();

  //API
  // ignore: constant_identifier_names
  static const BASE_URL_ONE_BOOK =
      "https://www.googleapis.com/books/v1/volumes/";
  static const BASE_URL =
      "https://www.googleapis.com/books/v1/volumes?&maxResults=40&startIndex=";

  static const BASE_URL_KEYWORD =
      "https://www.googleapis.com/books/v1/volumes?&maxResults=40&startIndex=";
  static const KEYWORD = "&q=";
  static const FREE_BOOKS = "&filter=free-ebooks";
  static const PAID_BOOKS = "&filter=paid-ebooks";
  static const FULL_SEARCH_WORD_RESULT = " &filter=full";
  static const KEYWORD_SUBJECT = "&q=subject:";
  static const ORDER_BY_NEWEST = "&orderBy=newest";

  static const List<String> bookTags = [
    "Yazar",
    "Yayınlanma",
    "Sayfa Sayısı",
    "Dil",
  ];

  static const List<String> bookTagsTop2 = [
    "Kitap Adı",
    "Kitap Açıklaması",
  ];

  //STYLES
  static TextStyle whiteText12() {
    return const TextStyle(color: Colors.white, fontSize: 12);
  }

  static TextStyle whiteText10() {
    return const TextStyle(
        color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold);
  }

  static TextStyle greyText10() {
    return const TextStyle(color: Colors.grey, fontSize: 9);
  }

  static TextStyle whiteText20Weight() {
    return const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500);
  }

  //COLORS
  static Color cardBackColor() {
    return const Color(0xFB641010);

    //return const Color(0xFB641010);
  }

  static Color detailBooksBackColor() {
    return const Color(0xFB641010);
  }

  static TextStyle googleFontsCategoriesItems() {
    return GoogleFonts.mali(
        color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold);
  }

  static TextStyle googleFontsCategoriesPageAppBar() {
    return GoogleFonts.mali(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  }

  static TextStyle googleFontsWhiteBold12() {
    return GoogleFonts.mali(
        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
  }

  static TextStyle googleFontsWhite() {
    return GoogleFonts.mali(color: Colors.white, fontWeight: FontWeight.bold);
  }

//HomePage
  static TextStyle googleFontsHomePageCaptionDescriptionLight() {
    return GoogleFonts.mali(color: Colors.black.withAlpha(150));
  }

  static TextStyle googleFontsHomePageCaptionDescriptionDark() {
    return GoogleFonts.mali(color: Colors.white);
  }

  static TextStyle googleFontsHomePageBodyText2TitleLight() {
    return GoogleFonts.mali(color: Colors.black);
  }

  static TextStyle googleFontsHomePageBodyText2TitleDark() {
    return GoogleFonts.mali(color: Colors.white);
  }

  static TextStyle googleFontsHomePageBodyText1PriceDark() {
    return GoogleFonts.mali(color: Colors.white);
  }

  static TextStyle googleFontsHomePageBodyText1PriceLight() {
    return GoogleFonts.mali(color: Colors.black);
  }

//MyLibraryPage
  static TextStyle googleFontsMyLibraryPageTitle() {
    return GoogleFonts.mali(color: Colors.black, fontWeight: FontWeight.bold);
  }

  static TextStyle googleFontsMyLibraryPageDescription() {
    return GoogleFonts.mali(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12);
  }

  static TextStyle googleFontsFloatingButtonsLight() {
    return GoogleFonts.mali(color: Colors.black);
  }

  static TextStyle googleFontsMyLibraryPageAppBarDark() {
    return GoogleFonts.mali(color: Colors.black);
  }

  static TextStyle googleFontsMyLibraryPageAppBar() {
    return GoogleFonts.mali(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  }

//FloatingButtons
  static TextStyle googleFontsFloatingButtonsDark() {
    return GoogleFonts.mali(color: Colors.white);
  }

  static TextStyle googleFontsMyLibraryPageAppBarLight() {
    return GoogleFonts.mali(color: Colors.white);
  }

  //BookDetailPage
  static TextStyle googleFontsBookDetail() {
    return GoogleFonts.mali(color: Colors.black, fontSize: 11);
  }

  static TextStyle googleFontsBookDetailBold() {
    return GoogleFonts.mali(
      fontWeight: FontWeight.bold,
      fontSize: 11,
      foreground: Paint()
        ..style = PaintingStyle.fill
        ..strokeWidth = 0.2 // .. operaratörünü araştır
        ..color = Colors.white,
    );
  }
}
