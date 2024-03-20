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

  getUsers() async {
    try {
      var res = await FirebaseFirestore.instance.collection('users').get();
      var users = res.docs;
      List data = [];
      for (var i = 0; i < users.length; i++) {
        Map mapdata = users[i].data();
        mapdata['id'] = users[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        data.add(mapdata);
      }
      usersList.assignAll(userFromJson(jsonEncode(data)));
      usersMasterList.assignAll(userFromJson(jsonEncode(data)));
      Get.back();
    } catch (_) {
      Get.back();
      log("ERROR: (getUsers) Something went wrong.");
    }
  }

  searchFunction({required String keyword}) async {
    if (keyword.isNotEmpty) {
      usersList.clear();
      for (var i = 0; i < usersMasterList.length; i++) {
        if (usersMasterList[i]
            .name
            .toLowerCase()
            .toString()
            .contains(keyword.toLowerCase().toString())) {
          usersList.add(usersMasterList[i]);
        }
      }
    } else {
      usersList.assignAll(usersMasterList);
    }
  }

  @override
  void onInit() async {
    Future.delayed(const Duration(seconds: 1), () async {
      LoadingDialog.showLoadingDialog();
      getUsers();
    });

    super.onInit();
  }
}
