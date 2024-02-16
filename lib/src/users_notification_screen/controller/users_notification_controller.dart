import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/getstorage_services.dart';

import '../../../model/notif_model.dart';

class UsersNotificationController extends GetxController {
  RxList<Notif> notificationList = <Notif>[].obs;
  RxInt unseenCount = 0.obs;
  getNotifications() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userid',
              isEqualTo: Get.find<StorageServices>().storage.read('id'))
          .orderBy('datecreated', descending: true)
          .get();
      var notifs = res.docs;
      List data = [];
      for (var i = 0; i < notifs.length; i++) {
        Map mapdata = notifs[i].data();
        mapdata['id'] = notifs[i].id;
        data.add(mapdata);
      }
      // log(jsonEncode(data));
      notificationList.assignAll(notifFromJson(jsonEncode(data)));
      countUnseen();
    } catch (_) {
      log("ERROR: (getNotifications) Something went wrong $_");
    }
  }

  countUnseen() async {
    unseenCount.value = 0;
    for (var i = 0; i < notificationList.length; i++) {
      if (notificationList[i].isSeen.value == false) {
        unseenCount.value = unseenCount.value + 1;
      }
    }
  }

  updateIsSeen({required String docid}) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(docid)
          .update({"isSeen": true});
    } catch (_) {
      log("ERROR: (updateIsSeen) Something went wrong $_");
    }
  }

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }
}
