import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:mediatooker/model/user_model.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:http/http.dart' as http;

class AdminApprovalController extends GetxController {
  RxList<User> pendingUserList = <User>[].obs;
  RxList<User> pendingUsermasterList = <User>[].obs;

  RxList<String> categoriesList = <String>[].obs;
  RxString selectedCategory = 'All'.obs;
  RxList<String> accountTypeList = <String>[
    'All',
    'Client',
    'Individual Provider',
    'Production Provider'
  ].obs;
  RxString selectedAccountType = 'All'.obs;

  TextEditingController search = TextEditingController();
  Timer? debouncer;

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

  getPendingUsers() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .where('isApprovedByAdmin', isEqualTo: false)
          .orderBy('datecreated', descending: true)
          .where('status', isEqualTo: "Pending")
          .get();
      var users = res.docs;
      List data = [];
      for (var i = 0; i < users.length; i++) {
        Map mapdata = users[i].data();
        mapdata['id'] = users[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        data.add(mapdata);
      }
      pendingUserList.assignAll(userFromJson(jsonEncode(data)));
      pendingUsermasterList.assignAll(userFromJson(jsonEncode(data)));
    } catch (_) {
      log("ERROR: (getPendingUsers) Something went wrong $_");
    }
  }

  downloadFile(
      {required String link,
      required int index,
      required String filename}) async {
    pendingUserList[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          pendingUserList[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) async {
          pendingUserList[index].isDownloading.value = false;
          String extension = path.split("/").last.split(".").last;
          final file =
              File('/storage/emulated/0/Download/$filename.$extension');
          var exist = await file.exists();
          if (exist) {
            await OpenFile.open(file.path);
          }
          log("IS FILE EXIST? $exist");
          log("EXTENSION? $extension");
          log("FILE PATH? ${file.path}");
          // Get.snackbar("Message", "File Successfully downloaded",
          //     backgroundColor: AppColors.orange, colorText: AppColors.light);
        },
        onDownloadError: (String error) {
          pendingUserList[index].isDownloading.value = false;
        });
  }

  rejectUsers(
      {required String docid,
      required String email,
      required String name,
      required String remarks}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance.collection('users').doc(docid).update({
        "status": "Rejected",
      });
      await senfEmailNotif(userEmail: email, userName: name, remarks: remarks);
      getPendingUsers();
      Get.back();
    } catch (_) {
      log("ERROR: (rejectUsers) Something went wrong $_");
    }
  }

  acceptUsers({required String docid}) async {
    try {
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(docid)
          .update({"status": "Accepted", "isApprovedByAdmin": true});
      getPendingUsers();
      Get.back();
    } catch (_) {
      log("ERROR: (rejectUsers) Something went wrong $_");
    }
  }

  searchFunction({required String keyword}) async {
    pendingUserList.clear();
    String usertype = '';
    String accounttype = '';

    if (selectedAccountType.value == "Individual Provider") {
      usertype = "Media Provider";
      accounttype = "Individual";
    }
    if (selectedAccountType.value == "Production Provider") {
      usertype = "Media Provider";
      accounttype = "Group";
    }
    if (selectedAccountType.value == "Client") {
      usertype = "Client";
      accounttype = "";
    }
    if (selectedAccountType.value == "All") {
      log("all ang selected category");
      if (keyword.isEmpty) {
        pendingUserList.assignAll(pendingUsermasterList);
      } else {
        for (var i = 0; i < pendingUsermasterList.length; i++) {
          if (pendingUsermasterList[i]
              .name
              .toLowerCase()
              .toString()
              .contains(keyword.toLowerCase().toString())) {
            pendingUserList.add(pendingUsermasterList[i]);
          }
        }
      }
    } else {
      log("dli all ang selected category");
      for (var i = 0; i < pendingUsermasterList.length; i++) {
        if (keyword.isEmpty) {
          log("dre 1");
          if (pendingUsermasterList[i].usertype == usertype &&
              pendingUsermasterList[i].accountType == accounttype) {
            pendingUserList.add(pendingUsermasterList[i]);
          }
        } else {
          log("dre 2");
          if (pendingUsermasterList[i]
                  .name
                  .toLowerCase()
                  .toString()
                  .contains(keyword.toLowerCase().toString()) &&
              pendingUsermasterList[i].usertype == usertype &&
              pendingUsermasterList[i].accountType == accounttype) {
            pendingUserList.add(pendingUsermasterList[i]);
          }
        }
      }
    }
  }

  senfEmailNotif({
    required String userEmail,
    required String userName,
    required String remarks,
  }) async {
    var response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': 'service_yjpqkrj',
          'template_id': 'template_8apkm3i',
          'user_id': 'lsszXDcX_0ZOe47Cr',
          'template_params': {
            'user_name': userName,
            'user_email': userEmail,
            'user_subject': 'MediaTooker Approval Result',
            'user_message': "Your account is REJECTED.",
            'remarks': remarks
          }
        }));
    log(response.statusCode.toString());
  }

  @override
  void onInit() {
    getCategories();
    getPendingUsers();
    super.onInit();
  }
}
