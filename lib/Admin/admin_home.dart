import 'package:flutter/material.dart';
import 'package:shopping_app/Admin/add_product.dart';
import 'package:shopping_app/Admin/all_orders.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Home", style: SupportWidget.semiBoldTextStyle()),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddProductScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 30),
                  SizedBox(width: 10),
                  Text(
                    "Add Products",
                    style: SupportWidget.boldTextStyle(),
                    textScaler: TextScaler.linear(0.90),
                  ),
                ],
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminAllOrdersScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_rounded, size: 30),
                  SizedBox(width: 10),
                  Text(
                    "See All Orders",
                    style: SupportWidget.boldTextStyle(),
                    textScaler: TextScaler.linear(0.90),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
