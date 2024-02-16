import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/model/user_model.dart';
import 'package:mediatooker/services/loading_dialog.dart';

class AdminApprovalController extends GetxController {
  RxList<User> pendingUserList = <User>[].obs;
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
        onDownloadCompleted: (String path) {
          pendingUserList[index].isDownloading.value = false;
          Get.snackbar("Message", "File Successfully downloaded",
              backgroundColor: AppColors.orange, colorText: AppColors.light);
        },
        onDownloadError: (String error) {
          pendingUserList[index].isDownloading.value = false;
        });
  }

  rejectUsers({required String docid}) async {
    try {
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance.collection('users').doc(docid).update({
        "status": "Rejected",
      });
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

  @override
  void onInit() {
    getPendingUsers();
    super.onInit();
  }
}
