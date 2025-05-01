import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/home.dart';
import 'package:shopping_app/screens/order.dart';
import 'package:shopping_app/screens/profile.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late List<Widget> pages;

  late HomeScreen homeScreen;
  late OrderScreen orderScreen;
  late ProfileScreen profileScreen;

  int currIndex = 0;

  @override
  void initState() {
    super.initState();

    homeScreen = HomeScreen();
    orderScreen = OrderScreen();
    profileScreen = ProfileScreen();

    pages = [homeScreen, orderScreen, profileScreen];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: SupportWidget.bgColor(),
        color: Colors.black45,
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.decelerate,
        onTap: (int index) async {
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
          setState(() {
            currIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.person_4, color: Colors.white),
        ],
      ),
      body: pages[currIndex],
    );
  }
}
