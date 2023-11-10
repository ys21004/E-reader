import 'package:ebook_frontend/scripts/api_calls.dart';

Future<bool> hasUserPurchasedBook(book_id) async {
  var userLibary = await userLibrary();
  List book_ids = List.from(userLibary.map((book) {
    print(book_id);
    return {
      book['id']
    };
  }));
  print('These are the book ids${book_ids}');
  if (book_ids.any((book_id)=>book_id == book_id)) {
    print('The user has the book with id${book_id}');

    return true;
  } else {
    print('The user does not have the book with id${book_id}');

    return false;
  }
}
