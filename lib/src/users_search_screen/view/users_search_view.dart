import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/src/users_profile_screen/view/users_profile_view.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_fontsizes.dart';
import '../controller/users_search_contoller.dart';

class UsersSearchPage extends GetView<UserSearchController> {
  const UsersSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserSearchController());
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
      height: 100.h,
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 7.h,
                  width: 43.w,
                  child: TextField(
                    controller: controller.search,
                    style: TextStyle(fontSize: AppFontSizes.regular),
                    onChanged: (value) {
                      if (controller.debouncer?.isActive ?? false) {
                        controller.debouncer?.cancel();
                      }
                      controller.debouncer =
                          Timer(const Duration(milliseconds: 500), () {
                        controller.searchFunction(keyword: value);
                      });
                    },
                    decoration: InputDecoration(
                        fillColor: AppColors.light,
                        filled: true,
                        alignLabelWithHint: false,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'Search',
                        hintStyle: const TextStyle(fontFamily: 'Bariol')),
                  ),
                ),
                Container(
                  height: 7.h,
                  width: 43.w,
                  decoration: BoxDecoration(
                      color: AppColors.light,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8)),
                  child: Obx(
                    () => DropdownButton<String>(
                      value: controller.selectedCategory.value,
                      padding:
                          EdgeInsets.only(left: 5.w, right: 5.w, top: .5.h),
                      underline: const SizedBox(),
                      elevation: 16,
                      isExpanded: true,
                      onChanged: (String? value) {
                        controller.selectedCategory.value = value!;
                        controller.searchFunction(
                            keyword: controller.search.text);
                      },
                      items: controller.categoriesList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: Obx(
              () => controller.usersList.isEmpty
                  ? SizedBox(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 20.h,
                              width: 100.w,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/logo.png'))),
                            ),
                            Text(
                              "No available users from your search.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.regular),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.usersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => const UsersProfileView(), arguments: {
                              "userid": controller.usersList[index].userid
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: controller
                                              .usersList[index].profilePhoto,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                            radius: 6.w,
                                            backgroundColor: AppColors.dark,
                                            child: CircleAvatar(
                                              radius: 5.5.w,
                                              backgroundImage: imageProvider,
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircleAvatar(
                                            radius: 6.w,
                                            backgroundColor: AppColors.dark,
                                            child: CircleAvatar(
                                              radius: 5.5.w,
                                              backgroundColor: AppColors.light,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            radius: 6.w,
                                            backgroundColor: AppColors.dark,
                                            child: CircleAvatar(
                                              radius: 5.5.w,
                                              backgroundColor: AppColors.light,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.usersList[index].name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: AppFontSizes.regular,
                                              ),
                                            ),
                                            Text(
                                              controller.usersList[index]
                                                          .usertype ==
                                                      "Client"
                                                  ? "Client"
                                                  : controller.usersList[index]
                                                              .accountType ==
                                                          "Group"
                                                      ? "Company/Group"
                                                      : "Freelancer/Individual",
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: AppFontSizes.small,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70.w,
                                              child: Text(
                                                controller.concatType(
                                                    strings: controller
                                                        .usersList[index]
                                                        .categories),
                                                maxLines: 1,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: AppFontSizes.small,
                                                ),
                                              ),
                                            ),
                                            // Row(
                                            //   children: [
                                            //     for (var i = 0;
                                            //         i <
                                            //             controller
                                            //                 .usersList[index]
                                            //                 .categories
                                            //                 .length;
                                            //         i++) ...[
                                            //       Padding(
                                            //         padding: EdgeInsets.only(
                                            //             right: 1.w),
                                            //         child: Text(
                                            //           i ==
                                            //                   (controller
                                            //                           .usersList[
                                            //                               index]
                                            //                           .categories
                                            //                           .length -
                                            //                       1)
                                            //               ? "${controller.usersList[index].categories[i]} "
                                            //               : "${controller.usersList[index].categories[i]},",
                                            //           style: TextStyle(
                                            //             fontWeight:
                                            //                 FontWeight.normal,
                                            //             fontSize:
                                            //                 AppFontSizes.small,
                                            //           ),
                                            //         ),
                                            //       )
                                            //     ]
                                            //   ],
                                            // )
                                            // Text(
                                            //   "${DateFormat.yMMMd().format(controller.usersList[index].datecreated)} ${DateFormat.jm().format(controller.usersList[index].datecreated)}",
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.normal,
                                            //     fontSize: AppFontSizes.small,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    )));
  }
}
