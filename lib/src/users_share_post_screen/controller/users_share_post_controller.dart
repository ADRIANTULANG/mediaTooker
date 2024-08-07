import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/constant_strings.dart';
import 'package:mediatooker/services/loading_dialog.dart';

import '../../../services/getstorage_services.dart';
import '../../users_home_screen/controller/users_home_controller.dart';

class UserSharePostController extends GetxController {
  TextEditingController textPost = TextEditingController();
  RxBool isPlaying = false.obs;
  RxBool isPublic = true.obs;
  RxString url = ''.obs;
  RxString filetype = ''.obs;
  RxString userName = ''.obs;
  RxString profilePicture = defaultImage.obs;
  RxString postID = ''.obs;
  RxString originalCaption = ''.obs;
  RxString originalUserID = ''.obs;

  RxString currentSubscription = ''.obs;
  RxInt currentUpload = 0.obs;
  RxInt currentBooking = 0.obs;

  @override
  void onInit() async {
    await getSubscriptions();
    filetype.value = await Get.arguments['filetype'];
    url.value = await Get.arguments['url'];
    userName.value = await Get.arguments['userName'];
    profilePicture.value = await Get.arguments['profilePicture'];
    postID.value = await Get.arguments['postID'];
    originalCaption.value = await Get.arguments['originalCaption'];
    originalUserID.value = await Get.arguments['originalUserID'];
    log(filetype.value);
    log(url.value);

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

  sharePost() async {
    LoadingDialog.showLoadingDialog();
    if (currentUpload.value > 0) {
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var docref = FirebaseFirestore.instance.collection('users').doc(userid);
      var originalUserDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(originalUserID.value);
      await FirebaseFirestore.instance.collection('post').add({
        "userdocref": docref,
        "userID": userid,
        "type": filetype.value,
        "url": url.value,
        "textpost": textPost.text,
        "likes": [],
        "datecreated": Timestamp.now(),
        "isShared": true,
        "originalUserDocRef": originalUserDocRef,
        "originalUserID": originalUserDocRef.id,
        "originalUserTextPost": originalCaption.value,
      });
      Get.back();
      Get.back();
      Get.find<UsersHomeViewController>().getPost();
    } else {
      Get.back();
      Get.snackbar("Message",
          "You have no upload/post points left to share a post. Subscribe to share a post content.",
          duration: const Duration(seconds: 6),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    }
    try {} catch (_) {
      log("ERROR: (sharePost) Something went wrong. $_");
    }
  }
}
