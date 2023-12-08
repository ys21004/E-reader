import 'package:ebook_frontend/pages/book_pdf.dart';
import 'package:ebook_frontend/pages/login_or_register.dart';
import 'package:ebook_frontend/pages/pdf_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'pages/home_page.dart';
import 'pages/purchase_page.dart';

void main() async {
  await dotenv.load(fileName: "lib/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: PdfUploadPage());
  }
}
