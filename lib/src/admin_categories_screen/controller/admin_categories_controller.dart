import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/services/categories_model.dart';
import 'package:mediatooker/services/loading_dialog.dart';

class AdminCategoriesController extends GetxController {
  RxList<CategoriesModel> categoriesList = <CategoriesModel>[].obs;
  RxList<CategoriesModel> categoriesMasterList = <CategoriesModel>[].obs;

  TextEditingController search = TextEditingController();
  Timer? debouncer;

  getCategories() async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('categories')
          .orderBy('datecreated', descending: true)
          .get();
      var categories = res.docs;
      List tempdata = [];
      for (var i = 0; i < categories.length; i++) {
        Map mapdata = categories[i].data();
        mapdata['id'] = categories[i].id;
        mapdata['datecreated'] = mapdata['datecreated'].toDate().toString();
        tempdata.add(mapdata);
      }
      categoriesList.assignAll(categoriesModelFromJson(jsonEncode(tempdata)));
      categoriesMasterList
          .assignAll(categoriesModelFromJson(jsonEncode(tempdata)));
    } catch (e) {
      log("ERROR: (getCategories) Something went wrong.");
    }
  }

  addCategory({
    required String name,
  }) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('categories')
          .add({"datecreated": DateTime.now(), "name": name});
      Get.back();
      getCategories();
      Get.snackbar("Message", "Successfully added.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);
    } catch (e) {
      log("ERROR: (addCategory) Something went wrong.");
    }
  }

  editCategory(
      {required String docid,
      required String newname,
      required String oldname}) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docid)
          .update({"name": newname});
      Get.back();
      getCategories();
      Get.snackbar("Message", "Successfully edited.",
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.orange,
          colorText: AppColors.light);

      var res = await FirebaseFirestore.instance
          .collection('users')
          .where('usertype', isEqualTo: 'Media Provider')
          .where('categories', arrayContains: oldname)
          .get();
      var providerUsers = res.docs;
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var i = 0; i < providerUsers.length; i++) {
        List userscategoriesList = providerUsers[i]['categories'];
        bool isExist = userscategoriesList.contains(oldname);
        if (isExist) {
          userscategoriesList.remove(oldname);
          userscategoriesList.add(newname);
          batch.update(
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(providerUsers[i].id),
              {'categories': userscategoriesList});
        }
      }
      await batch.commit();
    } catch (e) {
      log("ERROR: (getCategories) Something went wrong.");
    }
  }

  deleteCategory({
    required String docid,
  }) async {
    try {
      Get.back();
      LoadingDialog.showLoadingDialog();
      var res = await FirebaseFirestore.instance
          .collection('categories')
          .doc(docid)
          .get();
      if (res.exists) {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(docid)
            .delete();
        Get.back();
        getCategories();
        Get.snackbar("Message", "Successfully deleted.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
      } else {
        Get.back();
        getCategories();
        Get.snackbar("Message", "Categories no longer exist.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.orange,
            colorText: AppColors.light);
      }
    } catch (e) {
      log("ERROR: (deleteCategory) Something went wrong.");
    }
  }

  searchFunction({required String keyword}) async {
    categoriesList.clear();
    if (keyword.isEmpty) {
      categoriesList.assignAll(categoriesMasterList);
    } else {
      for (var i = 0; i < categoriesMasterList.length; i++) {
        if (categoriesMasterList[i]
            .name
            .toLowerCase()
            .toString()
            .contains(keyword.toLowerCase().toString())) {
          categoriesList.add(categoriesMasterList[i]);
        }
      }
    }
  }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
}
