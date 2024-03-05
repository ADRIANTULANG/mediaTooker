import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/loading_dialog.dart';

import '../../../services/constant_strings.dart';

class UsersRegistrationViewController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController groupname = TextEditingController();
  TextEditingController contactno = TextEditingController();
  TextEditingController address = TextEditingController();

  RxString dropDownValue = 'Client'.obs;
  RxString dropDownValueType = 'Individual'.obs;

  RxString filepath = ''.obs;
  RxString filename = ''.obs;
  File? filePick;
  RxString provider = ''.obs;
  RxString useridFromGmail = ''.obs;

  RxBool showPass = true.obs;

  signUpEmailUser() async {
    LoadingDialog.showLoadingDialog();
    try {
      List<String> signInMethods =
          await auth.fetchSignInMethodsForEmail(email.text);
      if (signInMethods.isNotEmpty) {
        Get.snackbar("Message", "Email already exist",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
      } else {
        await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        var user = auth.currentUser!;
        await user.sendEmailVerification();
        await saveUser(userid: user.uid);
        await FirebaseAuth.instance.signOut();
        Get.back();
        Get.back();
        Get.back();
        Get.snackbar("Message",
            "Account created. We have sent an email to verify your account.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
      }
    } catch (e) {
      Get.snackbar("Message", "Something went wrong please try again later",
          backgroundColor: AppColors.orange, colorText: AppColors.dark);
    }
  }

  signUpGmailUser() async {
    LoadingDialog.showLoadingDialog();
    try {
      await saveUser(userid: useridFromGmail.value);
      Get.back();
      Get.back();
      Get.back();
      Get.snackbar("Message",
          "Account created. We will validate your account. It will take 2 to 3 days to validate your account.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    } catch (e) {
      Get.snackbar("Message", "Something went wrong please try again later",
          backgroundColor: AppColors.orange, colorText: AppColors.dark);
    }
  }

  saveUser({required String userid}) async {
    try {
      // UPLOAD TO STORAGE FIRST
      Uint8List uint8list =
          Uint8List.fromList(File(filepath.value).readAsBytesSync());

      final ref = FirebaseStorage.instance
          .ref()
          .child("userdocuments/${filename.value}");
      var uploadTask = ref.putData(uint8list);
      final snapshot = await uploadTask.whenComplete(() {});
      var documentLink = await snapshot.ref.getDownloadURL();
      // END UPLOAD STORAGE
      var userdoc = FirebaseFirestore.instance.collection('users').doc(userid);
      userdoc.set({
        "userid": userid,
        "email": email.text,
        "isApprovedByAdmin": false,
        "provider": provider.value,
        "usertype": dropDownValue.value,
        "profilePhoto": defaultImage,
        "coverPhoto": defaultCover,
        "name": name.text,
        "contactno": contactno.text,
        "fcmToken": "",
        "documentLink": documentLink,
        "address": address.text,
        "isOnline": false,
        "status": "Pending",
        "datecreated": Timestamp.now(),
        "accountType":
            dropDownValue.value == "Client" ? "" : dropDownValueType.value,
        "bio": "",
        "restricted": false
      });
    } catch (e) {
      Get.snackbar(
          "Message", "Something went wrong please try again later. $e");
    }
  }

  getFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowedExtensions: [
      'pdf',
    ], type: FileType.custom);
    if (result != null) {
      filepath.value = result.files.single.path!;
      filename.value = result.files.single.name;
      filePick = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
  }

  @override
  void onInit() async {
    provider.value = await Get.arguments['provider'];
    email.text = await Get.arguments['email'];
    useridFromGmail.value = await Get.arguments['useridFromGmail'];
    super.onInit();
  }
}
