import 'dart:io';

import 'package:ebook_frontend/pages/book_page.dart';
import 'package:ebook_frontend/scripts/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:ebook_frontend/components/my_search_bar.dart';
import 'package:ebook_frontend/components/book_card.dart';
import 'package:ebook_frontend/components/category_button.dart';
import 'package:ebook_frontend/storage/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/colorconstants.dart';

class PDFViewerPage extends StatefulWidget {
  final String bookUUID;
  final String bookTitle;

  const PDFViewerPage(
      {Key? key, required this.bookUUID, required this.bookTitle})
      : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  bool isLoading = true;
  String localPath = '';

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  void loadPDF() async {
    try {
      var pdfUrl = await retrieveBookPDF(widget.bookUUID);
      await downloadFile(pdfUrl);
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/pdf_temp.pdf');

      await file.writeAsBytes(bytes, flush: true);

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print('Error downloading file: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          widget.bookTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localPath,
            ),
    );
  }
}
