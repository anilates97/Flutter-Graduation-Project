import 'package:bitirme_proje/application/book_notifier.dart';
import 'package:bitirme_proje/model/booksModel/books.dart';
import 'package:bitirme_proje/repository/book_repository.dart';
import 'package:bitirme_proje/services/api_services.dart';
import 'package:riverpod/riverpod.dart';

APIBookServices bookServices = APIBookServices();

Future<List<BooksModel>> getBooks(String? book) async {
  return await bookServices.fetchBooks(book);
}

Future<BooksModel> getBookByID(String bookID) async {
  return await bookServices.fetchBookByID(bookID);
}

Future<List<BooksModel>> getBooksByCategory(String categoryName) async {
  return await bookServices.fetchBooksByCategory(categoryName);
}

/* Future<List<BooksModel>> getBooksWithKeyword() async {
  return await bookServices.getBooksWithKeyword();
} */

final getBooksProvider = FutureProvider.family<List<BooksModel>, String>(
    (ref, book) => getBooks(book));

final getBookByIDProvider =
    FutureProvider.family<BooksModel, String>(((ref, arg) {
  return getBookByID(arg); //arg => bookName + bookID
}));

/* final messagesFamily = FutureProvider.family<Message, String>((ref, id) async {
  return dio.get('http://my_api.dev/messages/$id');
}); */

/* final getBooksProviderWithKeyword =
    FutureProvider.family((ref, kitap) => getBooksWithKeyword());
 */

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => APIBookRepository(),
);

final bookNotifierProvider = StateNotifierProvider<BookNotifier, BookState>(
    (ref) => BookNotifier(ref.watch(bookRepositoryProvider)));

final getBookByCategory = FutureProvider.family(((ref, String categoryName) {
  return getBooksByCategory(categoryName);
}));

final getBooksByShelf = FutureProvider.family(((ref, String shelfName) {}));
