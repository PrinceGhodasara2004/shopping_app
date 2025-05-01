// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/services/databse.dart';
import 'package:shopping_app/widgets/support_widget.dart';

class AdminAllOrdersScreen extends StatefulWidget {
  const AdminAllOrdersScreen({super.key});

  @override
  State<AdminAllOrdersScreen> createState() => _AdminAllOrdersScreenState();
}

class _AdminAllOrdersScreenState extends State<AdminAllOrdersScreen> {
  Stream? orderStream;

  getAllOrders() async {
    orderStream = await DatabseMethods().allOrders();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllOrders();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                return documentSnapshot["Tracker"] == 3
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Material(
                        elevation: 4,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          SupportWidget.adminTextFeildColor(),
                                    ),
                                    child: Image.network(
                                      documentSnapshot["ProductImage"],
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            documentSnapshot["ProductName"],
                                            style:
                                                SupportWidget.itemNameTextStyle(),
                                            textScaler: TextScaler.linear(0.80),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "\$" +
                                                    documentSnapshot["ProductPrice"],
                                                style:
                                                    SupportWidget.redclrText(),
                                                textScaler: TextScaler.linear(
                                                  1.25,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Name : " + documentSnapshot["UserName"],
                                style: SupportWidget.semiBoldTextStyle(),
                                textScaler: TextScaler.linear(0.80),
                              ),

                              Text(
                                "Email : " + documentSnapshot["UserEmail"],
                                style: SupportWidget.lightTextStyle(),
                                textScaler: TextScaler.linear(1),
                              ),

                              Text(
                                "Phone Number : " +
                                    documentSnapshot["PhoneNumber"],
                                style: SupportWidget.lightTextStyle(),
                                textScaler: TextScaler.linear(1),
                              ),

                              Text(
                                "Address : " + documentSnapshot["UserAddress"],
                                style: SupportWidget.lightTextStyle(),
                                textScaler: TextScaler.linear(1),
                              ),

                              SizedBox(height: 20),
                              documentSnapshot["Tracker"] >= 1
                                  ? Center(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width:
                                          MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Order Packed",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        minimumSize: WidgetStatePropertyAll(
                                          Size(130, 40),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.red[300],
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (documentSnapshot["Tracker"] == 0) {
                                          int updatedTracker =
                                              documentSnapshot["Tracker"];
                                          updatedTracker = updatedTracker + 1;
                                          await DatabseMethods()
                                              .updateAdminTracker(
                                                documentSnapshot.id,
                                                updatedTracker,
                                              );
                                          await DatabseMethods()
                                              .updateUserTracker(
                                                documentSnapshot["UserId"],
                                                updatedTracker,
                                                documentSnapshot["OrderId"],
                                              );
                                        }
                                      },
                                      child: Text(
                                        "Order Packed",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),

                              SizedBox(height: 10),
                              documentSnapshot["Tracker"] >= 2
                                  ? Center(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width:
                                          MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Order Shipped",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        minimumSize: WidgetStatePropertyAll(
                                          Size(130, 40),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.red[300],
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (documentSnapshot["Tracker"] == 1) {
                                          int updatedTracker =
                                              documentSnapshot["Tracker"];
                                          updatedTracker = updatedTracker + 1;
                                          await DatabseMethods()
                                              .updateAdminTracker(
                                                documentSnapshot.id,
                                                updatedTracker,
                                              );
                                          await DatabseMethods()
                                              .updateUserTracker(
                                                documentSnapshot["UserId"],
                                                updatedTracker,
                                                documentSnapshot["OrderId"],
                                              );
                                        }
                                      },
                                      child: Text(
                                        "Order Shipped",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),

                              SizedBox(height: 10),
                              documentSnapshot["Tracker"] >= 3
                                  ? Center(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width:
                                          MediaQuery.of(context).size.width /
                                          1.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Order Delivered",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : Center(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        minimumSize: WidgetStatePropertyAll(
                                          Size(130, 40),
                                        ),
                                        shape: WidgetStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        backgroundColor: WidgetStatePropertyAll(
                                          Colors.red[300],
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (documentSnapshot["Tracker"] == 2) {
                                          int updatedTracker =
                                              documentSnapshot["Tracker"];
                                          updatedTracker = updatedTracker + 1;
                                          await DatabseMethods()
                                              .updateAdminTracker(
                                                documentSnapshot.id,
                                                updatedTracker,
                                              );
                                          await DatabseMethods()
                                              .updateUserTracker(
                                                documentSnapshot["UserId"],
                                                updatedTracker,
                                                documentSnapshot["OrderId"],
                                              );
                                        }
                                      },
                                      child: Text(
                                        "Order Delivered",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    );
              },
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 2.5),
                Text(
                  "No Orders Yet!",
                  style: SupportWidget.lightTextStyle(),
                  textScaler: TextScaler.linear(1.5),
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
        title: Text("All Orders", style: SupportWidget.semiBoldTextStyle()),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),
      body: allOrders(),
    );
  }
}
