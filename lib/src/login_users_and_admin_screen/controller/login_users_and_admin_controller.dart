import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import '../../users_bottomnav_screen/view/users_bottomnav_view.dart';
import '../../users_registration_screen/view/users_registration_basic_info_view.dart';

class LoginViewController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  RxString groupValueType = ''.obs;

  RxString filepath = ''.obs;
  RxString filename = ''.obs;
  File? filePick;

  RxBool showPass = true.obs;

  loginClient() async {
    LoadingDialog.showLoadingDialog();
    try {
      await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      var user = auth.currentUser!;
      if (user.emailVerified) {
        var res = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email.text)
            .where("provider", isEqualTo: "email")
            .get();
        var userdetails = res.docs;
        if (userdetails.isNotEmpty) {
          if (userdetails[0]['isApprovedByAdmin'] == true) {
            Get.back();
            Get.offAll(() => const UsersBottomNavView());
            Get.find<StorageServices>().saveClientCredentials(
                profilePicture: userdetails[0]['profilePhoto'],
                id: userdetails[0].id,
                contactno: userdetails[0]['contactno'],
                email: userdetails[0]['email'],
                name: userdetails[0]['name'],
                type: userdetails[0]['usertype'],
                provider: userdetails[0]['provider']);
          } else {
            Get.back();
            Get.snackbar("Message",
                "Your account has not been validated by the admin. It will take 2 to 3 days to validate your account.",
                duration: const Duration(seconds: 3),
                backgroundColor: AppColors.orange,
                colorText: Colors.white);
            await FirebaseAuth.instance.signOut();
          }
        } else {
          Get.back();
          Get.snackbar("Message", "User did not exist.",
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.orange,
              colorText: Colors.white);
        }
      } else {
        Get.back();
        Get.snackbar("Message",
            "Your account is not yet verified. Please check your email to verify your account.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.orange,
            colorText: Colors.white);
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        Get.back();
        if (e.code == 'invalid-email') {
          Get.snackbar("Message", "Invalid email format",
              backgroundColor: AppColors.orange, colorText: Colors.white);
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          Get.snackbar("Message", "Wrong password",
              backgroundColor: AppColors.orange, colorText: Colors.white);
        } else if (e.code == 'too-many-requests') {
          Get.snackbar("Message",
              "We have blocked all requests from this device due to unusual activity. Try again later",
              backgroundColor: AppColors.orange, colorText: Colors.white);
        } else {
          Get.snackbar("Message", "Login failed with error code: ${e.code}",
              backgroundColor: AppColors.orange, colorText: Colors.white);
        }
      } else {
        Get.back();
        Get.snackbar("Message",
            "Login failed, something went wrong please try again later",
            backgroundColor: AppColors.orange, colorText: Colors.white);
        log(e.toString());
      }
    }
  }

  googleSignin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
        log("null ang access token ug idtoken");
        Get.back();
        await GoogleSignIn().signOut();
      } else {
        LoadingDialog.showLoadingDialog();
        var credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        // print("access token: ${googleAuth?.accessToken}");
        // print("id token: ${googleAuth?.idToken}");
        UserCredential? userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        String? useremail = userCredential.user!.email;
        String userUID = userCredential.user!.uid;
        await checkUser(email: useremail!.toString(), userid: userUID);
      }
    } catch (e) {
      Get.back();
      // Get.snackbar("Message",
      //     "Sign in failed, something went wrong please try again later.",
      //     backgroundColor: AppColors.orange, colorText: Colors.white);
      log(e.toString());
    }
  }

  checkUser({required String email, required String userid}) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where("provider", isEqualTo: "gmail")
          .get();
      if (res.docs.isEmpty) {
        Get.back();
        await GoogleSignIn().signOut();
        Get.to(() => const UsersRegistrationView(), arguments: {
          "provider": "gmail",
          "email": email,
          "useridFromGmail": userid
        });
      } else {
        if (res.docs[0]['isApprovedByAdmin'] == true) {
          Get.back();
          Get.offAll(() => const UsersBottomNavView());
          Get.find<StorageServices>().saveClientCredentials(
              id: res.docs[0].id,
              contactno: res.docs[0]['contactno'],
              email: res.docs[0]['email'],
              name: res.docs[0]['name'],
              profilePicture: res.docs[0]['profilePhoto'],
              type: res.docs[0]['usertype'],
              provider: res.docs[0]['provider']);
        } else {
          Get.back();
          Get.snackbar("Message",
              "Your account is still not validated. Wait for your account to be validated. It will take two to three days to validate your account.",
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.orange,
              colorText: AppColors.light);
          await GoogleSignIn().signOut();
        }
      }
    } catch (e) {
      Get.snackbar("Message", "Something went wrong please try again later.");
    }
  }

  forgotPassword({required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.back();
      Get.snackbar("Message", "Email sent to reset your password. Thank you!",
          backgroundColor: AppColors.light, colorText: AppColors.dark);
    } catch (e) {
      Get.snackbar("Message", "Something went wrong please try again later.",
          backgroundColor: AppColors.light, colorText: AppColors.dark);
    }
  }

  loginAdmin({required String code}) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('admin')
          .where('isActive', isEqualTo: true)
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      var admin = res.docs;
      if (admin.isNotEmpty) {
        // Get.find<StorageServices>().storage.write('usertype', admin[0]['role']);
        // Get.offAll(() => const AdminBottomNavigationView());
      } else {
        Get.snackbar("Message", "Invalid Code",
            backgroundColor: AppColors.orange, colorText: Colors.white);
      }
    } catch (_) {}
  }
}
