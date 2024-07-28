import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/src/users_bookings_request_screen/controller/users_booking_request_controller.dart';

import '../../../config/app_colors.dart';
import '../../../services/notification_services.dart';

class UsersBookProviderController extends GetxController {
  RxString userid = ''.obs;
  TextEditingController message = TextEditingController();
  TextEditingController projectTitle = TextEditingController();
  RxString selectedDate = ''.obs;
  DateTime? selectedDateFormated;
  RxString selectedTime = ''.obs;
  DateTime? selectedTimeFormated;

  RxString currentSubscription = ''.obs;
  RxInt currentUpload = 0.obs;
  RxInt currentBooking = 0.obs;

  @override
  void onInit() async {
    await getSubscriptions();
    userid.value = await Get.arguments['userid'];
    super.onInit();
  }

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

  getDate() async {
    DateTime? datePicked = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050, 12, 30));
    if (datePicked != null) {
      selectedDate.value = DateFormat.yMMMMd().format(datePicked);
      selectedDateFormated = datePicked;
    }
  }

  getTime() async {
    TimeOfDay? timepicked = await showTimePicker(
        context: Get.context!, initialTime: TimeOfDay.now());
    if (timepicked != null) {
      DateTime dateFormat = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, timepicked.hour, timepicked.minute);
      selectedTime.value = DateFormat.jm().format(dateFormat);
      selectedTimeFormated = dateFormat;
    }
  }

  bookProvider() async {
    try {
      LoadingDialog.showLoadingDialog();
      if (currentBooking.value > 0) {
        var providerDocRef =
            FirebaseFirestore.instance.collection('users').doc(userid.value);
        var clientDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(Get.find<StorageServices>().storage.read('id'));
        await FirebaseFirestore.instance.collection('bookings').add({
          "providerDocRef": providerDocRef,
          "providerID": providerDocRef.id,
          "clientDocRef": clientDocRef,
          "clientID": clientDocRef.id,
          "projectTitle": projectTitle.text,
          "date": selectedDateFormated,
          "time": selectedTimeFormated,
          "datecreated": Timestamp.now(),
          "accepted": false,
          "message": message.text,
          "status": "Pending",
          "chats": [],
          "isSeenByClient": true,
          "isSeenByProvider": true
        });
        sendNotification(userid: userid.value);
        Get.find<UsersBookingRequestController>().getBookings();
        Get.back();
        Get.back();
        Get.snackbar("Message",
            "Thank you. This media provider will evaluate your booking.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
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
            "You have no booking points left to book a project. Subscribe to book a project.",
            duration: const Duration(seconds: 6),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
      }
    } catch (_) {
      Get.back();
      log("ERROR: (bookProvider) something went wrong $_.");
    }
  }

  sendNotification({
    required String userid,
  }) async {
    try {
      var userDetails = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get();
      if (userDetails.exists) {
        log("FCM TOKEN::: ${userDetails['fcmToken']}");
        await Get.find<NotificationServices>().sendNotification(
            userToken: userDetails['fcmToken'],
            message:
                "Hi ${userDetails['name']}, you have a new booking that can be checked.",
            title: "Booking Notification");
        await FirebaseFirestore.instance.collection('notifications').add({
          "userid": userid,
          "datecreated": DateTime.now().toString(),
          "message":
              "Hi ${userDetails['name']}, you have a new booking that can be checked.",
          "title": "Booking Notification"
        });
      }
    } catch (_) {
      log("ERROR: (sendNotification) Something went wrong $_");
    }
  }
}
