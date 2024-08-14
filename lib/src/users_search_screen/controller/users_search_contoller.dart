import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/loading_dialog.dart';

import '../../../model/user_model.dart';

class UserSearchController extends GetxController {
  TextEditingController search = TextEditingController();
  RxList<User> usersList = <User>[].obs;
  RxList<User> usersMasterList = <User>[].obs;
  Timer? debouncer;
  RxList<String> categoriesList = <String>[].obs;
  RxString selectedCategory = 'All'.obs;

  getUsers() async {
    try {
      var res = await FirebaseFirestore.instance.collection('users').get();
      var users = res.docs;
      List data = [];
      for (var i = 0; i < users.length; i++) {
        Map mapdata = users[i].data();
        mapdata['id'] = users[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        var resrating = await FirebaseFirestore.instance
            .collection('users')
            .doc(users[i].id)
            .collection('ratings')
            .get();
        if (resrating.docs.isNotEmpty) {
          var ratings = resrating.docs;
          double total = 0.0;
          for (var i = 0; i < ratings.length; i++) {
            total = total + ratings[i]['rating'];
          }
          mapdata['rating'] = (total / ratings.length).toStringAsFixed(1);
        } else {
          mapdata['rating'] = 0.0.toStringAsFixed(0);
        }
        data.add(mapdata);
      }
      log(jsonEncode(data));
      usersList.assignAll(userFromJson(jsonEncode(data)));
      usersMasterList.assignAll(userFromJson(jsonEncode(data)));
      usersList.sort(
          (b, a) => double.parse(a.rating!).compareTo(double.parse(b.rating!)));
      Get.back();
    } catch (_) {
      Get.back();
      log("ERROR: (getUsers) Something went wrong.");
    }
  }

  searchFunction({required String keyword}) async {
    usersList.clear();
    if (selectedCategory.value == "All") {
      log("all ang selected category");
      if (keyword.isEmpty) {
        usersList.assignAll(usersMasterList);
      } else {
        for (var i = 0; i < usersMasterList.length; i++) {
          if (usersMasterList[i]
              .name
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString())) {
            usersList.add(usersMasterList[i]);
          }
        }
      }
    } else {
      log("dli all ang selected category");
      for (var i = 0; i < usersMasterList.length; i++) {
        if (keyword.isEmpty) {
          log("dre 1");
          if (usersMasterList[i].categories.contains(selectedCategory.value)) {
            usersList.add(usersMasterList[i]);
          }
        } else {
          log("dre 2");
          if (usersMasterList[i]
                  .name
                  .toLowerCase()
                  .toString()
                  .contains(keyword.toLowerCase().toString()) &&
              usersMasterList[i].categories.contains(selectedCategory.value)) {
            usersList.add(usersMasterList[i]);
          }
        }
      }
    }
  }

  getCategories() async {
    try {
      var res = await FirebaseFirestore.instance.collection('categories').get();
      var categories = res.docs;
      List<String> tempdata = <String>[];
      for (var i = 0; i < categories.length; i++) {
        Map mapdata = categories[i].data();

        tempdata.add(mapdata['name']);
      }
      categoriesList.assignAll(tempdata);
      categoriesList.insert(0, "All");
    } catch (e) {
      log("ERROR: (getUsers) Something went wrong.");
    }
  }

  String concatType({required List strings}) {
    String concatenated = strings.join(', ');
    return concatenated;
  }

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      LoadingDialog.showLoadingDialog();
      await getCategories();
      getUsers();
    });

    super.onInit();
  }
}
