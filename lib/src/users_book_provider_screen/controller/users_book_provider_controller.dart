import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/src/users_bookings_request_screen/controller/users_booking_request_controller.dart';

import '../../../config/app_colors.dart';

class UsersBookProviderController extends GetxController {
  RxString userid = ''.obs;
  TextEditingController message = TextEditingController();
  TextEditingController projectTitle = TextEditingController();
  RxString selectedDate = ''.obs;
  DateTime? selectedDateFormated;
  RxString selectedTime = ''.obs;
  DateTime? selectedTimeFormated;

  @override
  void onInit() async {
    userid.value = await Get.arguments['userid'];
    super.onInit();
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
      Get.find<UsersBookingRequestController>().getBookings();
      Get.back();
      Get.back();
      Get.snackbar("Message",
          "Thank you. This media provider will evaluate your booking.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    } catch (_) {
      Get.back();
      log("ERROR: (bookProvider) something went wrong $_.");
    }
  }
}
