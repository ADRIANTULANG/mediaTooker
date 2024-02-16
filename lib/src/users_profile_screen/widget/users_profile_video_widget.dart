import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mediatooker/services/video_player_fullwidth_service.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';

class UsersProfileVideoWidget extends StatefulWidget {
  const UsersProfileVideoWidget(
      {super.key, required this.url, required this.index});
  final String url;
  final int index;

  @override
  State<UsersProfileVideoWidget> createState() =>
      _UsersProfileVideoWidgetState();
}

class _UsersProfileVideoWidgetState extends State<UsersProfileVideoWidget> {
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
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Stack(
        children: [
          SizedBox(
            height: 30.h,
            width: 100.w,
            child: NativeVideoPlayerView(
              onViewReady: (controller) async {
                vController = controller;
                final videoSource = await VideoSource.init(
                  path: widget.url,
                  type: VideoSourceType.network,
                );
                await controller.loadVideoSource(videoSource);
                listenToController();
                // vController!.play();
              },
            ),
          ),
          Positioned(
            right: 41.w,
            top: 13.h,
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
