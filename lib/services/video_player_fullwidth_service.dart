import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mediatooker/config/app_colors.dart';
import 'package:native_video_player/native_video_player.dart';
import 'package:sizer/sizer.dart';

class VideoPlayerFullWidthService extends StatefulWidget {
  const VideoPlayerFullWidthService({super.key, required this.url});
  final String url;
  @override
  State<VideoPlayerFullWidthService> createState() =>
      _VideoPlayerFullWidthServiceState();
}

class _VideoPlayerFullWidthServiceState
    extends State<VideoPlayerFullWidthService> {
  NativeVideoPlayerController? vController;
  bool isPlaying = false;
  int durationOfVideo = 0;
  int newPosition = 0;
  double position = 0;

  listenToController() async {
    vController!.onPlaybackEnded.addListener(() {
      setState(() {
        isPlaying = false;
      });
    });

    vController!.onPlaybackReady.addListener(() {
      // Emitted when the video loaded successfully and it's ready to play.
      // At this point, videoInfo is available.
      final videoInfo = vController!.videoInfo;
      setState(() {
        durationOfVideo = videoInfo!.duration;
      });
      log(durationOfVideo.toString());
    });

    vController!.onPlaybackPositionChanged.addListener(() {
      setState(() {
        newPosition = vController!.playbackInfo!.position;
        log("NEWPOSITION: ${newPosition.toString()}");
        position = (newPosition / durationOfVideo);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
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
            SizedBox(
              height: 2.h,
            ),
            Slider(
              value: position,
              onChanged: (double value) {
                setState(() {
                  position = value;
                  var percentage = position * 100;
                  var newPositionToSeek = (percentage / 100) * durationOfVideo;
                  int integerPart = newPositionToSeek.ceil();
                  vController!.seekTo(integerPart);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppColors.light,
                  child: IconButton(
                      onPressed: () {
                        vController!.seekBackward(3);
                      },
                      icon: const Icon(Icons.replay_10)),
                ),
                GestureDetector(
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
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppColors.light,
                  child: IconButton(
                      onPressed: () {
                        vController!.seekForward(3);
                      },
                      icon: const Icon(Icons.forward_10)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
