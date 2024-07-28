import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../model/reports_model.dart';
import '../../../services/loading_dialog.dart';
import '../../admin_users_list_screen/controller/admin_users_list_controller.dart';

class AdminReportsController extends GetxController {
  RxList<Reports> reportsList = <Reports>[].obs;
  RxList<Reports> reportsMasterList = <Reports>[].obs;
  TextEditingController search = TextEditingController();
  Timer? debouncer;

  getReportedUsers() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('reports')
          .orderBy('datecreated', descending: true)
          .get();
      var users = res.docs;
      List data = [];
      for (var i = 0; i < users.length; i++) {
        Map mapdata = users[i].data();
        if (mapdata['validated'] == false) {
          mapdata['id'] = users[i].id;
          mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
          var reportedUserDetails = await FirebaseFirestore.instance
              .collection('users')
              .doc(mapdata['userid'])
              .get();
          if (reportedUserDetails.exists) {
            mapdata['restricted'] = reportedUserDetails.get('restricted');
            mapdata['categories'] = reportedUserDetails.get('categories');
          } else {
            mapdata['restricted'] = false;
            mapdata['categories'] = [];
          }
          data.add(mapdata);
        }
      }

      reportsList.assignAll(reportsFromJson(jsonEncode(data)));
      reportsMasterList.assignAll(reportsFromJson(jsonEncode(data)));
    } catch (_) {
      log("ERROR: (getReportedUsers) Something went wrong $_");
    }
  }

  editRestriction({
    required String docid,
    required bool boolean,
  }) async {
    try {
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docid)
          .update({"restricted": boolean});
      Get.back();
      getReportedUsers();
      Get.find<AdminUsersListController>().getUsers();
    } catch (_) {
      Get.back();
      log("ERROR: (editRestriction) Something went wrong $_");
    }
  }

  searchFunction({required String keyword}) async {
    reportsList.clear();
    if (keyword.isEmpty) {
      reportsList.assignAll(reportsMasterList);
    } else {
      for (var i = 0; i < reportsMasterList.length; i++) {
        if (reportsMasterList[i]
                .name
                .toLowerCase()
                .toString()
                .contains(keyword.toLowerCase().toString()) ||
            reportsMasterList[i]
                .reporterName
                .toLowerCase()
                .toString()
                .contains(keyword.toLowerCase().toString())) {
          reportsList.add(reportsMasterList[i]);
        }
      }
    }
  }

  validateReport({required String reportID}) async {
    try {
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('reports')
          .doc(reportID)
          .update({"validated": true});
      Get.back();
      getReportedUsers();
      Get.snackbar("Message", "Reported validated.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    } catch (e) {
      log("ERROR: (getUsers) Something went wrong.");
    }
  }

  @override
  void onInit() {
    // getCategories();
    getReportedUsers();
    super.onInit();
  }
}
