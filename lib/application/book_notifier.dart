import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:bitirme_proje/repository/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BookState {
  const BookState();
}

class BookInitial extends BookState {
  final List<BooksModel> books;
  const BookInitial(this.books);
}

class BookLoading extends BookState {
  const BookLoading();
}

class BookLoaded extends BookState {
  final List<BooksModel> books;
  const BookLoaded(this.books);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BookLoaded && o.books == books;
  }

  @override
  int get hashCode => books.hashCode;
}

class BookError extends BookState {
  final String message;
  const BookError(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is BookError && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class BookNotifier extends StateNotifier<BookState> {
  final BookRepository _bookRepository;

  BookNotifier(this._bookRepository) : super(const BookInitial([]));

  Future<void> getBooks(String bookName) async {
    try {
      state = BookLoading();
      final books = await _bookRepository.fetchBooks(bookName);
      state = BookLoaded(books);
    } catch (e) {
      state = BookError("Kitapları yüklerken hata meydana geldi");
    }
  }

  Future<void> getBooksByAuthor(String authorName) async {
    try {
      state = BookLoading();
      final books = await _bookRepository.fetchBooksByAuthor(authorName);
      state = BookLoaded(books);
    } catch (e) {
      state = BookError("Kitapları yüklerken hata meydana geldi");
    }
  }

  Future<void> fetchBooksByFreeBooks(String bookName) async {
    try {
      state = BookLoading();
      final books = await _bookRepository.fetchBooksByFreeBooks(bookName);
      state = BookLoaded(books);
    } catch (e) {
      state = BookError("Kitapları yüklerken hata meydana geldi");
    }
  }

  Future<void> fetchBooksByPaidBooks(String bookName) async {
    try {
      state = BookLoading();
      final books = await _bookRepository.fetchBooksByPaidBooks(bookName);
      state = BookLoaded(books);
    } catch (e) {
      state = BookError("Kitapları yüklerken hata meydana geldi");
    }
  }

  Future<void> fetchBookFullSearchedWord(String bookName) async {
    try {
      state = BookLoading();
      final books = await _bookRepository.fetchBookFullSearchedWord(bookName);
      state = BookLoaded(books);
    } catch (e) {
      state = BookError("Kitapları yüklerken hata meydana geldi");
    }
  }
}
