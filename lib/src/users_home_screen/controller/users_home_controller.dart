import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/model/comment_model.dart';
import 'package:mediatooker/services/constant_strings.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/services/notification_services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/post_model.dart';
import '../../users_create_post_screen/view/users_create_post_view.dart';
import '../bottomsheets/users_home_comment_bottom_sheet.dart';

class UsersHomeViewController extends GetxController {
  TextEditingController commentText = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxList<Post> postList = <Post>[].obs;
  RxList<Comments> commentList = <Comments>[].obs;
  DocumentSnapshot? lastDocumentSnapshot;
  String? lastDocumentID;

  listenToScroll() async {
    if (scrollController.hasClients) {
      log("listens to scroll");
      scrollController.addListener(() {
        debugPrint(scrollController.position.maxScrollExtent.toString());
        if (scrollController.position.extentAfter == 0) {
          log('Reached the last item');
          if (postList.length % 10 == 0) {
            reQueryPost();
          } else {
            log('No data available');
          }
        }
      });
    }
  }

  getPost() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('post')
          .orderBy('datecreated', descending: true)
          .limit(10)
          .get();
      var post = res.docs;
      List data = [];
      for (var i = 0; i < post.length; i++) {
        Map mapdata = post[i].data();
        mapdata['id'] = post[i].id;
        mapdata['datecreated'] = post[i]['datecreated'].toDate().toString();

        var userres = await (post[i]['userdocref'] as DocumentReference).get();
        var originaluserres =
            await (post[i]['originalUserDocRef'] as DocumentReference).get();
        mapdata['name'] = originaluserres.get('name');
        mapdata['profilePicture'] = originaluserres.get('profilePhoto');
        mapdata['usertype'] = originaluserres.get('usertype');
        mapdata['contactno'] = originaluserres.get('contactno');
        mapdata['userFcmToken'] = originaluserres.get('fcmToken');

        mapdata['sharerID'] = userres.id;
        mapdata['sharerName'] = userres.get('name');
        mapdata['sharerProfilePicture'] = userres.get('profilePhoto');
        mapdata['sharerUsertype'] = userres.get('usertype');
        mapdata['sharerFcmToken'] = userres.get('fcmToken');

        mapdata.remove('originalUserDocRef');
        mapdata.remove('userdocref');
        data.add(mapdata);
      }
      postList.assignAll(postFromJson(jsonEncode(data)));
      if (postList.isNotEmpty) {
        lastDocumentID = postList.last.id;
        lastDocumentSnapshot = post.last;
      }
    } catch (_) {
      log("ERROR: (getPost) Something went wrong $_");
    }
  }

  reQueryPost() async {
    try {
      LoadingDialog.showLoadingDialog();
      if (lastDocumentID != null) {
        var res = await FirebaseFirestore.instance
            .collection('post')
            .orderBy('datecreated', descending: true)
            .startAfterDocument(lastDocumentSnapshot!)
            .limit(10)
            .get();
        var post = res.docs;
        List data = [];
        for (var i = 0; i < post.length; i++) {
          Map mapdata = post[i].data();
          mapdata['id'] = post[i].id;
          mapdata['datecreated'] = post[i]['datecreated'].toDate().toString();
          var userres =
              await (post[i]['userdocref'] as DocumentReference).get();
          var originaluserres =
              await (post[i]['originalUserDocRef'] as DocumentReference).get();
          mapdata['name'] = originaluserres.get('name');
          mapdata['profilePicture'] = originaluserres.get('profilePhoto');
          mapdata['usertype'] = originaluserres.get('usertype');
          mapdata['contactno'] = originaluserres.get('contactno');
          mapdata['userFcmToken'] = originaluserres.get('fcmToken');

          mapdata['sharerID'] = userres.id;
          mapdata['sharerName'] = userres.get('name');
          mapdata['sharerProfilePicture'] = userres.get('profilePhoto');
          mapdata['sharerUsertype'] = userres.get('usertype');
          mapdata['sharerFcmToken'] = userres.get('fcmToken');

          mapdata.remove('originalUserDocRef');
          mapdata.remove('userdocref');
          data.add(mapdata);
        }
        postList.addAll(postFromJson(jsonEncode(data)));
        if (postList.isNotEmpty) {
          lastDocumentID = postList.last.id;
          lastDocumentSnapshot = post.last;
        } else {
          lastDocumentID = null;
          lastDocumentSnapshot = null;
        }
        log("NUMBERS OF POSTS:::${postList.length.toString()}");
      }
      Get.back();
    } catch (_) {
      Get.back();
      log("NUMBERS OF POSTS:::${postList.length.toString()}");
      log("ERROR: (getPost) Something went wrong $_");
    }
  }

  pickFile() async {
    LoadingDialog.showLoadingDialog();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'jpg',
      'png',
      'jpeg',
      'bmp',
      'mp4',
      'gif',
      'mkv',
      'avi',
      'mpeg',
      'mpg',
      'm4v',
      'ts',
      'm4v',
    ]);
    if (result != null) {
      Get.back();
      Get.to(() => const UsersCreatePostView(), arguments: {
        "filepath": result.files.single.path,
        "fileName": result.files.single.name,
        "extension": result.files.single.extension,
      });
    } else {
      Get.back();
    }
  }

  likePost({required int index, required bool isLike}) async {
    try {
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var postDocument =
          FirebaseFirestore.instance.collection('post').doc(postList[index].id);
      postDocument.update({
        'likes': FieldValue.arrayUnion([userid])
      });
      postList[index].isLike.value = isLike ? false : true;
    } catch (_) {
      log("ERROR: (likePost) Something went wrong $_");
    }
  }

  unlikePost({required int index, required bool isLike}) async {
    try {
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var postDocument =
          FirebaseFirestore.instance.collection('post').doc(postList[index].id);
      postDocument.update({
        'likes': FieldValue.arrayRemove([userid])
      });
      postList[index].isLike.value = isLike ? false : true;
    } catch (_) {
      log("ERROR: (unlikePost) Something went wrong $_");
    }
  }

  callUser({required String contactno}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: contactno,
    );
    await launchUrl(launchUri);
  }

  saveComments({required String postid, required String comment}) async {
    try {
      LoadingDialog.showLoadingDialog();
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var userdoc = FirebaseFirestore.instance.collection('users').doc(userid);
      await FirebaseFirestore.instance.collection('comments').add({
        "comment": comment,
        "userdoc": userdoc,
        "userid": userid,
        "datecreated": Timestamp.now(),
        "postid": postid
      });
      Get.back();
      commentText.clear();
      reCallComments(postID: postid);
    } catch (_) {
      log("ERROR: (saveComments) Something went wrong $_");
    }
  }

  getComments(
      {required String postID,
      required String fcmToken,
      required String userid}) async {
    try {
      LoadingDialog.showLoadingDialog();
      var res = await FirebaseFirestore.instance
          .collection('comments')
          .where('postid', isEqualTo: postID)
          .orderBy('datecreated', descending: true)
          .get();
      var comments = res.docs;
      List data = [];

      for (var i = 0; i < comments.length; i++) {
        Map mapdata = comments[i].data();
        mapdata['id'] = comments[i].id;
        mapdata['datecreated'] = comments[i]['datecreated'].toDate().toString();
        var userres = await (comments[i]['userdoc'] as DocumentReference).get();
        if (userres.exists) {
          mapdata['userprofile'] = userres.get('profilePhoto');
          mapdata['username'] = userres.get('name');
        } else {
          mapdata['userprofile'] = defaultImage;
          mapdata['username'] = "Unknown user";
        }
        mapdata.remove('userdoc');
        data.add(mapdata);
      }

      commentList.assignAll(commentsFromJson(jsonEncode(data)));
      Get.back();
      UsersHomeCommentsBottomSheets.showCommentBottomSheets(
          userid: userid, postid: postID, fcmToken: fcmToken);
    } catch (_) {
      Get.back();
      log("ERROR: (getComments) Something went wrong $_");
    }
  }

  reCallComments({required String postID}) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('comments')
          .where('postid', isEqualTo: postID)
          .orderBy('datecreated', descending: true)
          .get();
      var comments = res.docs;
      List data = [];

      for (var i = 0; i < comments.length; i++) {
        Map mapdata = comments[i].data();
        mapdata['id'] = comments[i].id;
        mapdata['datecreated'] = comments[i]['datecreated'].toDate().toString();
        var userres = await (comments[i]['userdoc'] as DocumentReference).get();
        if (userres.exists) {
          mapdata['userprofile'] = userres.get('profilePhoto');
          mapdata['username'] = userres.get('name');
        } else {
          mapdata['userprofile'] = defaultImage;
          mapdata['username'] = "Unknown user";
        }
        mapdata.remove('userdoc');
        data.add(mapdata);
      }

      commentList.assignAll(commentsFromJson(jsonEncode(data)));
    } catch (_) {
      Get.back();
      log("ERROR: (reCallComments) Something went wrong $_");
    }
  }

  refreshView() async {
    getPost();
  }

  sendNotification({
    required String fmcToken,
    required String action,
    required String userid,
  }) async {
    try {
      String message = "";
      String title = "";
      String currentUsername = Get.find<StorageServices>().storage.read('name');
      if (action == "like") {
        title = "Post Notification";
        message = "$currentUsername like your post";
      }
      if (action == "comment") {
        title = "Post Notification";
        message = "$currentUsername commented on your post";
      }
      if (action == "shared") {
        title = "Post Notification";
        message = "$currentUsername like your shared post";
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
    Future.delayed(const Duration(seconds: 1), () async {
      LoadingDialog.showLoadingDialog();
      await getPost();
      Get.back();
      listenToScroll();
    });

    super.onInit();
  }

  @override
  void onClose() {
    if (scrollController.hasClients) {
      scrollController.dispose();
    }
    super.onClose();
  }
}
