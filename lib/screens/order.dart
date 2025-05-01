// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/services/databse.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widgets/support_widget.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool current = true, past = false;

  String? id;
  Stream? currentOrderStream, pastOrderStream;
  getUserDataSP() async {
    id = await SharedPreferenceHelper().getUserId();
    currentOrderStream = await DatabseMethods().getOrders(id!);
    pastOrderStream = await DatabseMethods().getPastOrders(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDataSP();
  }

  Widget pastOrders() {
    return StreamBuilder(
      stream: pastOrderStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.red[400]),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No Orders Yet!",
              style: SupportWidget.lightTextStyle(),
              textScaler: TextScaler.linear(1.5),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Material(
                elevation: 4,
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: SupportWidget.adminTextFeildColor(),
                        ),
                        child: Image.network(
                          documentSnapshot["ProductImage"],
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                documentSnapshot["ProductName"],
                                style: SupportWidget.itemNameTextStyle(),
                                textScaler: TextScaler.linear(0.80),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$" + documentSnapshot["ProductPrice"],
                                    style: SupportWidget.redclrText(),
                                    textScaler: TextScaler.linear(1.25),
                                  ),
                                  Text(
                                    "Status : Delivered",
                                    style: SupportWidget.lightTextStyle(),
                                    textScaler: TextScaler.linear(1.25),
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
              ),
            );
          },
        );
      },
    );
  }

  Widget currentOrders() {
    return StreamBuilder(
      stream: currentOrderStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.red[400]),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No Orders Yet!",
              style: SupportWidget.lightTextStyle(),
              textScaler: TextScaler.linear(1.5),
            ),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
            int tracker = documentSnapshot["Tracker"];
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
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: SupportWidget.adminTextFeildColor(),
                                ),
                                child: Image.network(
                                  documentSnapshot["ProductImage"],
                                  height: 50,
                                  width: 50,
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
                                      Text(
                                        "\$" + documentSnapshot["ProductPrice"],
                                        style: SupportWidget.redclrText(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Image.asset(
                                "images/parcel.png",
                                height: 100,
                                width: 100,
                              ),
                              Expanded(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: Timeline.tileBuilder(
                                    builder: TimelineTileBuilder.connected(
                                      contentsAlign: ContentsAlign.alternating,
                                      connectionDirection:
                                          ConnectionDirection.before,
                                      itemCount: 4,
                                      contentsBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: 20,
                                            left: 5,
                                            right: 5,
                                          ),
                                          child: Text(
                                            _getStatusText(index),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },

                                      indicatorBuilder: (context, index) {
                                        if (index <= tracker) {
                                          return DotIndicator(
                                            color: Colors.lightGreen,
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          );
                                        } else {
                                          return OutlinedDotIndicator(
                                            borderWidth: 3,
                                            size: 25,
                                          );
                                        }
                                      },
                                      connectorBuilder: (context, index, type) {
                                        return SolidLineConnector(
                                          color:
                                              index < tracker
                                                  ? Colors.lightGreen
                                                  : Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
          },
        );
      },
    );
  }

  String _getStatusText(int index) {
    switch (index) {
      case 0:
        return "Order Placed";
      case 1:
        return "Packed";
      case 2:
        return "Shipped";
      case 3:
        return "Delivered";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: SupportWidget.bgColor(),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Current Orders Button
                current
                    ? Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black54, width: 2),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "images/currentorder3.png",
                              height: 130,
                              width: 130,
                            ),
                            Text(
                              "Current Orders",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () async {
                        current = true;
                        past = false;
                        currentOrderStream = await DatabseMethods().getOrders(
                          id!,
                        );
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black54, width: 2),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "images/currentorder3.png",
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              "Current Orders",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                // Past Orders Button
                past
                    ? Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black54, width: 2),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "images/pastorders2.png",
                              height: 130,
                              width: 130,
                            ),
                            Text(
                              "Past Orders",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                    : GestureDetector(
                      onTap: () async {
                        current = false;
                        past = true;
                        pastOrderStream = await DatabseMethods().getPastOrders(
                          id!,
                        );
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black54, width: 2),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              "images/pastorders2.png",
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              "Past Orders",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(child: current ? currentOrders() : pastOrders()),
          ],
        ),
      ),
    );
  }
}
