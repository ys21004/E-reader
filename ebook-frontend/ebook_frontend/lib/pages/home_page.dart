import 'package:ebook_frontend/pages/book_page.dart';
import 'package:flutter/material.dart';
import 'package:ebook_frontend/components/my_search_bar.dart';
import 'package:ebook_frontend/components/book_card.dart';
import 'package:ebook_frontend/components/category_button.dart';

import '../constants/bookcardconstants.dart';
import '../constants/colorconstants.dart';
import '../constants/defaults.dart';
import '../scripts/api_calls.dart';
import '../storage/storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> dynamicSectionFuture;
  SecureStorage userLibraryApiStorage = SecureStorage();
  @override
  void initState() {
    super.initState();
    dynamicSectionFuture =
        loadNewest(); // Set default future to load newest books
  }

  void updateDynamicSection(Future<dynamic> newFuture) {
    setState(() {
      dynamicSectionFuture = newFuture;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Home',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: Icon(Icons.menu, color: primaryColor), // Navigation Icon
        actions: [
          Icon(Icons.more_vert, color: primaryColor), // Three dot Icon
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: defaultspacing,
              ),
              MySearchBar(onSearch: (query) {
                // Implementation of the search functionality i.e loadSearch
              }),
              SizedBox(height: defaultspacing),
              Text(
                'My Library',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: defaultspacing),

              //Thios loads the user's own library
              Container(
                height: mybookcardtotalsize,
                child: FutureBuilder(
                  future: userLibrary(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        var userLibraryData = snapshot.data as List<dynamic>;
                        return Container(
                          height: mybookcardtotalsize,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: userLibraryData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookDetailsPage(
                                            book: userLibraryData[index],
                                          )),
                                ),
                                child: BookCard(
                                  textsize: mybookcardtextsize,
                                  cardheight: mybookcardheight,
                                  cardwidth: mybookcardwidth,
                                  title: userLibraryData[index]['title'],
                                  imageUrl: userLibraryData[index]['imageurl'],
                                  bookuuid: userLibraryData[index]['bookuuid'],
                                  price: userLibraryData[index]['price']
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.data == null) {
                        return Center(
                          child: Text(
                              'You currently do not have any books in your library\n\n Purchase books from the store\n\n Or upload your own.'),
                        );
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              SizedBox(height: defaultspacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryButton(
                    title: 'Newest',
                    onPressed: () => updateDynamicSection(loadNewest()),
                  ),
                  CategoryButton(
                    title: 'Bestsellers',
                    onPressed: () => updateDynamicSection(loadBestSellers()),
                  ),
                  CategoryButton(
                    title: 'Top Rated',
                    onPressed: () => updateDynamicSection(loadTopRated()),
                  ),
                ],
              ),
              SizedBox(height: defaultspacing),

              FutureBuilder<dynamic>(
                future: dynamicSectionFuture,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    var books = snapshot.data as List<dynamic>;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.65,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: books.length,
                      itemBuilder: (BuildContext context, int index) {
                        var book = books[index];
                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookDetailsPage(
                                      book: book,
                                    )),
                          ),
                          child: BookCard(
                            textsize: 12,
                            cardheight: 120,
                            cardwidth: 100,
                            title: book['title'],
                            imageUrl: book['imageurl'],
                            bookuuid: book['bookuuid'],
                            price: book['price']
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
