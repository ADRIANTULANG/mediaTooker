import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';
import '../../../services/video_player_fullwidth_service.dart';

class UsersProfileVideoSmallWidget extends StatefulWidget {
  const UsersProfileVideoSmallWidget(
      {super.key, required this.url, required this.index});
  final String url;
  final int index;

  @override
  State<UsersProfileVideoSmallWidget> createState() =>
      _UsersProfileVideoSmallWidgetState();
}

class _UsersProfileVideoSmallWidgetState
    extends State<UsersProfileVideoSmallWidget> {
  NativeVideoPlayerController? vController;
  bool isPlaying = false;

  listenToController() async {
    vController!.onPlaybackEnded.addListener(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          const SizedBox(
              // child: NativeVideoPlayerView(
              //   onViewReady: (controller) async {
              //     vController = controller;
              //     final videoSource = await VideoSource.init(
              //       path: widget.url,
              //       type: VideoSourceType.network,
              //     );

              //     await controller.loadVideoSource(videoSource);
              //     listenToController();
              //     // vController!.play();
              //   },
              // ),
              ),
          Positioned(
            right: 11.w,
            top: 5.h,
            child: GestureDetector(
              onDoubleTap: () {
                Get.to(() => VideoPlayerFullWidthService(url: widget.url));
              },
              onTap: () async {
                if (vController != null) {
                  bool isplaying = await vController!.isPlaying();
                  setState(() {
                    if (isplaying) {
                      isPlaying = false;
                      vController!.pause();
                    } else {
                      isPlaying = true;
                      vController!.play();
                    }
                  });
                }
              },
              child: isPlaying
                  ? Icon(
                      Icons.pause,
                      color: AppColors.light,
                      size: 33.sp,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: AppColors.light,
                      size: 33.sp,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
