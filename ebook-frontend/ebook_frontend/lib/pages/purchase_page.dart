import 'dart:convert';

import 'package:ebook_frontend/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_credit_card/credit_card_form.dart';
import '../constants/colorconstants.dart';
import '../storage/storage.dart';
import 'home_page.dart';

class PurchasePage extends StatefulWidget {
  final String bookUUID;
  final double bookPrice;

  const PurchasePage({
    Key? key,
    required this.bookUUID,
    required this.bookPrice,
  }) : super(key: key);
  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
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
          'Checkout',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                ),
            Expanded(
              child: SingleChildScrollView(
                  child: CreditCardForm(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                onCreditCardModelChange: onCreditCardModelChange,
                themeColor: Colors.blue,
                formKey: formKey, // if you have a GlobalKey<FormState>
                cardNumberDecoration: const InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                expiryDateDecoration: const InputDecoration(
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                cvvCodeDecoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: 'XXX',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                cardHolderDecoration: const InputDecoration(
                  labelText: 'Card Holder',
                ),
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  MyButton(
                    onTap: _validateAndSubmit,
                    text: 'Buy Now',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // This will space out the children across the row's main axis.
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(fontSize: 17),
                        ), // Text at the beginning of the row
                        Text('\$${widget.bookPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight
                                    .bold)), // Text at the end of the row showing the price with 2 decimal places
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit() async {
    if (_isValidCard()) {
      SecureStorage userLibraryApiStorage = SecureStorage();
      var jwtToken = await userLibraryApiStorage.readSecureData('jwt');
      print(widget.bookUUID);
      print(widget.bookPrice);
      print('${dotenv.env['DB_URL']}/api/purchase');
      var response = await http.post(
        Uri.parse('${dotenv.env['DB_URL']}/api/purchase'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: json
            .encode({'bookUUID': widget.bookUUID, 'price': widget.bookPrice}),
      );

      print(response.statusCode);
      if (response.statusCode == 201) {
        _showSuccessDialog('You have successfully completed your purchase');
      } else {
        _showErrorDialog('An error occurred');
      }
    } else {
      // Show an error message
    }
  }

  bool _isValidCard() {
    // Check if card number is empty
    if (cardNumber.isEmpty) {
      _showErrorDialog('Card number cannot be empty.');
      return false;
    }

    // Check if expiry date is in the correct format MM/YY
    RegExp expDateRegExp = RegExp(r"^(0[1-9]|1[0-2])\/?([0-9]{2})$");
    if (!expDateRegExp.hasMatch(expiryDate)) {
      _showErrorDialog('Expiry date is not in valid format.');
      return false;
    }

    // Check if the card holder's name is not empty
    if (cardHolderName.isEmpty) {
      _showErrorDialog('Card holder name cannot be empty.');
      return false;
    }

    // Check if the CVV is 3 digits
    if (cvvCode.length != 3) {
      _showErrorDialog('CVV must be 3 digits.');
      return false;
    }

    // If all checks passed, the card is considered valid
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Input'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    ).then((_) {
      // This block runs after the dialog is dismissed.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        ModalRoute.withName('/'), // Assuming HomePage is the root route
      );
    });
  }
}
