import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/loading_dialog.dart';
import 'package:mediatooker/src/admin_bottom_nav_screen/view/admin_bottom_nav_view.dart';

import '../../../config/app_colors.dart';

class AdminPassCodeController extends GetxController {
  checkAdminAccount({required String code}) async {
    LoadingDialog.showLoadingDialog();
    try {
      var res = await FirebaseFirestore.instance
          .collection('admin')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      var admin = res.docs;
      Get.back();
      if (admin.isNotEmpty) {
        var admindetails = admin[0].data();
        if (admindetails['active'] == true) {
          Get.offAll(() => const AdminBottomNavView(),
              arguments: {"adminName": admindetails['name']});
        } else {
          Get.snackbar(
              "Message", "This admin account is not active. Thank you.",
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.orange,
              colorText: AppColors.light);
        }
      } else {}
    } catch (_) {
      Get.back();

      log("ERROR: (checkAdminAccount) Something went wrong $_");
    }
  }
}
