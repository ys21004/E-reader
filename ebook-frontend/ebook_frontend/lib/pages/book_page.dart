import 'package:ebook_frontend/components/my_button.dart';
import 'package:ebook_frontend/constants/defaults.dart';
import 'package:flutter/material.dart';
import '../constants/colorconstants.dart';
import '../scripts/check_if_user_purchased.dart';

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
              SizedBox(height: defaultspacing),
              MyButton(
                onTap: () {
                  if (_hasPurchased) {
                    // Navigate to the reading screen
                  } else {
                    // Initiate the purchase flow
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
