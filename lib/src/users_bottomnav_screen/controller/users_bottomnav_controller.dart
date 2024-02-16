import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/src/users_bookings_request_screen/view/users_bookings_request_view.dart';
import 'package:mediatooker/src/users_notification_screen/view/users_notification_view.dart';
import '../../users_home_screen/view/users_home_view.dart';
import '../../users_project_list_screen/view/users_project_list_view.dart';

class UsersBottomNavViewController extends GetxController {
  List<Widget> screens = [
    const UsersHomeView(),
    const UsersBookingRequestView(),
    const UsersProjectListView(),
    const UsersNotificationView(),
  ];

  TabController? tabController;

  updateFcmToken() async {
    String userID = FirebaseAuth.instance.currentUser!.uid;
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('userid', isEqualTo: userID)
        .get();
    if (res.docs.isNotEmpty) {
      String? token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(res.docs[0].id)
          .update({"fcmToken": token});
    }
  }

  @override
  void onInit() async {
    await updateFcmToken();
    super.onInit();
  }
}
