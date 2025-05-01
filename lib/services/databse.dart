// ignore_for_file: await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addAllProducts(Map<String, dynamic> addAllProducts) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .add(addAllProducts);
  }

  Future addProducts(
    Map<String, dynamic> addProductMap,
    String categoryName,
  ) async {
    return await FirebaseFirestore.instance
        .collection(categoryName)
        .add(addProductMap);
  }

  Future<Stream<QuerySnapshot>> getAllProducts(String category) async {
    return await FirebaseFirestore.instance.collection(category).snapshots();
  }

  Future orderDetails(Map<String, dynamic> orderInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .add(orderInfoMap);
  }

  Future userOrderDetails(
    Map<String, dynamic> userOrderInfoMap,
    String id,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("order")
        .doc(orderId)
        .set(userOrderInfoMap);
  }

  Future<Stream<QuerySnapshot>> getOrders(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("order")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getPastOrders(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("order")
        .where("Tracker", isEqualTo: 3)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> allOrders() async {
    return await FirebaseFirestore.instance.collection("Orders").snapshots();
  }

  Future updateAdminTracker(String id, int updatedTracker) async {
    return await FirebaseFirestore.instance.collection("Orders").doc(id).update(
      {"Tracker": updatedTracker},
    );
  }

  Future updateUserTracker(
    String id,
    int updatedTracker,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("order")
        .doc(orderId)
        .update({"Tracker": updatedTracker});
  }
}
