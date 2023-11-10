// book_card.dart

import 'package:ebook_frontend/constants/bookcardconstants.dart';
import 'package:ebook_frontend/constants/colorconstants.dart';
import 'package:ebook_frontend/constants/defaults.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? author;
  final double? rating;
  final double cardwidth;
  final double cardheight;
  final double textsize;
  
  BookCard({
    required this.cardheight,
    required this.cardwidth,
    required this.imageUrl,
    required this.title,
    required this.textsize,
    this.author,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardwidth,
      child: Card(
        elevation: 0.1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: cardheight,
                width: cardwidth,  
                          ),
            ),
            SizedBox(height: mybookcardspace),
            Text(
              textAlign: TextAlign.center,
              title,
              style: defaultfont(textStyle: TextStyle(fontSize: textsize,fontWeight: FontWeight.bold)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (author != null) Text(author!),
            if (rating != null) Text('$rating/10'),
          ],
        ),
      ),
    );
  }
}
