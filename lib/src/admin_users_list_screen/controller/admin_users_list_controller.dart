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
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file_plus/open_file_plus.dart';

class AdminUsersListController extends GetxController {
  RxList<User> usersList = <User>[].obs;
  RxList<User> usersMasterList = <User>[].obs;

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

  RxInt clientCount = 0.obs;
  RxInt mediaProviderCount = 0.obs;

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

  getUsers() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('datecreated', descending: true)
          .get();
      var users = res.docs;
      List data = [];
      int countClient = 0;
      int countMediaProvider = 0;
      for (var i = 0; i < users.length; i++) {
        Map mapdata = users[i].data();
        if (mapdata['usertype'] == 'Client') {
          countClient++;
        } else {
          countMediaProvider++;
        }
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
          mapdata['rating'] = 0.0.toStringAsFixed(1);
        }
        data.add(mapdata);
      }
      clientCount.value = countClient;
      mediaProviderCount.value = countMediaProvider;
      usersList.assignAll(userFromJson(jsonEncode(data)));
      usersMasterList.assignAll(userFromJson(jsonEncode(data)));
      usersList.sort(
          (b, a) => double.parse(a.rating!).compareTo(double.parse(b.rating!)));
    } catch (_) {
      log("ERROR: (getUsers) Something went wrong $_");
    }
  }

  void openFile({required String link}) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      throw 'Could not launch $link';
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
        onDownloadCompleted: (String path) async {
          usersList[index].isDownloading.value = false;

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

  searchFunction({required String keyword}) async {
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

    usersList.clear();
    if (selectedAccountType.value == "All") {
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
          if (usersMasterList[i].usertype == usertype &&
              usersMasterList[i].accountType == accounttype) {
            usersList.add(usersMasterList[i]);
          }
        } else {
          log("dre 2");
          if (usersMasterList[i]
                  .name
                  .toLowerCase()
                  .toString()
                  .contains(keyword.toLowerCase().toString()) &&
              usersMasterList[i].usertype == usertype &&
              usersMasterList[i].accountType == accounttype) {
            usersList.add(usersMasterList[i]);
          }
        }
      }
    }
    usersList.sort(
        (b, a) => double.parse(a.rating!).compareTo(double.parse(b.rating!)));
  }

  @override
  void onInit() {
    getUsers();
    getCategories();
    super.onInit();
  }
}
