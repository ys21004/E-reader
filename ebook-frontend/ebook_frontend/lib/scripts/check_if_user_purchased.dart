import 'package:ebook_frontend/scripts/api_calls.dart';

Future<bool> hasUserPurchasedBook(book_id) async {
  var userlib = await userLibrary();
  // Ensure the list contains only the book ids and not sets
  List book_ids = userlib.map((book) => book['id']).toList();
  print('These are the book ids $book_ids');
  
  if (book_ids.contains(book_id)) {
    print('The user has the book with id $book_id');
    return true;
  } else {
    print('The user does not have the book with id $book_id');
    return false;
  }
}
