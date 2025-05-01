// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shopping_app/screens/add_user_details.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  String name, details, price, image;

  ProductDetailScreen({
    super.key,
    required this.name,
    required this.details,
    required this.price,
    required this.image,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportWidget.bgColor(),

      //Product Buy Button
      bottomNavigationBar: Material(
        color: Colors.white,
        child: Card(
          color: SupportWidget.bgColor(),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$" + widget.price,
                  style: SupportWidget.redclrText(),
                  textScaler: TextScaler.linear(1.2),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.red[300]),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AddUserDetailsScreen(
                              name: widget.name,
                              details: widget.details,
                              image: widget.image,
                              price: widget.price,
                            ),
                      ),
                    );
                  },
                  child: Text("Buy Now", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(left: 20),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Icon(Icons.arrow_back_outlined),
              ),
            ),

            // Product Image
            Center(
              child: Hero(
                tag: Key(widget.image.toString()),
                child: Image.network(widget.image, height: 250),
              ),
            ),

            SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                width: MediaQuery.of(context).size.width,

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),

                      // Product Name
                      Center(
                        child: Text(
                          widget.name,
                          style: SupportWidget.semiBoldTextStyle(),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Product Details
                      Text("Details", style: SupportWidget.semiBoldTextStyle()),
                      SizedBox(height: 5),
                      Text(widget.details),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
