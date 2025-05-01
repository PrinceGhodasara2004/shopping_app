// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/category_products.dart';
import 'package:shopping_app/screens/product_detail.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];

  bool isLoading = false, search = false;

  List categories = [
    "images/headphones.png",
    "images/watch.png",
    "images/laptop.png",
    "images/smartphone.png",
    "images/tv.png",
    "images/airdopes.png",
    "images/speaker.png",
    "images/tablet.png",
    "images/earphones.png",
    "images/mouse.png",
  ];

  List categoryName = [
    "Headphone",
    "Watch",
    "Laptop",
    "Smart Phone",
    "Smart Television",
    "Airdopes",
    "Speakers",
    "Tablets",
    "Earphones",
    "Mouse",
  ];

  void searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
        isLoading = false;
        search = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      search = true;
    });

    List<Map<String, dynamic>> tempList = [];

    for (String collectionName in categoryName) {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String productName = (data['Name'] ?? '').toString();

        if (productName.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(data);
        }
      }
    }

    setState(() {
      searchResults = tempList;
      isLoading = false;
    });
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      searchResults.clear();
      search = false;
    });
  }

  String? name;

  getUserName() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportWidget.bgColor(),
      body:
          name == null
              ? Center(child: CircularProgressIndicator(color: Colors.red[400]))
              : Container(
                margin: EdgeInsets.only(
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hey, $name",
                          softWrap: true,
                          style: SupportWidget.boldTextStyle(),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "images/logo.png",
                            width: 50,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: Center(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) async {
                            if (value.trim().isNotEmpty) {
                              bool isOnline = await SupportWidget.hasInternet();
                              if (!isOnline) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        "No internet connection!",
                                        textScaler: TextScaler.linear(1.25),
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                            }
                            searchProducts(value.trim());
                            setState(() {});
                          },
                          cursorColor: Colors.black45,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Products",
                            hintStyle: TextStyle(
                              height: 2,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),

                            prefixIcon:
                                searchController.text.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(Icons.close_rounded),
                                      onPressed: () {
                                        clearSearch();
                                      },
                                    )
                                    : const Icon(Icons.search_rounded),
                          ),
                        ),
                      ),
                    ),

                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CircularProgressIndicator(
                          color: Colors.red[400],
                        ),
                      ),
                    if (!isLoading)
                      Expanded(
                        child:
                            search
                                ? ListView.builder(
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    var product = searchResults[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => ProductDetailScreen(
                                                  name: product["Name"],
                                                  details: product["Details"],
                                                  price: product["Price"],
                                                  image: product["Image"],
                                                ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                        margin: EdgeInsets.zero,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(8),
                                          leading:
                                              product['Image'] != null
                                                  ? Image.network(
                                                    product['Image'],
                                                    width: 60,
                                                    height: 60,
                                                  )
                                                  : const Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                          title: Text(
                                            product['Name'] ?? 'No Name',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 15),
                                    Text(
                                      "Categories",
                                      style: SupportWidget.semiBoldTextStyle(),
                                    ),
                                    SizedBox(height: 5),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: EdgeInsets.only(top: 5),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1,
                                              mainAxisSpacing: 8,
                                              crossAxisSpacing: 8,
                                            ),
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: categories.length,
                                        itemBuilder: (context, index) {
                                          return CategoryTile(
                                            image: categories[index],
                                            name: categoryName[index],
                                          );
                                        },
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
}

class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool isOnline = await SupportWidget.hasInternet();

        if (!isOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  "No internet connection!",
                  textScaler: TextScaler.linear(1.25),
                ),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return; // stop navigation
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(category: name),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Image.asset(image, height: 80, width: 120),
            SizedBox(height: MediaQuery.of(context).size.height * .009),
            Text(
              name,
              style: SupportWidget.itemNameTextStyle(),
              textScaler: TextScaler.linear(0.90),
            ),
            Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }
}
