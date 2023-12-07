import 'package:ebook_frontend/components/my_button.dart';
import 'package:ebook_frontend/constants/defaults.dart';
import 'package:ebook_frontend/pages/book_pdf.dart';
import 'package:ebook_frontend/pages/purchase_page.dart';
import 'package:flutter/material.dart';
import '../constants/colorconstants.dart';
import '../scripts/check_if_user_purchased.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../scripts/api_calls.dart';

class BookDetailsPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  bool _hasPurchased = false;

  @override
  void initState() {
    super.initState();
    _checkPurchaseStatus();
  }
  

  Future<void> _checkPurchaseStatus() async {
    // Simulate an API call to check purchase status
    bool result = await hasUserPurchasedBook(widget.book['id']);
    setState(() {
      _hasPurchased = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          widget.book['title'] ?? 'Book Details',
          style: defaultfont(
              textStyle: TextStyle(
            fontWeight: FontWeight.w600,
          )),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              AspectRatio(
                aspectRatio: 1 / 1.5, // Smaller image with a fixed aspect ratio
                child:
                    Image.network(widget.book['imageurl'], fit: BoxFit.cover),
              ),
              SizedBox(height: 16),
              Text(
                widget.book['title'],
                style: defaultfont(
                    textStyle:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              if (widget.book['author'] != null) ...[
                SizedBox(height: 8),
                Text(
                  'by ${widget.book['author']}',
                  style: defaultfont(
                      textStyle:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                ),
              ],
              if (widget.book['price'] != null) ...[
                SizedBox(height: 8),
                Text(
                  '\$ ${widget.book['price']}',
                  style: defaultfont(
                      textStyle:
                      TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: priceColor)),
                ),
              ],
              SizedBox(height: defaultspacing),
              MyButton(
                onTap: () {
                  if (_hasPurchased) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PDFViewerPage(bookUUID: widget.book['bookuuid'],bookTitle: widget.book['title'],)));
                  }
                    else {
                        // Initiate the purchase flow
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PurchasePage(bookUUID: widget.book['bookuuid'],bookPrice: widget.book['price'])));
                        }
                },
                text: (_hasPurchased ? 'Read' : 'Purchase'),
              ),
              SizedBox(height: defaultspacing),
              if (widget.book['description'] != null) ...[
                SizedBox(height: 16),
                Text(
                  widget.book['description'],
                  style: defaultfont(textStyle: TextStyle(fontSize: 16)),
                ),
              ],
              SizedBox(height: defaultspacing),
            ],
          ),
        ),
      ),
    );
  }
}
