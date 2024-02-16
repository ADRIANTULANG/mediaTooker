import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../login_users_and_admin_screen/view/login_users_and_admin_view.dart';
import '../../users_bottomnav_screen/view/users_bottomnav_view.dart';

class SplashViewController extends GetxController {
  navigateTo() async {
    Timer(const Duration(seconds: 4), () async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null && user.emailVerified) {
        String providerID = '';
        String email = '';
        for (var i = 0; i < user.providerData.length; i++) {
          providerID = user.providerData[i].providerId.toString();
          email = user.providerData[i].email.toString();
        }
        String provider = providerID == "password" ? "email" : "gmail";
        var res = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .where("provider", isEqualTo: provider)
            .get();
        if (res.docs.isNotEmpty) {
          if (res.docs[0]['isApprovedByAdmin'] == true) {
            Get.offAll(() => const UsersBottomNavView());
          } else {
            Get.offAll(() => const LoginView());
          }
        } else {
          Get.offAll(() => const LoginView());
        }
      } else {
        Get.offAll(() => const LoginView());
      }
    });
  }

  @override
  void onInit() {
    navigateTo();
    super.onInit();
  }
}
