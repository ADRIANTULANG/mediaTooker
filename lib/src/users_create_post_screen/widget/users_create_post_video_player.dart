import 'package:flutter/material.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:sizer/sizer.dart';
import '../../../config/app_colors.dart';

class UsersCreatePostVideoWidget extends StatefulWidget {
  const UsersCreatePostVideoWidget({
    super.key,
    required this.path,
  });
  final String path;

  @override
  State<UsersCreatePostVideoWidget> createState() =>
      _UsersCreatePostVideoWidgetState();
}

class _UsersCreatePostVideoWidgetState
    extends State<UsersCreatePostVideoWidget> {
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
    return Stack(
      children: [
        SizedBox(
          height: 43.h,
          width: 100.w,
          child: NativeVideoPlayerView(
            onViewReady: (controller) async {
              vController = controller;
              final videoSource = await VideoSource.init(
                path: widget.path,
                type: VideoSourceType.file,
              );

              await controller.loadVideoSource(videoSource);
              listenToController();
              // vController!.play();
            },
          ),
        ),
        Positioned(
          right: 38.w,
          top: 18.h,
          child: GestureDetector(
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
                    size: 43.sp,
                  )
                : Icon(
                    Icons.play_arrow,
                    color: AppColors.light,
                    size: 43.sp,
                  ),
          ),
        )
      ],
    );
  }
}
