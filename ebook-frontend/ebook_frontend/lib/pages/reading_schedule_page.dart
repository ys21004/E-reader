import 'package:flutter/material.dart';
import 'package:ebook_frontend/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ReadingSchedulePage extends StatefulWidget {
  List<ReadingEntry> readingEntries =
      []; // List to store reading schedule entries

  @override
  _ReadingSchedulePageState createState() => _ReadingSchedulePageState();
}

class _ReadingSchedulePageState extends State<ReadingSchedulePage> {
  void _showAddEntryDialog(BuildContext context) {
    String bookTitle = '';
    int currentPage = 0;
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    double reviewRating = 0.0; // New variable for rating
    String review = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Reading Entry'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Book Title'),
                  onChanged: (value) {
                    bookTitle = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Current Page'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    currentPage = int.tryParse(value) ?? 0;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Start Date'),
                  readOnly: true,
                  controller: TextEditingController(
                    text: startDate.toLocal().toString().split(' ')[0],
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != startDate) {
                      setState(() {
                        startDate = pickedDate;
                      });
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'End Date'),
                  readOnly: true,
                  controller: TextEditingController(
                    text: endDate.toLocal().toString().split(' ')[0],
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != endDate) {
                      setState(() {
                        endDate = pickedDate;
                      });
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Review'),
                  onChanged: (value) {
                    review = value;
                  },
                ),
                SmoothStarRating(
                  rating: reviewRating,
                  size: 30,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                  starCount: 5,
                  allowHalfRating: true,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add the new entry to the list
                widget.readingEntries.add(
                  ReadingEntry(
                    bookTitle: bookTitle,
                    currentPage: currentPage,
                    startDate: startDate,
                    endDate: endDate,
                    reviewRating: reviewRating,
                    review: review,
                  ),
                );
                // Close the dialog
                Navigator.pop(context);
                // Update the UI
                setState(() {});
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading Schedule'),
      ),
      body: ListView.builder(
        itemCount: widget.readingEntries.length,
        itemBuilder: (context, index) {
          return ReadingEntryCard(entry: widget.readingEntries[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEntryDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ReadingEntry {
  String bookTitle;
  int currentPage;
  DateTime startDate;
  DateTime endDate;
  double reviewRating; // New variable for rating
  String review;

  ReadingEntry({
    required this.bookTitle,
    required this.currentPage,
    required this.startDate,
    required this.endDate,
    required this.reviewRating,
    required this.review,
  });
}

class ReadingEntryCard extends StatelessWidget {
  final ReadingEntry entry;

  const ReadingEntryCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(entry.bookTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Page: ${entry.currentPage}'),
            Text('Start Date: ${entry.startDate.toString()}'),
            Text('End Date: ${entry.endDate.toString()}'),
            Text('Review: ${entry.review}'),
            SmoothStarRating(
              rating: entry.reviewRating,
              size: 30,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              color: Colors.amber,
              borderColor: Colors.amber,
              starCount: 5,
              allowHalfRating: true,
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // Implement logic to delete the reading entry
          },
        ),
      ),
    );
  }
}
