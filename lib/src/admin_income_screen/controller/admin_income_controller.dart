import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/payments_model.dart';

class AdminIncomeController extends GetxController {
  RxList<Payments> incomeList = <Payments>[].obs;
  RxList<Payments> incomeMasterList = <Payments>[].obs;
  RxDouble income = 0.0.obs;
  RxList<String> subscriptionList =
      <String>['All', 'Bronze', 'Silver', 'Gold'].obs;
  RxString selectedSubscriptionType = 'All'.obs;
  TextEditingController search = TextEditingController();
  Timer? debouncer;

  getPayments() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('payments')
          .orderBy('datecreated', descending: true)
          .get();
      var categories = res.docs;
      List tempdata = [];
      double totalIncome = 0.0;
      for (var i = 0; i < categories.length; i++) {
        Map mapdata = categories[i].data();
        mapdata['id'] = categories[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        totalIncome = totalIncome + double.parse(mapdata['amount'].toString());
        var userdetails = await FirebaseFirestore.instance
            .collection('users')
            .doc(mapdata['user'])
            .get();
        if (userdetails.exists) {
          mapdata['image'] = userdetails.get('profilePhoto');
          mapdata['name'] = userdetails.get('name');
          mapdata['email'] = userdetails.get('email');
          mapdata['contactno'] = userdetails.get('contactno');
        } else {
          mapdata['image'] =
              "https://firebasestorage.googleapis.com/v0/b/media-tooker-7ec79.appspot.com/o/profilenew.jpg?alt=media&token=ea1b3a49-f2fe-4885-ae1d-5f500f699967";
          mapdata['name'] = "Unkown";
          mapdata['email'] = "Unkown";
          mapdata['contactno'] = "Unkown";
        }
        tempdata.add(mapdata);
      }
      income.value = totalIncome;
      incomeList.assignAll(paymentsFromJson(jsonEncode(tempdata)));
      incomeMasterList.assignAll(paymentsFromJson(jsonEncode(tempdata)));
    } catch (e) {
      log("ERROR: (getPayments) Something went wrong.");
    }
  }

  String formatCurrency(double amount) {
    final format = NumberFormat.currency(symbol: "₱ ", decimalDigits: 2);
    return format.format(amount);
  }

  searchFunction({required String keyword}) async {
    incomeList.clear();
    if (selectedSubscriptionType.value == "All") {
      log("all ang selected category");
      if (keyword.isEmpty) {
        incomeList.assignAll(incomeMasterList);
      } else {
        for (var i = 0; i < incomeMasterList.length; i++) {
          if (incomeMasterList[i]
              .name
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString())) {
            incomeList.add(incomeMasterList[i]);
          }
        }
      }
    } else {
      log("dli all ang selected category");
      for (var i = 0; i < incomeMasterList.length; i++) {
        if (keyword.isEmpty) {
          log("dre 1");
          if (incomeMasterList[i].subscriptionType ==
              selectedSubscriptionType.value) {
            incomeList.add(incomeMasterList[i]);
          }
        } else {
          log("dre 2");
          if (incomeMasterList[i]
                  .name
                  .toLowerCase()
                  .toString()
                  .contains(keyword.toLowerCase().toString()) &&
              incomeMasterList[i].subscriptionType ==
                  selectedSubscriptionType.value) {
            incomeList.add(incomeMasterList[i]);
          }
        }
      }
    }
  }

  @override
  void onInit() {
    getPayments();
    super.onInit();
  }
}
