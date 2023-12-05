import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void signUserUpApi(email, password) async {
  try {
    var response = await http.post(
        Uri.parse('http://10.0.2.2:1337/api/auth/local/register'),
        headers: {
          'Content-Type': 'application/json', // Set the content type to JSON
          'Accept':
              'application/json', // Specify that you expect JSON in the response
        },
        body:
            jsonEncode({"username": email, "email": email, "password": email}));
    print('The response is${response.body}');
  } catch (e) {
    print('Failed to register: $e');
  }
  ;
}
