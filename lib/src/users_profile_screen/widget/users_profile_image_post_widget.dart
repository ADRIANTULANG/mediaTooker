import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/image_fullview.dart';
import 'package:sizer/sizer.dart';
import '../controller/users_profile_controller.dart';

class UsersProfileImagePostWidget extends GetView<UsersProfileController> {
  const UsersProfileImagePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Obx(
        () => GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: .5.h, crossAxisSpacing: 1.w),
          itemCount: controller.photoPost.length,
          itemBuilder: (BuildContext context, int index) {
            return CachedNetworkImage(
              imageUrl: controller.allPost[index].url,
              imageBuilder: (context, imageProvider) => GestureDetector(
                onTap: () {
                  Get.to(() =>
                      ImageFullView(imageUrl: controller.allPost[index].url));
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          },
        ),
      ),
    );
  }
}
