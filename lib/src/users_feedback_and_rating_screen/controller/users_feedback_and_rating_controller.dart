import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/getstorage_services.dart';

import '../../../model/ratings_and_feedback_model.dart';

class UsersFeedbackAndRatingController extends GetxController {
  RxString userid = ''.obs;
  RxString ratingsAverage = ''.obs;
  RxString ratingCount = ''.obs;
  RxBool isReplying = false.obs;
  RxString ratingAndFeedbackID = ''.obs;
  TextEditingController message = TextEditingController();

  RxList<RatingsAndFeedback> ratingAndFeedbackList = <RatingsAndFeedback>[].obs;
  getRatingsAndFeedback() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .collection('ratings')
          .get();
      var ratingsAndFeedbacks = res.docs;
      List data = [];
      for (var i = 0; i < ratingsAndFeedbacks.length; i++) {
        Map mapdata = ratingsAndFeedbacks[i].data();
        mapdata['id'] = ratingsAndFeedbacks[i].id;
        mapdata['datecreated'] =
            ratingsAndFeedbacks[i]['datecreated'].toDate().toString();
        data.add(mapdata);
      }
      // log(jsonEncode(data));
      ratingAndFeedbackList
          .assignAll(ratingsAndFeedbackFromJson(jsonEncode(data)));
      ratingCount.value = ratingAndFeedbackList.length.toString();
      if (ratingAndFeedbackList.isNotEmpty) {
        double total = 0.0;
        for (var i = 0; i < ratingAndFeedbackList.length; i++) {
          total = total + double.parse(ratingAndFeedbackList[i].rating);
        }
        ratingsAverage.value =
            (total / ratingAndFeedbackList.length).toStringAsFixed(1);
      } else {
        ratingsAverage.value = 0.0.toStringAsFixed(1);
      }
    } catch (_) {
      log("ERROR: (getRatingsAndFeedback) Something went wrong $_");
    }
  }

  replyToFeedback({required String message}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .collection('ratings')
          .doc(ratingAndFeedbackID.value)
          .update({
        "replies": FieldValue.arrayUnion([
          {
            "image": Get.find<StorageServices>().storage.read('profilePicture'),
            "userid": Get.find<StorageServices>().storage.read('id'),
            "name": Get.find<StorageServices>().storage.read('name'),
            "replymessage": message,
            "datecreated": DateTime.now().toString()
          }
        ])
      });

      getRatingsAndFeedback();
    } catch (_) {
      log("ERROR: (replyToFeedback) Something went wrong $_");
    }
  }

  @override
  void onInit() async {
    userid.value = await Get.arguments['userid'];
    getRatingsAndFeedback();
    super.onInit();
  }
}
