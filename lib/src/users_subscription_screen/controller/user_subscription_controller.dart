import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/getstorage_services.dart';

class UserSubscriptionController extends GetxController {
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

  @override
  void onInit() {
    getSubscriptions();
    super.onInit();
  }
}
