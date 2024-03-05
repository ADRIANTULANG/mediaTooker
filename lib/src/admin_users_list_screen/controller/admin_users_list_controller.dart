import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/model/user_model.dart';
import 'package:mediatooker/services/loading_dialog.dart';

class AdminUsersListController extends GetxController {
  RxList<User> usersList = <User>[].obs;
  getUsers() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('datecreated', descending: true)
          .get();
      var users = res.docs;
      List data = [];
      for (var i = 0; i < users.length; i++) {
        Map mapdata = users[i].data();
        mapdata['id'] = users[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        data.add(mapdata);
      }
      usersList.assignAll(userFromJson(jsonEncode(data)));
    } catch (_) {
      log("ERROR: (getUsers) Something went wrong $_");
    }
  }

  downloadFile(
      {required String link,
      required int index,
      required String filename}) async {
    usersList[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          usersList[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) {
          usersList[index].isDownloading.value = false;
          Get.snackbar("Message", "File Successfully downloaded",
              backgroundColor: AppColors.orange, colorText: AppColors.light);
        },
        onDownloadError: (String error) {
          usersList[index].isDownloading.value = false;
        });
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
      getUsers();
    } catch (_) {
      log("ERROR: (editRestriction) Something went wrong $_");
    }
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}
