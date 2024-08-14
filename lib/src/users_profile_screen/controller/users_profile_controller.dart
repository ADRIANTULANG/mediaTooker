import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/model/comment_model.dart';
import 'package:mediatooker/services/constant_strings.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/services/notification_services.dart';
import 'package:mediatooker/src/users_profile_screen/bottomsheets/users_profile_bottomsheets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_colors.dart';
import '../../../model/bookings_model.dart';
import '../../../model/post_model.dart';
import '../../../services/categories_model.dart';

class UsersProfileController extends GetxController {
  RxString userid = ''.obs;
  RxBool isLoading = true.obs;
  RxString responseMessage = ''.obs;
  RxString name = ''.obs;
  RxString profilePic = defaultImage.obs;
  RxString coverPic = defaultCover.obs;
  RxString email = ''.obs;
  RxString address = ''.obs;
  RxString contactNo = ''.obs;
  RxString usertype = ''.obs;
  RxString accountType = ''.obs;
  RxString bio = ''.obs;
  RxString rating = ''.obs;
  RxString selectedContentView = 'Posts'.obs;

  TextEditingController commentText = TextEditingController();

  RxList<Post> allPost = <Post>[].obs;
  RxList<Post> photoPost = <Post>[].obs;
  RxList<Post> videoPost = <Post>[].obs;
  RxList<Bookings> projectList = <Bookings>[].obs;
  RxList<Bookings> projectListMasterList = <Bookings>[].obs;
  RxList<Comments> commentList = <Comments>[].obs;
  RxList<String> userCategories = <String>[].obs;
  RxList<CategoriesModel> categoriesList = <CategoriesModel>[].obs;

  getCategories() async {
    try {
      var res = await FirebaseFirestore.instance.collection('categories').get();
      var categories = res.docs;
      List tempdata = [];
      for (var i = 0; i < categories.length; i++) {
        Map mapdata = categories[i].data();
        mapdata['id'] = categories[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        tempdata.add(mapdata);
      }
      categoriesList.assignAll(categoriesModelFromJson(jsonEncode(tempdata)));
    } catch (_) {
      Get.snackbar("Message", "Something went wrong please try again later",
          backgroundColor: AppColors.orange, colorText: AppColors.dark);
    }
  }

  getUserProfile() async {
    isLoading.value = true;
    LoadingDialog.showLoadingDialog();
    try {
      var userdetails = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .get();
      if (userdetails.exists) {
        await getPost();
        Get.back();
        usertype.value = userdetails.get('usertype');
        name.value = userdetails.get('name');
        profilePic.value = userdetails.get('profilePhoto');
        coverPic.value = userdetails.get('coverPhoto');
        contactNo.value = userdetails.get('contactno');
        address.value = userdetails.get('address');
        email.value = userdetails.get('email');
        accountType.value = userdetails.get('accountType');
        bio.value = userdetails.get('bio');
        var cat = userdetails.get('categories');
        for (var i = 0; i < cat.length; i++) {
          userCategories.add(cat[i]);
        }

        var resrating = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid.value)
            .collection('ratings')
            .get();
        if (resrating.docs.isNotEmpty) {
          var ratings = resrating.docs;
          double total = 0.0;
          for (var i = 0; i < ratings.length; i++) {
            total = total + ratings[i]['rating'];
          }
          rating.value = (total / ratings.length).toStringAsFixed(1);
        } else {
          rating.value = 0.0.toStringAsFixed(1);
        }
      } else {
        Get.back();
        responseMessage.value = "Sorry we cannot load the data.";
      }
    } catch (_) {
      Get.back();
      log("ERROR: (getUserProfile) Something went wrong.");
    }
    isLoading.value = false;
  }

  getPost() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('post')
          .where(Filter.or(
            Filter("originalUserID", isEqualTo: userid.value),
            Filter("userID", isEqualTo: userid.value),
          ))
          .orderBy('datecreated', descending: true)
          .get();
      var post = res.docs;
      List dataall = [];
      List dataForMediaOnly = [];

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
        if (mapdata['userID'] == userid.value) {
          dataall.add(mapdata);
          if (mapdata['type'] != "text") {
            dataForMediaOnly.add(mapdata);
          }
        }
      }
      allPost.assignAll(postFromJson(jsonEncode(dataall)));
      for (var i = 0; i < allPost.length; i++) {
        if (allPost[i].type == "image") {
          photoPost.add(allPost[i]);
        }
        if (allPost[i].type == "video") {
          videoPost.add(allPost[i]);
        }
      }
    } catch (_) {
      log("ERROR: (getPost) Something went wrong $_");
    }
  }

  editProfilePic() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'jpg',
      'png',
      'jpeg',
    ]);
    if (result != null) {
      LoadingDialog.showLoadingDialog();
      String filepath = result.files.single.path!;
      String fileName = result.files.single.name;
      Uint8List uint8list =
          Uint8List.fromList(File(filepath).readAsBytesSync());
      final ref =
          FirebaseStorage.instance.ref().child("userpictures/$fileName");
      var uploadTask = ref.putData(uint8list);
      final snapshot = await uploadTask.whenComplete(() {});
      var fileLink = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .update({"profilePhoto": fileLink});
      profilePic.value = fileLink;
      Get.find<StorageServices>().storage.write("profilePicture", fileLink);
      Get.back();
    } else {}
  }

  editCoverPic() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'jpg',
      'png',
      'jpeg',
    ]);
    if (result != null) {
      LoadingDialog.showLoadingDialog();
      String filepath = result.files.single.path!;
      String fileName = result.files.single.name;
      Uint8List uint8list =
          Uint8List.fromList(File(filepath).readAsBytesSync());
      final ref =
          FirebaseStorage.instance.ref().child("userpictures/$fileName");
      var uploadTask = ref.putData(uint8list);
      final snapshot = await uploadTask.whenComplete(() {});
      var fileLink = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .update({"coverPhoto": fileLink});
      coverPic.value = fileLink;
      Get.back();
    } else {}
  }

  editName({required String newname}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .update({"name": newname});
      name.value = newname;
      Get.back();
    } catch (_) {
      Get.back();
      log("ERROR: (editName) Something went wrong $_");
    }
  }

  editBio({required String newbio}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .update({"bio": newbio});
      bio.value = newbio;
      Get.back();
    } catch (_) {
      Get.back();
      log("ERROR: (editBio) Something went wrong $_");
    }
  }

  editDetails(
      {required String newcontact,
      required String newaddress,
      required List<String> updatedcategories}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .update({
        "address": newaddress,
        "contactno": newcontact,
        "categories": updatedcategories
      });
      contactNo.value = newcontact;
      address.value = newaddress;
      userCategories.assignAll(updatedcategories);
      Get.back();
    } catch (_) {
      Get.back();
      log("ERROR: (editDetails) Something went wrong $_");
    }
  }

  callProvider() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "+63${contactNo.value}",
    );
    await launchUrl(launchUri);
  }

  emailProvider() async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email.value,
    );
    await launchUrl(launchUri);
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
      UsersProfileCommentsBottomSheets.showCommentBottomSheets(
          userid: userid, postid: postID, fcmToken: fcmToken);
    } catch (_) {
      Get.back();
      log("ERROR: (getComments) Something went wrong $_");
    }
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

  likePost({required int index, required bool isLike}) async {
    try {
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var postDocument =
          FirebaseFirestore.instance.collection('post').doc(allPost[index].id);
      postDocument.update({
        'likes': FieldValue.arrayUnion([userid])
      });
      allPost[index].isLike.value = isLike ? false : true;
    } catch (_) {
      log("ERROR: (likePost) Something went wrong $_");
    }
  }

  unlikePost({required int index, required bool isLike}) async {
    try {
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var postDocument =
          FirebaseFirestore.instance.collection('post').doc(allPost[index].id);
      postDocument.update({
        'likes': FieldValue.arrayRemove([userid])
      });
      allPost[index].isLike.value = isLike ? false : true;
    } catch (_) {
      log("ERROR: (unlikePost) Something went wrong $_");
    }
  }

  deletePost({required String postID, required int index}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      allPost.removeAt(index);
      await FirebaseFirestore.instance.collection('post').doc(postID).delete();
      Get.back();
      await getPost();
    } catch (_) {
      log("ERROR: (deletePost) Something went wrong $_");
    }
  }

  editCaption(
      {required String captionID,
      required String caption,
      required bool isShared}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      if (isShared) {
        await FirebaseFirestore.instance
            .collection('post')
            .doc(captionID)
            .update({"textpost": caption});
      } else {
        await FirebaseFirestore.instance
            .collection('post')
            .doc(captionID)
            .update({"originalUserTextPost": caption, "textpost": caption});
      }
      Get.back();
      await getPost();
    } catch (_) {
      log("ERROR: (deletePost) Something went wrong $_");
    }
  }

  reportUser(
      {required String userID,
      required String name,
      required String image,
      required String description,
      required String email}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance.collection('reports').add({
        "userid": userID,
        "name": name,
        "email": email,
        "image": image,
        "description": description,
        "reporterID": Get.find<StorageServices>().storage.read('id'),
        "reporterName": Get.find<StorageServices>().storage.read('name'),
        "reporterImage":
            Get.find<StorageServices>().storage.read('profilePicture'),
        "datecreated": Timestamp.now(),
        "validated": false
      });
      Get.back();
      Get.snackbar("Message", "Successfully reported.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    } catch (_) {
      log("ERROR: (reportUser) Something went wrong $_");
    }
  }

  getFinishedProjects() async {
    try {
      QuerySnapshot<Map<String, dynamic>> res = await FirebaseFirestore.instance
          .collection('bookings')
          .where('providerID', isEqualTo: userid.value)
          .orderBy('datecreated', descending: true)
          .where('accepted', isEqualTo: true)
          .get();

      var projects = res.docs;
      List data = [];
      for (var i = 0; i < projects.length; i++) {
        Map mapdata = projects[i].data();
        if (mapdata['status'] == "Finished") {
          mapdata['id'] = projects[i].id;
          mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
          mapdata['date'] = mapdata['date'].toDate().toString();
          mapdata['time'] = mapdata['time'].toDate().toString();
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

          var providerRatingsAndFeedbackDetails =
              await (mapdata['providerDocRef'] as DocumentReference)
                  .collection('ratings')
                  .where('projectID', isEqualTo: projects[i].id)
                  .where('userid', isEqualTo: clientDetails.id)
                  .get();
          var ratings = providerRatingsAndFeedbackDetails.docs;
          if (ratings.isNotEmpty) {
            mapdata['clientRating'] = ratings[0]['rating'].toString();
          }

          mapdata.remove('clientDocRef');
          mapdata.remove('providerDocRef');
          mapdata.remove('chats');
          data.add(mapdata);
        }
      }

      projectList.assignAll(bookingsFromJson(jsonEncode(data)));
      projectListMasterList.assignAll(bookingsFromJson(jsonEncode(data)));
    } on Exception catch (_) {
      log("ERROR: (getBookings) Something went wrong $_");
    }
  }

  setAnotherUserToView({required String newuserid}) async {
    LoadingDialog.showLoadingDialog();
    selectedContentView.value = "Posts";
    userid.value = newuserid;
    getUserProfile();
    getFinishedProjects();
    Get.back();
  }

  bool isLink({required String text}) {
    final RegExp urlPattern = RegExp(r'^(https?:\/\/)?' // protocol
        r'((([a-zA-Z0-9$-_@.&+!*"(),]|(%[0-9a-fA-F][0-9a-fA-F]))+' // domain name
        r'(\.[a-zA-Z]{2,4}))|localhost)' // domain name or localhost
        r'(:\d+)?' // port number
        r'(\/[a-zA-Z0-9$-_@.&+!*"(),%=]*)*' // path
        r'(\?[a-zA-Z0-9$-_@.&+!*"(),%=]*)?' // query
        r'(#.*)?$' // fragment
        );
    return urlPattern.hasMatch(text);
  }

  Future<void> visitBio({required String url}) async {
    if (isLink(text: url)) {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    } else {
      Get.snackbar("Message", "Bio is not a valid link.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    }
  }

  @override
  void onInit() async {
    userid.value = await Get.arguments['userid'];
    getUserProfile();
    getFinishedProjects();
    getCategories();
    super.onInit();
  }
}
