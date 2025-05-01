// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/product_detail.dart';
import 'package:shopping_app/services/databse.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class CategoryProductsScreen extends StatefulWidget {
  String category;

  CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  Stream? categoryStream;

  getProducts() async {
    categoryStream = await DatabseMethods().getAllProducts(widget.category);
    setState(() {});
  }

  Widget allProducts() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProductDetailScreen(
                              name: documentSnapshot["Name"],
                              details: documentSnapshot["Details"],
                              price: documentSnapshot["Price"],
                              image: documentSnapshot["Image"],
                            ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          height: 100,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: SupportWidget.adminTextFeildColor(),
                          ),
                          child: Hero(
                            tag: Key(documentSnapshot["Image"].toString()),
                            child: Image.network(
                              documentSnapshot["Image"],
                              height: 120,
                              width: 80,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  documentSnapshot["Name"],
                                  style: SupportWidget.itemNameTextStyle(),
                                  textScaler: TextScaler.linear(0.80),
                                ),

                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$" + documentSnapshot["Price"],
                                      style: SupportWidget.redclrText(),
                                      textScaler: TextScaler.linear(1.1),
                                    ),
                                    Icon(
                                      Icons.add_box_rounded,
                                      color: Colors.red[300],
                                      size: 27,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
            : Center(child: CircularProgressIndicator(color: Colors.red[400]));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category, style: SupportWidget.semiBoldTextStyle()),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_outlined),
        ),
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),
      body: allProducts(),
    );
  }
}
