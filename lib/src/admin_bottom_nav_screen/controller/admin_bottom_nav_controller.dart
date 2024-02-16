import 'package:get/get.dart';

import '../../admin_approval_screen/view/admin_approval_view.dart';
import '../../admin_users_list_screen/view/admin_users_view.dart';

class AdminBottomNavController extends GetxController {
  RxInt currentSelectedIndex = 0.obs;

  List screens = [
    const AdminApprovalView(),
    const AdminUsersListView(),
  ];

  RxString adminName = ''.obs;

  @override
  void onInit() async {
    adminName.value = await Get.arguments['adminName'];
    super.onInit();
  }
}
