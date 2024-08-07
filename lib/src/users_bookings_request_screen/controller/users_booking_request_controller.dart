import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/model/bookings_model.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';

import '../../../services/notification_services.dart';

class UsersBookingRequestController extends GetxController {
  RxList<Bookings> bookingsList = <Bookings>[].obs;
  RxList<Bookings> bookingsListMasterList = <Bookings>[].obs;

  TextEditingController search = TextEditingController();
  RxString usertype =
      Get.find<StorageServices>().storage.read('type').toString().obs;

  Timer? debouncer;

  RxString currentSubscription = ''.obs;
  RxInt currentUpload = 0.obs;
  RxInt currentBooking = 0.obs;

  getSubscriptions() async {
    try {
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'))
          .get();
      if (user.exists) {
        currentSubscription.value =
            user['subscription'].toString().capitalizeFirst.toString();
        currentUpload.value = user['uploads'];
        currentBooking.value = user['bookings'];
      }
    } catch (_) {
      log("ERROR (getSubscriptions): Something went wrong ${_.toString()}");
    }
  }

  getBookings() async {
    try {
      QuerySnapshot<Map<String, dynamic>>? res;
      if (Get.find<StorageServices>().storage.read('type') == "Client") {
        res = await FirebaseFirestore.instance
            .collection('bookings')
            .where('clientID',
                isEqualTo: Get.find<StorageServices>().storage.read('id'))
            .where('accepted', isEqualTo: false)
            .orderBy('datecreated', descending: true)
            .get();
      } else {
        res = await FirebaseFirestore.instance
            .collection('bookings')
            .where('providerID',
                isEqualTo: Get.find<StorageServices>().storage.read('id'))
            .orderBy('datecreated', descending: true)
            .where('accepted', isEqualTo: false)
            .get();
      }
      List data = [];
      var bookings = res.docs;
      for (var i = 0; i < bookings.length; i++) {
        Map mapdata = bookings[i].data();
        mapdata['id'] = bookings[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        mapdata['date'] = mapdata['date'].toDate().toString();
        mapdata['time'] = mapdata['time'].toDate().toString();

        if (mapdata.containsKey('remarks')) {
          mapdata['remarks'] = mapdata['remarks'].toString();
        }

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
      bookingsList.assignAll(bookingsFromJson(jsonEncode(data)));
      bookingsListMasterList.assignAll(bookingsFromJson(jsonEncode(data)));
    } catch (_) {
      log("ERROR: (getBookings) Something went wrong $_");
    }
  }

  searchBooking({required String word}) async {
    try {
      if (word.isNotEmpty) {
        bookingsList.clear();
        for (var i = 0; i < bookingsListMasterList.length; i++) {
          if (usertype.value == "Client") {
            if (bookingsListMasterList[i]
                    .providerName
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                bookingsListMasterList[i]
                    .providerEmail
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                bookingsListMasterList[i]
                    .projectTitle
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString())) {
              bookingsList.add(bookingsListMasterList[i]);
            }
          } else {
            if (bookingsListMasterList[i]
                    .clientName
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                bookingsListMasterList[i]
                    .clientEmail
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString()) ||
                bookingsListMasterList[i]
                    .projectTitle
                    .toLowerCase()
                    .toString()
                    .contains(word.toLowerCase().toString())) {
              bookingsList.add(bookingsListMasterList[i]);
            }
          }
        }
      } else {
        bookingsList.assignAll(bookingsListMasterList);
      }
    } catch (_) {}
  }

  acceptProject({required String docid}) async {
    LoadingDialog.showLoadingDialog();
    try {
      if (currentBooking.value > 0) {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(docid)
            .update({"status": "Ongoing", "accepted": true});
        getBookings();
        Get.back();
        int newBookingCount = currentBooking.value - 1;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(Get.find<StorageServices>().storage.read('id'))
            .update({
          "bookings": newBookingCount,
        });
      } else {
        Get.back();
        Get.snackbar("Message",
            "You have no booking points left to accept a project. Subscribe to get points and accept more projects.",
            duration: const Duration(seconds: 6),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
      }
    } catch (_) {
      log("ERROR: (acceptProject) Something went wrong $_");
    }
  }

  rejectProject({required String docid, required String remarks}) async {
    LoadingDialog.showLoadingDialog();
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docid)
          .update({"status": "Rejected", "remarks": remarks});
      getBookings();
      Get.back();
    } catch (_) {
      log("ERROR: (acceptProject) Something went wrong $_");
    }
  }

  sendNotification({
    required String fmcToken,
    required String action,
    required String userid,
    required String projectName,
    required String remarks,
  }) async {
    try {
      log("FCM TOKEN::: $fmcToken");
      String message = "";
      String title = "";
      String currentUsername = Get.find<StorageServices>().storage.read('name');
      title = "Booking Notification";
      if (action == "Reject") {
        message =
            "Your project $projectName is rejected by $currentUsername. $currentUsername said '$remarks'";
      }
      if (action == "Accept") {
        message = "Your project $projectName is accepted by $currentUsername.";
      }
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

  @override
  void onInit() async {
    await getSubscriptions();
    getBookings();

    super.onInit();
  }
}
