import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediatooker/src/users_home_screen/controller/users_home_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

import '../../../services/loading_dialog.dart';

class UserCreatePostController extends GetxController {
  RxString filepath = ''.obs;
  RxString fileName = ''.obs;
  RxString extension = ''.obs;
  RxBool isWithFile = false.obs;
  RxBool isPlaying = false.obs;
  RxBool isPublic = true.obs;
  final ImagePicker picker = ImagePicker();
  TextEditingController textPost = TextEditingController();

  File? pickedile;

  @override
  void onInit() async {
    filepath.value = await Get.arguments['filepath'];
    fileName.value = await Get.arguments['fileName'];
    extension.value = await Get.arguments['extension'];
    log(extension.value.toString());
    pickedile = File(filepath.value);
    isWithFile.value = extension.value == "" ? false : true;

    super.onInit();
  }

  openCamera() async {
    LoadingDialog.showLoadingDialog();
    var result = await picker.pickImage(source: ImageSource.camera);
    if (result != null) {
      filepath.value = result.path;
      fileName.value = filepath.value.split('/').last;
      extension.value = fileName.value.split('.')[1];
      pickedile = File(filepath.value);
      isWithFile.value = extension.value == "" ? false : true;
    }
    Get.back();
  }

  pickFile() async {
    LoadingDialog.showLoadingDialog();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: [
      'jpg',
      'png',
      'jpeg',
      'svg',
      'bmp',
      'mp4',
      'gif',
      'mkv',
      'avi',
      'mpeg',
      'mpg',
      'm4v',
      'ts',
      'm4v',
    ]);
    if (result != null) {
      Get.back();
      filepath.value = result.files.single.path!;
      fileName.value = result.files.single.name;
      extension.value = result.files.single.extension!;
      pickedile = File(filepath.value);
      isWithFile.value = extension.value == "" ? false : true;
    } else {
      Get.back();
    }
  }

  clearAll() async {
    filepath.value = '';
    fileName.value = '';
    extension.value = '';
    isWithFile.value = false;
    isPlaying.value = false;
  }

  createPost() async {
    try {
      LoadingDialog.showLoadingDialog();
      String type = '';
      String fileLink = '';
      if (isWithFile.value) {
        if (['jpg', 'png', 'jpeg', 'svg', 'bmp'].contains(extension.value)) {
          type = 'image';
        } else {
          type = 'video';
        }
        // COMPRESSED FILE IF VIDEO
        if (type == "video") {
          MediaInfo? mediaInfo = await VideoCompress.compressVideo(
            filepath.value,
            quality: VideoQuality.Res640x480Quality,
            deleteOrigin: false, // It's false by default
          );
          File? compressedVideo = mediaInfo!.file;
          // filepath.value = compressedVideo!.path;
          String inputPath = compressedVideo!.path;

          final Directory tempDir = await getTemporaryDirectory();
          String outputPath = '${tempDir.path}/compressedvideo.mp4';
          log("$outputPath path directory");
          String command =
              '-y -i $inputPath -vcodec libx264 -crf 22 $outputPath';

          // String command = '-y -i $inputPath -c:v libx264 -crf 24 $outputPath';
          FFmpegKit.execute(command).then((session) async {
            final returnCode = await session.getReturnCode();

            if (ReturnCode.isSuccess(returnCode)) {
              filepath.value = outputPath;
              log("SUCCESS COMPRESSED");
            } else if (ReturnCode.isCancel(returnCode)) {
              // CANCEL
              log("CANCEL COMPRESSED");
            } else {
              // ERROR
              String message = '';
              FFmpegKitConfig.enableLogCallback((log) {
                message = log.getMessage();
                print("${message}mao ni error");
              });
              log(message);
              filepath.value = outputPath;
            }
          });
        }
        Uint8List uint8list =
            Uint8List.fromList(File(filepath.value).readAsBytesSync());
        final ref =
            FirebaseStorage.instance.ref().child("post/${fileName.value}");

        var uploadTask =
            type == 'image' ? ref.putData(uint8list) : ref.putFile(pickedile!);
        final snapshot = await uploadTask.whenComplete(() {});
        fileLink = await snapshot.ref.getDownloadURL();
      } else {
        type = 'text';
      }
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var docref = FirebaseFirestore.instance.collection('users').doc(userid);
      await FirebaseFirestore.instance.collection('post').add({
        "userdocref": docref,
        "userID": userid,
        "type": type,
        "url": fileLink,
        "textpost": textPost.text,
        "likes": [],
        "datecreated": Timestamp.now(),
        "isShared": false,
        "originalUserDocRef": docref,
        "originalUserID": userid,
        "originalUserTextPost": textPost.text,
      });
      Get.back();
      Get.back();
      Get.find<UsersHomeViewController>().getPost();
    } catch (_) {
      log("ERROR: Something went wrong $_");
    }
  }
}
