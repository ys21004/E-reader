import 'dart:convert';

import 'package:ebook_frontend/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../constants/defaults.dart';

Future<dynamic> userLibrary() async {
  List myLibrary = [];
  Response response;
  SecureStorage userLibraryApiStorage = SecureStorage();
  var responseJSON;
  var jwtToken = await userLibraryApiStorage.readSecureData('jwt');
  // print(jwtToken);
  try {
    response = await http.get(
      Uri.parse(
          '${dotenv.env['DB_URL']}/api/users/me?populate=books.book_cover'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      responseJSON = json.decode(response.body);
      // print(responseJSON);
      // print(jwtToken);
      if (responseJSON['books'].length == 0) {
        return null;
      }
      myLibrary = List.from(responseJSON['books'].map((book) {
        print('The price is ${dotenv.env['DB_URL']}${book['price']}');

        return {
          'id': book['id'],
          'title': book['title'],
          'author': book['author'],
          'imageurl':
              '${dotenv.env['DB_URL']}${book['book_cover']['formats']['thumbnail']['url']}',
          'date_published': book['date_published'],
          'description': book['description'],
          'bookuuid': book['bookuuid'],
          'price': book['price'].toDouble()
        };
      }).toList());

      print('Success, the user My Library function worked correctly');
    } else {
      print('Failed to retrieve books. Status code: ${response.statusCode}');
    }

    return myLibrary;
  } catch (e) {
    print('Failed to retrieve books: $e');
    return myLibrary;
  }
}

Future<dynamic> retrieveBookPDF(bookUUID) async {
  Response response;
  SecureStorage userLibraryApiStorage = SecureStorage();
  var responseJSON;

  var jwtToken = await userLibraryApiStorage.readSecureData('jwt');

  try {
    response = await http.get(
      Uri.parse('${dotenv.env['DB_URL']}/api/book-contents/${bookUUID}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      responseJSON = json.decode(response.body);
      print(responseJSON[0]['content'][0]['url']);
      var pdfURL =
          '${dotenv.env['DB_URL']}${responseJSON[0]['content'][0]['url']}';
      return pdfURL;
    }
  } catch (e) {
    print('Failed to retrieve book content: $e');
  }
}

// load newest
Future<List<dynamic>> loadNewest([int page_number = 1]) async {
  List newestLibrary = [];
  Response response;
  SecureStorage userLibraryApiStorage = SecureStorage();

  var responseJSON;

  var jwtToken = await userLibraryApiStorage.readSecureData('jwt');
  try {
    // print(
    //     '${dotenv.env['DB_URL']}/api/books?populate=*&pagination[page]=${page_number}&pagination[pageSize]=${numberofbookspersection}&sort[0]=date_added:desc');
    response = await http.get(
      Uri.parse(
          '${dotenv.env['DB_URL']}/api/books?populate=*&pagination[page]=${page_number}&pagination[pageSize]=${numberofbookspersection}&sort[0]=date_added:desc'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      responseJSON = json.decode(response.body);
      // print('This is the newest library${responseJSON['data']}');
      newestLibrary = List.from(responseJSON['data'].map((book) {
        // print(
        //     '${dotenv.env['DB_URL']}${book['attributes']['book_cover']['data']['attributes']['formats']['thumbnail']['url']}');
        return {
          'id': book['id'],
          'title': book['attributes']['title'],
          'author': book['attributes']['author'],
          'imageurl':
              '${dotenv.env['DB_URL']}${book['attributes']['book_cover']['data']['attributes']['formats']['thumbnail']['url']}',
          'date_published': book['attributes']['date_published'],
          'description': book['attributes']['description'],
          'bookuuid': book['attributes']['bookuuid'],
          'price': book['attributes']['price'].toDouble()
        };
      }).toList());

      print('Success, the newest Library function worked correctly');
    } else {
      print(
          'Failed to retrieve newest books. Status code: ${response.statusCode}');
    }
    return newestLibrary;
  } catch (e) {
    print('Failed to retrieve books: $e');
    return newestLibrary;
  }
}

////////////////////////////////////////////////////This has to be changed/////////////////////////////////////////////////////////////////
Future<List<dynamic>> loadBestSellers([int page_number = 1]) async {
  List newestLibrary = [];
  Response response;
  SecureStorage userLibraryApiStorage = SecureStorage();

  var responseJSON;

  var jwtToken = await userLibraryApiStorage.readSecureData('jwt');
  try {
    print(
        '${dotenv.env['DB_URL']}/api/books?populate=*&pagination[page]=${page_number}&pagination[pageSize]=${numberofbookspersection}&sort[0]=date_added:desc');
    response = await http.get(
      Uri.parse(
          '${dotenv.env['DB_URL']}/api/books?populate=*&pagination[page]=${page_number}&pagination[pageSize]=${numberofbookspersection}&sort[0]=date_added:asc'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      responseJSON = json.decode(response.body);
      // print(responseJSON['data']);
      newestLibrary = List.from(responseJSON['data'].map((book) {
        return {
          'id': book['id'],
          'title': book['attributes']['title'],
          'author': book['attributes']['author'],
          'imageurl':
              '${dotenv.env['DB_URL']}${book['attributes']['book_cover']['data']['attributes']['formats']['thumbnail']['url']}',
          'date_published': book['attributes']['date_published'],
          'bookuuid': book['attributes']['bookuuid'],
          'price': book['attributes']['price'].toDouble()
        };
      }).toList());

      print('Success, the newest Library function worked correctly');
    } else {
      print('Failed to retrieve books. Status code: ${response.statusCode}');
    }
    print(newestLibrary);
    return newestLibrary;
  } catch (e) {
    print('Failed to retrieve books: $e');
    return newestLibrary;
  }
}

////////////////////////////////////////////////////This has to be changed/////////////////////////////////////////////////////////////////
Future<List<dynamic>> loadTopRated([int page_number = 1]) async {
  List newestLibrary = [];
  Response response;
  SecureStorage userLibraryApiStorage = SecureStorage();

  var responseJSON;

  var jwtToken = await userLibraryApiStorage.readSecureData('jwt');
  try {
    print(
        '${dotenv.env['DB_URL']}/api/books?populate=*&pagination[page]=${page_number}&pagination[pageSize]=${numberofbookspersection}&sort[0]=date_added:desc');
    response = await http.get(
      Uri.parse(
          '${dotenv.env['DB_URL']}/api/books?populate=*&pagination[page]=${page_number}&pagination[pageSize]=${numberofbookspersection}&sort[0]=date_added:desc'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      responseJSON = json.decode(response.body);
      // print(responseJSON['data']);
      newestLibrary = List.from(responseJSON['data'].map((book) {
        return {
          'id': book['id'],
          'title': book['attributes']['title'],
          'author': book['attributes']['author'],
          'imageurl':
              '${dotenv.env['DB_URL']}${book['attributes']['book_cover']['data']['attributes']['formats']['thumbnail']['url']}',
          'date_published': book['attributes']['date_published'],
          'bookuuid': book['attributes']['bookuuid'],
          'price': book['attributes']['price'].toDouble()
        };
      }).toList());

      print('Success, the newest Library function worked correctly');
    } else {
      print('Failed to retrieve books. Status code: ${response.statusCode}');
    }
    print(newestLibrary);
    return newestLibrary;
  } catch (e) {
    print('Failed to retrieve books: $e');
    return newestLibrary;
  }
}

void loadSearch(search_value) {
  print('Inside the load Search function executing for value ${search_value}');
}

void signUserUpApi(email, password) async {
  try {
    var response = await http.post(
        Uri.parse('${dotenv.env['DB_URL']}/api/auth/local/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body:
            jsonEncode({"username": email, "email": email, "password": email}));
    print('The response is${response.body}');
  } catch (e) {
    print('Failed to register: $e');
  }
  ;
}
