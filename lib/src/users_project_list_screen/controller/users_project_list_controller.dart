import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/notification_services.dart';

import '../../../model/bookings_model.dart';
import '../../../services/getstorage_services.dart';
import '../../../services/loading_dialog.dart';

class UsersProjectListController extends GetxController {
  RxList<Bookings> projectList = <Bookings>[].obs;
  RxList<Bookings> projectListMasterList = <Bookings>[].obs;

  TextEditingController search = TextEditingController();
  RxString usertype =
      Get.find<StorageServices>().storage.read('type').toString().obs;

  StreamSubscription<dynamic>? projectListListener;
  Stream? projectStream;

  Timer? debouncer;

  getProjectStream() async {
    try {
      if (Get.find<StorageServices>().storage.read('type') == "Client") {
        projectStream = FirebaseFirestore.instance
            .collection('bookings')
            .where('clientID',
                isEqualTo: Get.find<StorageServices>().storage.read('id'))
            .where('accepted', isEqualTo: true)
            .orderBy('datecreated', descending: true)
            .snapshots();
      } else {
        projectStream = FirebaseFirestore.instance
            .collection('bookings')
            .where('providerID',
                isEqualTo: Get.find<StorageServices>().storage.read('id'))
            .orderBy('datecreated', descending: true)
            .where('accepted', isEqualTo: true)
            .snapshots();
      }

      projectListListener = projectStream!.listen((event) async {
        List data = [];
        for (var project in event.docs) {
          Map mapdata = project.data();
          mapdata['id'] = project.id;
          mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
          mapdata['date'] = mapdata['date'].toDate().toString();
          mapdata['time'] = mapdata['time'].toDate().toString();
          var providerDetails =
              await (mapdata['providerDocRef'] as DocumentReference).get();
          mapdata['providerName'] = providerDetails.get('name');
          mapdata['providerEmail'] = providerDetails.get('email');
          mapdata['providerProfilePic'] = providerDetails.get('profilePhoto');
          mapdata['providerAddress'] = providerDetails.get('address');
          mapdata['providerContact'] = providerDetails.get('contactno');
          mapdata['providerFcmToken'] = providerDetails.get('fcmToken');

          var clientDetails =
              await (mapdata['clientDocRef'] as DocumentReference).get();
          mapdata['clientName'] = clientDetails.get('name');
          mapdata['clientEmail'] = clientDetails.get('email');
          mapdata['clientProfilePic'] = clientDetails.get('profilePhoto');
          mapdata['clientAddress'] = clientDetails.get('address');
          mapdata['clientContact'] = clientDetails.get('contactno');
          mapdata['clientFcmToken'] = clientDetails.get('fcmToken');

          mapdata.remove('clientDocRef');
          mapdata.remove('providerDocRef');
          mapdata.remove('chats');
          data.add(mapdata);
        }
        projectList.assignAll(bookingsFromJson(jsonEncode(data)));
        projectListMasterList.assignAll(bookingsFromJson(jsonEncode(data)));
      });
    } on Exception catch (_) {
      log("ERROR: (getBookings) Something went wrong $_");
    }
  }

  searchProject({required String word}) async {
    try {
      if (word.isNotEmpty) {
        projectList.clear();
        for (var i = 0; i < projectListMasterList.length; i++) {
          if (usertype.value == "Client") {
            if (projectListMasterList[i]
                    .providerName
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                projectListMasterList[i]
                    .providerEmail
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                projectListMasterList[i]
                    .projectTitle
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString())) {
              projectList.add(projectListMasterList[i]);
            }
          } else {
            if (projectListMasterList[i]
                    .clientName
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                projectListMasterList[i]
                    .clientEmail
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                projectListMasterList[i]
                    .projectTitle
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString())) {
              projectList.add(projectListMasterList[i]);
            }
          }
        }
      } else {
        projectList.assignAll(projectListMasterList);
      }
    } catch (_) {}
  }

  finishedProject({required String docid}) async {
    LoadingDialog.showLoadingDialog();
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docid)
          .update({"status": "Finished"});

      Get.back();
    } catch (_) {
      log("ERROR: (acceptProject) Something went wrong $_");
    }
  }

  sendNotification({
    required String fmcToken,
    required String userid,
    required String projectName,
  }) async {
    try {
      String message = "";
      String title = "";
      String currentUsername = Get.find<StorageServices>().storage.read('name');
      title = "Project Notification";
      message = "Your project $projectName is finished by $currentUsername";
      await Get.find<NotificationServices>().sendNotification(
          userToken: fmcToken, message: message, title: title);
      await FirebaseFirestore.instance.collection('notifications').add({
        "userid": userid,
        "datecreated": DateTime.now().toString(),
        "message": message,
        "title": title
      });
    } catch (_) {
      log("ERROR: (sendNotification) Something went wrong $_");
    }
  }

  rateUser(
      {required double userrating,
      required String userid,
      required String feedback}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .collection('ratings')
          .where('userid',
              isEqualTo: Get.find<StorageServices>().storage.read('id'))
          .get();
      if (res.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .collection('ratings')
            .doc(res.docs[0].id)
            .update({"rating": userrating, "feedback": feedback});
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .collection('ratings')
            .add({
          "userid": Get.find<StorageServices>().storage.read('id'),
          "rating": userrating,
          "feedback": feedback,
          "userimage":
              Get.find<StorageServices>().storage.read('profilePicture'),
          "username": Get.find<StorageServices>().storage.read('name'),
          "datecreated": Timestamp.now()
        });
      }
      Get.back();
      Get.snackbar("Message", "Thank you for providing feedback and rating.",
          backgroundColor: AppColors.orange, colorText: Colors.white);
    } catch (_) {}
  }

  @override
  void onInit() {
    getProjectStream();
    super.onInit();
  }

  @override
  void onClose() {
    projectListListener!.cancel();
    super.onClose();
  }
}
