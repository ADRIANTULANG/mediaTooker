import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:mediatooker/config/app_fontsizes.dart';
import 'package:mediatooker/services/getstorage_services.dart';
import 'package:sizer/sizer.dart';

import '../controller/users_chat_controller.dart';

class UsersChatView extends GetView<UsersChatController> {
  const UsersChatView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UsersChatController());
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 12.w,
        titleSpacing: 1,
        leading: GestureDetector(
          onTap: () {
            controller.navigateBack();
          },
          child: const Icon(Icons.arrow_back),
        ),
        foregroundColor: AppColors.orange,
        backgroundColor: Colors.white,
        title: SizedBox(
          child: Row(
            children: [
              Obx(
                () => CachedNetworkImage(
                  imageUrl: controller.profilePic.value,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 5.5.w,
                    backgroundColor: AppColors.dark,
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundImage: imageProvider,
                    ),
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    radius: 5.5.w,
                    backgroundColor: AppColors.dark,
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundColor: AppColors.light,
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 5.5.w,
                    backgroundColor: AppColors.dark,
                    child: CircleAvatar(
                      radius: 5.w,
                      backgroundColor: AppColors.light,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Text(
                      controller.username.value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: AppFontSizes.regular),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(
                        () => CircleAvatar(
                          radius: 1.w,
                          backgroundColor: controller.isUserOnline.value
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Obx(
                        () => Text(
                          controller.isUserOnline.value ? "online" : "offline",
                          style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () => controller.navigateBack(),
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: controller.chatList.length,
                      shrinkWrap: true,
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 14,
                                top: 10,
                              ),
                              child: controller.chatList[index].type == "text"
                                  ? Align(
                                      alignment:
                                          (controller.chatList[index].sender !=
                                                  Get.find<StorageServices>()
                                                      .storage
                                                      .read('id')
                                              ? Alignment.topLeft
                                              : Alignment.topRight),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: (controller
                                                      .chatList[index].sender !=
                                                  Get.find<StorageServices>()
                                                      .storage
                                                      .read('id')
                                              ? AppColors.light
                                              : AppColors.orange),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                          controller.chatList[index].chats,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment:
                                          (controller.chatList[index].sender !=
                                                  Get.find<StorageServices>()
                                                      .storage
                                                      .read('id')
                                              ? Alignment.topLeft
                                              : Alignment.topRight),
                                      child: Container(
                                        height: 30.h,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(controller
                                                    .chatList[index].url))),
                                        padding: const EdgeInsets.all(16),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 7.w,
                                right: 7.w,
                              ),
                              child: Align(
                                  alignment:
                                      (controller.chatList[index].sender !=
                                              Get.find<StorageServices>()
                                                  .storage
                                                  .read('id')
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: Text(
                                    "${DateFormat('yMMMd').format(controller.chatList[index].datecreated)} ${DateFormat('jm').format(controller.chatList[index].datecreated)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey,
                                        fontSize: 9.sp),
                                  )),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 10.h,
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 3,
                      offset: Offset(1, 2))
                ]),
                padding: EdgeInsets.only(bottom: 2.h, left: 3.w, right: 3.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 6.h,
                      width: 70.w,
                      child: TextField(
                        controller: controller.message,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(left: 3.w),
                            alignLabelWithHint: false,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            hintText: 'Type something..'),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          controller.sendImage();
                          if (controller.isUserOnline.value == false) {
                            controller.sendNotification(
                              fmcToken: controller.fcmToken.value,
                              userid: controller.userid.value,
                            );
                          }
                        },
                        child: const Icon(Icons.attachment)),
                    InkWell(
                        onTap: () {
                          controller.sendMessage(
                              messagetosend: controller.message.text);
                          if (controller.isUserOnline.value == false) {
                            controller.sendNotification(
                              fmcToken: controller.fcmToken.value,
                              userid: controller.userid.value,
                            );
                          }
                        },
                        child: const Icon(Icons.send))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
