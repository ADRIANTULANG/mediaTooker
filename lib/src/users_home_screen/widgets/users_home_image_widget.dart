import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/image_fullview.dart';
import 'package:mediatooker/src/users_home_screen/controller/users_home_controller.dart';
import 'package:sizer/sizer.dart';

class UsersHomeImageWidget extends GetView<UsersHomeViewController> {
  const UsersHomeImageWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ImageFullView(imageUrl: controller.postList[index].url));
        },
        child: CachedNetworkImage(
          imageUrl: controller.postList[index].url,
          imageBuilder: (context, imageProvider) => Container(
            height: 30.h,
            width: 100.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
