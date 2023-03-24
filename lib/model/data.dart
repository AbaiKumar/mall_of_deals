// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, avoid_init_to_null
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Data with ChangeNotifier {
  //default variables
  dynamic phone = null, type = null, prefs = null, name = "";
  int cost = 0, total = 0;
  late FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Function stc;

  Data() {
    //constructor to initialize object
    () async {
      prefs = await SharedPreferences.getInstance(); //cookie
      phone = prefs.getString('phone');
      type = prefs.getString('type');
      name = prefs.getString('name');
      if (type != null) {
        getUsrData();
      }
      notifyListeners();
    }();
  }

  void trigger(phone, type, name) {
    this.phone = phone;
    this.type = type;
    this.name = name;
    getUsrData().whenComplete(() {
      notifyListeners();
    });
    notifyListeners();
  }

  Future getUsrData() async {
    prefs = await SharedPreferences.getInstance(); //cookie
    phone = prefs.getString('phone');
    if (phone == null) {
      return;
    }
    final url =
        "https://abai-194101.000webhostapp.com/mall_of_deals/usrdata.php?phone=$phone";
    var response = await http.get(Uri.parse(url));
    if (response.body == "No") {
      notifyListeners();
      return;
    }
    name = response.body.toString();
    notifyListeners();
  }

  Future<void> sendNotification(
      String msg, String reason, String msgToken) async {
    //notificatin sending function by http
    String url = "https://fcm.googleapis.com/fcm/send";
    try {
      await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "to": msgToken,
            "notification": {
              "title": msg,
              "body": reason,
              "mutable_content": true,
              "sound": "Tri-tone",
              "priority": "high"
            },
          },
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAXlCJp9Y:APA91bHYQeCVV877tPzjOjWHCkQe_qA-k-BbDL1hyB9wKYW1aRMfcsTwe2Faxbw51y_qJkN3Ao6EiYFDvQjm_MDL10ryeZvuMooXZDGEZPWtu67eYQ6ykZwphncsdHZpiJ7PISNWFBg0",
        },
      );
    } catch (e) {
      //none
    }
  }

  void clear() async {
    //logout
    // Remove cokie data...
    prefs.clear();
    name = null;
    phone = null;
    type = null;
    stc();
    notifyListeners();
  }

  Future<void> getDataOrders() async {
    var prefs = await SharedPreferences.getInstance(); //cookie
    total = 0;
    cost = 0;
    var val = await firestore
        .collection("Seller")
        .doc(
          prefs.getString('phone'),
        )
        .get();
    var d = val.data() ?? {};
    List t = d["order"];
    for (var i in t) {
      var value = await i.get();
      var y = value.data();
      if (y["deliver"] == 1) {
        total += 1;
        int p = int.parse(y["price"]);
        int p1 = int.parse(y["quantity_req"]);
        cost += (p * p1);
      }
    }
  }

  notifyListeners();
}
