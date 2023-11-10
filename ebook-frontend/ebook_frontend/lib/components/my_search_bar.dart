import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  final Function onSearch;

  MySearchBar({required this.onSearch});

  // Handler function that invokes the search operation
  void handleSearch() {
    print('you searched for ${_searchController.text}');
   onSearch(_searchController.text.toString());  
   }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjust the height as needed
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: "Search",
          // Use suffixIcon for the icon on the right
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.blue, // Choose your color here
            ),
            onPressed:handleSearch, // Attach the search handler to the button
          ),
          // Make the outline bolder by defining an OutlineInputBorder with a defined width
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2), // Bolder outline
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        onSubmitted: (value) => handleSearch(), // Use the search handler on submit
        style: TextStyle(
          fontSize: 14, // Adjust the font size here if necessary
        ),
      ),
    );
  }
}
