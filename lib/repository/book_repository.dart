import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../constants/entire_constants.dart';

abstract class BookRepository {
  Future<List<BooksModel>> fetchBooks(String bookName);
  Future<List<BooksModel>> fetchBooksByAuthor(String authorName);
  Future<List<BooksModel>> fetchBooksByFreeBooks(String bookName);
  Future<List<BooksModel>> fetchBooksByPaidBooks(String bookName);
  Future<List<BooksModel>> fetchBookFullSearchedWord(String entireFullName);
}

class APIBookRepository implements BookRepository {
  List<BooksModel> books = [];
  int page = 0;
  String? query;

  @override
  Future<List<BooksModel>> fetchBooks(String? bookName) async {
    try {
      var url = EntireConstants.BASE_URL +
          page.toString() +
          EntireConstants.KEYWORD +
          bookName!;
      print("metot çalıştı::::::::::" + url);
      Dio dio = Dio();

      //Eski telefonlar için
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(url);
      debugPrint("RESPONSE: " + response.data['items'].toString());

      List<BooksModel> bookList = [];

      for (var item in response.data['items']) {
        bookList.add(BooksModel.fromJson(item));
      }

      books.addAll(bookList);

      //page = 40;

      if (response.statusCode == 200) {
        print("boooooooooklist: " + bookList[0].toString());
        return bookList;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }

  @override
  Future<List<BooksModel>> fetchBooksByAuthor(String? authorName) async {
    try {
      var url = EntireConstants.BASE_URL +
          page.toString() +
          EntireConstants.KEYWORD +
          "inauthor:" +
          authorName!;
      print("metot çalıştı::::::::::" + url);
      Dio dio = Dio();

      //Eski telefonlar için
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(url);
      debugPrint("RESPONSE: " + response.data['items'].toString());

      List<BooksModel> bookList = [];

      for (var item in response.data['items']) {
        bookList.add(BooksModel.fromJson(item));
      }

      books.addAll(bookList);

      page = 40;

      if (response.statusCode == 200) {
        print("boooooooooklist: " + bookList[0].toString());
        return bookList;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }

  @override
  Future<List<BooksModel>> fetchBooksByFreeBooks(String bookName) async {
    try {
      var url = EntireConstants.BASE_URL +
          page.toString() +
          EntireConstants.KEYWORD +
          bookName +
          EntireConstants.FREE_BOOKS;
      print("metot çalıştı freeee::::::::::" + url);
      Dio dio = Dio();

      //Eski telefonlar için
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(url);
      debugPrint("RESPONSE: " + response.data['items'].toString());

      List<BooksModel> bookList = [];

      for (var item in response.data['items']) {
        bookList.add(BooksModel.fromJson(item));
      }

      books.addAll(bookList);

      page = 40;

      if (response.statusCode == 200) {
        print("boooooooooklist: " + bookList[0].toString());
        return bookList;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }

  @override
  Future<List<BooksModel>> fetchBooksByPaidBooks(String bookName) async {
    try {
      var url = EntireConstants.BASE_URL +
          page.toString() +
          EntireConstants.KEYWORD +
          bookName +
          EntireConstants.PAID_BOOKS;
      print("metot çalıştı freeee::::::::::" + url);
      Dio dio = Dio();

      //Eski telefonlar için
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(url);
      debugPrint("RESPONSE: " + response.data['items'].toString());

      List<BooksModel> bookList = [];

      for (var item in response.data['items']) {
        bookList.add(BooksModel.fromJson(item));
      }

      books.addAll(bookList);

      page = 40;

      if (response.statusCode == 200) {
        print("boooooooooklist: " + bookList[0].toString());
        return bookList;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }

  @override
  Future<List<BooksModel>> fetchBookFullSearchedWord(
      String entireFullName) async {
    try {
      var url = EntireConstants.BASE_URL +
          page.toString() +
          EntireConstants.KEYWORD +
          entireFullName +
          EntireConstants.FULL_SEARCH_WORD_RESULT;
      print("metot çalıştı ALL BOOKSS::::::::::" + url);
      Dio dio = Dio();

      //Eski telefonlar için
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(url);
      debugPrint("RESPONSE: " + response.data['items'].toString());

      List<BooksModel> bookList = [];

      for (var item in response.data['items']) {
        bookList.add(BooksModel.fromJson(item));
      }

      books.addAll(bookList);

      page = 40;

      if (response.statusCode == 200) {
        print("boooooooooklist: " + bookList[0].toString());
        return bookList;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }
}
