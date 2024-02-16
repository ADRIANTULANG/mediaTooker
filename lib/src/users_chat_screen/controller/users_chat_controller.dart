import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/model/chats_model.dart';
import 'package:mediatooker/services/constant_strings.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/services/notification_services.dart';

class UsersChatController extends GetxController {
  RxString usertype =
      Get.find<StorageServices>().storage.read('type').toString().obs;
  RxString currentUserID =
      Get.find<StorageServices>().storage.read('id').toString().obs;

  RxString username = ''.obs;
  RxString profilePic = defaultImage.obs;

  RxString userid = ''.obs;
  RxString projectID = ''.obs;
  RxString fcmToken = ''.obs;

  RxBool isUserOnline = false.obs;

  StreamSubscription<dynamic>? userListener;
  Stream? userStream;

  StreamSubscription<dynamic>? chatListener;
  Stream? chatStream;

  ScrollController scrollController = ScrollController();
  TextEditingController message = TextEditingController();
  RxList<Chats> chatList = <Chats>[].obs;

  @override
  void onInit() async {
    userid.value = await Get.arguments['userid'];
    projectID.value = await Get.arguments['projectID'];
    username.value = await Get.arguments['username'];
    profilePic.value = await Get.arguments['profilePic'];
    fcmToken.value = await Get.arguments['fcmToken'];

    updateCurrentUserStatusOnline(status: true);
    checkIfUserIsOnline();
    getChats();
    super.onInit();
  }

  updateCurrentUserStatusOnline({required bool status}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserID.value)
        .update({"isOnline": status});
    if (usertype.value == "Client") {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(projectID.value)
          .update({
        "isSeenByClient": true,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(projectID.value)
          .update({
        "isSeenByProvider": true,
      });
    }
  }

  navigateBack() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserID.value)
        .update({"isOnline": false});
    Get.back();
  }

  checkIfUserIsOnline() async {
    userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userid.value)
        .snapshots();
    userListener = userStream!.listen((event) async {
      var data = await event.data();
      isUserOnline.value = data['isOnline'];
    });
  }

  getChats() async {
    log("called here");
    chatStream = FirebaseFirestore.instance
        .collection('bookings')
        .doc(projectID.value)
        .snapshots();

    chatListener = chatStream!.listen((event) async {
      var data = await event.data();
      chatList.assignAll(chatsFromJson(jsonEncode(data['chats'])));

      Future.delayed(const Duration(seconds: 1), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });
  }

  sendMessage({required String messagetosend}) async {
    message.clear();
    var postDocument =
        FirebaseFirestore.instance.collection('bookings').doc(projectID.value);
    postDocument.update({
      'chats': FieldValue.arrayUnion([
        {
          "chats": messagetosend,
          "url": "",
          "datecreated": DateTime.now().toString(),
          "sender": Get.find<StorageServices>().storage.read('id'),
          "type": "text"
        }
      ]),
      "isSeenByClient": usertype.value == "Client" ? true : isUserOnline.value,
      "isSeenByProvider":
          usertype.value == "Media Provider" ? true : isUserOnline.value
    });
  }

  sendImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'jpg',
      'png',
      'jpeg',
    ]);
    if (result != null) {
      LoadingDialog.showLoadingDialog();

      var filepath = result.files.single.path!;
      var fileName = result.files.single.name;

      Uint8List uint8list =
          Uint8List.fromList(File(filepath).readAsBytesSync());
      final ref = FirebaseStorage.instance.ref().child("chatimages/$fileName");
      var uploadTask = ref.putData(uint8list);
      final snapshot = await uploadTask.whenComplete(() {});
      var fileLink = await snapshot.ref.getDownloadURL();

      var postDocument = FirebaseFirestore.instance
          .collection('bookings')
          .doc(projectID.value);
      postDocument.update({
        'chats': FieldValue.arrayUnion([
          {
            "chats": "",
            "url": fileLink,
            "datecreated": DateTime.now().toString(),
            "sender": Get.find<StorageServices>().storage.read('id'),
            "type": "image"
          }
        ]),
        "isSeenByClient":
            usertype.value == "Client" ? true : isUserOnline.value,
        "isSeenByProvider":
            usertype.value == "Media Provider" ? true : isUserOnline.value
      });
      Get.back();
    }
  }

  sendNotification({
    required String fmcToken,
    required String userid,
  }) async {
    try {
      String message = "";
      String title = "";
      String currentUsername = Get.find<StorageServices>().storage.read('name');
      title = "Chat Notification";
      message = "$currentUsername sent you a message";
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
  void onClose() {
    chatListener!.cancel();
    userListener!.cancel();
    super.onClose();
  }
}
