import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/constant_strings.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/post_model.dart';

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

  RxList<Post> allPost = <Post>[].obs;
  RxList<Post> mediaPost = <Post>[].obs;

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
      mediaPost.assignAll(postFromJson(jsonEncode(dataForMediaOnly)));
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

  editDetails({required String newcontact, required String newaddress}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .update({"address": newaddress, "contactno": newcontact});
      contactNo.value = newcontact;
      address.value = newaddress;
      Get.back();
    } catch (_) {
      Get.back();
      log("ERROR: (editDetails) Something went wrong $_");
    }
  }

  rateUser({required double userrating}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      var res = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid.value)
          .collection('ratings')
          .where('userid',
              isEqualTo: Get.find<StorageServices>().storage.read('id'))
          .get();
      if (res.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userid.value)
            .collection('ratings')
            .doc(res.docs[0].id)
            .update({"rating": userrating});
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userid.value)
            .collection('ratings')
            .add({
          "userid": Get.find<StorageServices>().storage.read('id'),
          "rating": userrating
        });
      }
      Get.back();
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
    } catch (_) {}
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

  @override
  void onInit() async {
    userid.value = await Get.arguments['userid'];
    getUserProfile();

    super.onInit();
  }
}
