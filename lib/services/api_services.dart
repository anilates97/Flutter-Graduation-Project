import 'dart:convert';

import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../constants/entire_constants.dart';

abstract class BookServices {
  Future<List<BooksModel>> fetchBooks(String bookName);
}

class APIBookServices implements BookServices {
  List<BooksModel> books = [];
  List<BooksModel> searchBooks = [];
  List<BooksModel> categoryWithBooks = [];
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

      //page += 40;

      print("PAGE: " + page.toString());

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

      searchBooks.addAll(bookList);

      page = 40;

      if (response.statusCode == 200) {
        print("boooooooooklist: " + bookList[0].toString());
        return searchBooks;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }

  Future<BooksModel> fetchBookByID(String? bookID) async {
    try {
      var url = EntireConstants.BASE_URL_ONE_BOOK + bookID!;
      print("metot çalıştı BYIDDDD::::::::::" + url);
      Dio dio = Dio();

      //Eski telefonlar için
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      final response = await dio.get(url);
      // var bookMap = await jsonDecode(response.data);

      debugPrint("RESPONSEIDBOOOOOK: " + response.data.toString());

      final bookData = response.data as Map<String, dynamic>;
      final data = BooksModel.fromJson(bookData);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception("404 NOT FOUND");
      }
    } catch (e) {
      print(e.toString());
      throw Exception("HATAAAAAAAAAAAAAA : NORMAL");
    }
  }

  Future<List<BooksModel>> fetchBooksByCategory(String? categoryName) async {
    try {
      var url = EntireConstants.BASE_URL +
          page.toString() +
          EntireConstants.KEYWORD_SUBJECT +
          categoryName! +
          EntireConstants.ORDER_BY_NEWEST;

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

      categoryWithBooks.addAll(bookList);

      page = 0;

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
