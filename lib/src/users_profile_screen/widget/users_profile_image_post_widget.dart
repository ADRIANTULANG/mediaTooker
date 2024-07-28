import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/image_fullview.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_fontsizes.dart';
import '../controller/users_profile_controller.dart';

class UsersProfileImagePostWidget extends GetView<UsersProfileController> {
  const UsersProfileImagePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Obx(
        () => controller.photoPost.isEmpty
            ? SizedBox(
                height: 20.h,
                width: 100.w,
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    "No available Photos.",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.regular),
                  ),
                )),
              )
            : GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: .5.h,
                    crossAxisSpacing: 1.w),
                itemCount: controller.photoPost.length,
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                    imageUrl: controller.photoPost[index].url,
                    imageBuilder: (context, imageProvider) => GestureDetector(
                      onTap: () {
                        Get.to(() => ImageFullView(
                            imageUrl: controller.photoPost[index].url));
                      },
                      child: Container(
                        height: 10.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                },
              ),
      ),
    );
  }
}
