class MyBooksModel {
  String? bookTitle;
  List<String?>? bookAuthor;
  String? bookDescription;
  String? bookAddedDate = DateTime.now().toString();
  String? bookPublishDate;

  MyBooksModel(
      {this.bookTitle,
      this.bookAuthor,
      this.bookDescription,
      this.bookAddedDate,
      this.bookPublishDate});
}
