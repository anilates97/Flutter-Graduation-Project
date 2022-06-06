// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

BooksModel booksModelFromJson(String str) =>
    BooksModel.fromJson(json.decode(str));

String booksModelToJson(BooksModel data) => json.encode(data.toJson());

class BooksModel {
  BooksModel({
    this.kind,
    this.id,
    this.etag,
    this.selfLink,
    this.volumeInfo,
    this.saleInfo,
    this.accessInfo,
  });

  String? kind;
  String? id;
  String? etag;
  String? selfLink;
  VolumeInfo? volumeInfo;
  SaleInfo? saleInfo;
  AccessInfo? accessInfo;

  @override
  String toString() {
    return volumeInfo.toString();
  }

  factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        kind: json["kind"] == null ? null : json["kind"],
        id: json["id"] == null ? null : json["id"],
        etag: json["etag"] == null ? null : json["etag"],
        selfLink: json["selfLink"] == null ? null : json["selfLink"],
        volumeInfo: json["volumeInfo"] == null
            ? null
            : VolumeInfo.fromJson(json["volumeInfo"]),
        saleInfo: json["saleInfo"] == null
            ? null
            : SaleInfo.fromJson(json["saleInfo"]),
        accessInfo: json["accessInfo"] == null
            ? null
            : AccessInfo.fromJson(json["accessInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind == null ? null : kind,
        "id": id == null ? null : id,
        "etag": etag == null ? null : etag,
        "selfLink": selfLink == null ? null : selfLink,
        "volumeInfo": volumeInfo == null ? null : volumeInfo!.toJson(),
        "saleInfo": saleInfo == null ? null : saleInfo!.toJson(),
        "accessInfo": accessInfo == null ? null : accessInfo!.toJson(),
      };
}

class AccessInfo {
  AccessInfo({
    this.country,
    this.viewability,
    this.embeddable,
    this.publicDomain,
    this.textToSpeechPermission,
    this.epub,
    this.pdf,
    this.webReaderLink,
    this.accessViewStatus,
    this.quoteSharingAllowed,
  });

  String? country;
  String? viewability;
  bool? embeddable;
  bool? publicDomain;
  String? textToSpeechPermission;
  Epub? epub;
  Epub? pdf;
  String? webReaderLink;
  String? accessViewStatus;
  bool? quoteSharingAllowed;

  factory AccessInfo.fromJson(Map<String, dynamic> json) => AccessInfo(
        country: json["country"] == null ? null : json["country"],
        viewability: json["viewability"] == null ? null : json["viewability"],
        embeddable: json["embeddable"] == null ? null : json["embeddable"],
        publicDomain:
            json["publicDomain"] == null ? null : json["publicDomain"],
        textToSpeechPermission: json["textToSpeechPermission"] == null
            ? null
            : json["textToSpeechPermission"],
        epub: json["epub"] == null ? null : Epub.fromJson(json["epub"]),
        pdf: json["pdf"] == null ? null : Epub.fromJson(json["pdf"]),
        webReaderLink:
            json["webReaderLink"] == null ? null : json["webReaderLink"],
        accessViewStatus:
            json["accessViewStatus"] == null ? null : json["accessViewStatus"],
        quoteSharingAllowed: json["quoteSharingAllowed"] == null
            ? null
            : json["quoteSharingAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "country": country == null ? null : country,
        "viewability": viewability == null ? null : viewability,
        "embeddable": embeddable == null ? null : embeddable,
        "publicDomain": publicDomain == null ? null : publicDomain,
        "textToSpeechPermission":
            textToSpeechPermission == null ? null : textToSpeechPermission,
        "epub": epub == null ? null : epub!.toJson(),
        "pdf": pdf == null ? null : pdf!.toJson(),
        "webReaderLink": webReaderLink == null ? null : webReaderLink,
        "accessViewStatus": accessViewStatus == null ? null : accessViewStatus,
        "quoteSharingAllowed":
            quoteSharingAllowed == null ? null : quoteSharingAllowed,
      };
}

class Epub {
  Epub({
    this.isAvailable,
    this.acsTokenLink,
  });

  bool? isAvailable;
  String? acsTokenLink;

  factory Epub.fromJson(Map<String, dynamic> json) => Epub(
        isAvailable: json["isAvailable"] == null ? null : json["isAvailable"],
        acsTokenLink:
            json["acsTokenLink"] == null ? null : json["acsTokenLink"],
      );

  Map<String, dynamic> toJson() => {
        "isAvailable": isAvailable == null ? null : isAvailable,
        "acsTokenLink": acsTokenLink == null ? null : acsTokenLink,
      };
}

class SaleInfo {
  SaleInfo(
      {this.country,
      this.saleability,
      this.buyLink,
      this.isEbook,
      this.listPrice,
      this.retailPrice});

  String? country;
  String? saleability;
  String? buyLink;
  bool? isEbook;
  SaleInfoListPrice? listPrice;
  SaleInfoListPrice? retailPrice;

  factory SaleInfo.fromJson(Map<String, dynamic> json) => SaleInfo(
        country: json["country"] == null ? null : json["country"],
        saleability: json["saleability"] == null ? null : json["saleability"],
        buyLink: json["buyLink"] == null ? null : json["buyLink"],
        listPrice: json["listPrice"] == null
            ? null
            : SaleInfoListPrice.fromJson(json["listPrice"]),
        retailPrice: json["retailPrice"] == null
            ? null
            : SaleInfoListPrice.fromJson(json["retailPrice"]),
      );

  Map<String, dynamic> toJson() => {
        "country": country == null ? null : country,
        "saleability": saleability == null ? null : saleability,
        "buyLink": buyLink == null ? null : buyLink,
        "isEbook": isEbook == null ? null : isEbook,
        "listPrice": listPrice == null ? null : listPrice,
        "listPrice": listPrice == null ? null : listPrice!.toJson(),
        "retailPrice": retailPrice == null ? null : retailPrice!.toJson(),
      };
}

class SaleInfoListPrice {
  SaleInfoListPrice({
    required this.amount,
    required this.currencyCode,
  });

  double amount;
  String currencyCode;

  factory SaleInfoListPrice.fromJson(Map<String, dynamic> json) =>
      SaleInfoListPrice(
        amount: json["amount"] == null ? null : json["amount"].toDouble(),
        currencyCode:
            json["currencyCode"] == null ? null : json["currencyCode"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "currencyCode": currencyCode == null ? null : currencyCode,
      };
}

class VolumeInfo {
  VolumeInfo({
    this.title,
    this.authors,
    this.publishedDate,
    this.industryIdentifiers,
    this.readingModes,
    this.pageCount,
    this.okunduMu,
    this.addedDate,
    this.printType,
    this.categories,
    this.description,
    this.maturityRating,
    this.allowAnonLogging,
    this.contentVersion,
    this.imageLinks,
    this.language,
    this.previewLink,
    this.infoLink,
    this.canonicalVolumeLink,
  });

  String? title;
  List<String>? authors;
  String? publishedDate;
  List<IndustryIdentifier>? industryIdentifiers;
  ReadingModes? readingModes;
  int? pageCount;
  bool? okunduMu;
  DateTime? addedDate;
  String? printType;
  List<String>? categories;
  String? description;
  String? maturityRating;
  bool? allowAnonLogging;
  String? contentVersion;
  ImageLinks? imageLinks;
  String? language;
  String? previewLink;
  String? infoLink;
  String? canonicalVolumeLink;

  factory VolumeInfo.fromJson(Map<String, dynamic> json) => VolumeInfo(
        title: json["title"] == null ? null : json["title"],
        authors: json["authors"] == null
            ? null
            : List<String>.from(json["authors"].map((x) => x)),
        publishedDate:
            json["publishedDate"] == null ? null : json["publishedDate"],
        industryIdentifiers: json["industryIdentifiers"] == null
            ? null
            : List<IndustryIdentifier>.from(json["industryIdentifiers"]
                .map((x) => IndustryIdentifier.fromJson(x))),
        readingModes: json["readingModes"] == null
            ? null
            : ReadingModes.fromJson(json["readingModes"]),
        pageCount: json["pageCount"] == null ? null : json["pageCount"],
        okunduMu: json["okunduMu"] == null ? null : json["okunduMu"],
        addedDate: json["addedDate"] == null ? null : DateTime.now(),
        printType: json["printType"] == null ? null : json["printType"],
        categories: json["categories"] == null
            ? null
            : List<String>.from(json["categories"].map((x) => x)),
        description: json["description"] == null ? null : json["description"],
        maturityRating:
            json["maturityRating"] == null ? null : json["maturityRating"],
        allowAnonLogging:
            json["allowAnonLogging"] == null ? null : json["allowAnonLogging"],
        contentVersion:
            json["contentVersion"] == null ? null : json["contentVersion"],
        imageLinks: json["imageLinks"] == null
            ? null
            : ImageLinks.fromJson(json["imageLinks"]),
        language: json["language"] == null ? null : json["language"],
        previewLink: json["previewLink"] == null ? null : json["previewLink"],
        infoLink: json["infoLink"] == null ? null : json["infoLink"],
        canonicalVolumeLink: json["canonicalVolumeLink"] == null
            ? null
            : json["canonicalVolumeLink"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "authors":
            authors == null ? null : List<dynamic>.from(authors!.map((x) => x)),
        "publishedDate": publishedDate == null ? null : publishedDate,
        "industryIdentifiers": industryIdentifiers == null
            ? null
            : List<dynamic>.from(industryIdentifiers!.map((x) => x.toJson())),
        "readingModes": readingModes == null ? null : readingModes!.toJson(),
        "pageCount": pageCount == null ? null : pageCount,
        "okunduMu": okunduMu == null ? false : okunduMu,
        "addedDate": addedDate == null ? null : DateTime.now(),
        "description": description == null ? null : description,
        "printType": printType == null ? null : printType,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x)),
        "maturityRating": maturityRating == null ? null : maturityRating,
        "allowAnonLogging": allowAnonLogging == null ? null : allowAnonLogging,
        "contentVersion": contentVersion == null ? null : contentVersion,
        "imageLinks": imageLinks == null ? null : imageLinks!.toJson(),
        "language": language == null ? null : language,
        "previewLink": previewLink == null ? null : previewLink,
        "infoLink": infoLink == null ? null : infoLink,
        "canonicalVolumeLink":
            canonicalVolumeLink == null ? null : canonicalVolumeLink,
      };
}

class ImageLinks {
  ImageLinks({
    this.smallThumbnail,
    this.thumbnail,
  });

  String? smallThumbnail;
  String? thumbnail;

  factory ImageLinks.fromJson(Map<String, dynamic> json) => ImageLinks(
        smallThumbnail:
            json["smallThumbnail"] == null ? null : json["smallThumbnail"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "smallThumbnail": smallThumbnail == null ? null : smallThumbnail,
        "thumbnail": thumbnail == null ? null : thumbnail,
      };
}

class IndustryIdentifier {
  IndustryIdentifier({
    this.type,
    this.identifier,
  });

  String? type;
  String? identifier;

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) =>
      IndustryIdentifier(
        type: json["type"] == null ? null : json["type"],
        identifier: json["identifier"] == null ? null : json["identifier"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "identifier": identifier == null ? null : identifier,
      };
}

class ReadingModes {
  ReadingModes({
    this.text,
    this.image,
  });

  bool? text;
  bool? image;

  factory ReadingModes.fromJson(Map<String, dynamic> json) => ReadingModes(
        text: json["text"] == null ? null : json["text"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "text": text == null ? null : text,
        "image": image == null ? null : image,
      };
}
