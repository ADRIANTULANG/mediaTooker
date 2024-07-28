import 'package:get/get.dart';
import 'package:mediatooker/src/admin_categories_screen/view/admin_categories_view.dart';
import 'package:mediatooker/src/admin_income_screen/view/admin_income_view.dart';

import '../../admin_approval_screen/view/admin_approval_view.dart';
import '../../admin_reports_screen/view/admin_reports_view.dart';
import '../../admin_users_list_screen/view/admin_users_view.dart';

class AdminBottomNavController extends GetxController {
  RxInt currentSelectedIndex = 0.obs;

  List screens = [
    const AdminApprovalView(),
    const AdminReportsView(),
    const AdminUsersListView(),
    const AdminIncomeView(),
    const AdminCategoriesView(),
  ];

  RxString adminName = ''.obs;

  @override
  void onInit() async {
    adminName.value = await Get.arguments['adminName'];
    super.onInit();
  }
}
