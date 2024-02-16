

import 'dart:convert';
import 'package:get/get.dart';
import 'package:mediatooker/services/getstorage_services.dart';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  String originalUserId;
  DateTime datecreated;
  String type;
  String userId;
  String url;
  String textpost;
  bool isShared;
  List<String> likes;
  String id;
  String name;
  String profilePicture;
  String usertype;
  String sharerId;
  String sharerName;
  String sharerProfilePicture;
  String sharerUsertype;
  String contactno;
  String originalUserTextPost;
  RxBool isPlaying;
  RxBool isLike;
  String userFcmToken;
  String sharerFcmToken;

  Post({
    required this.originalUserId,
    required this.datecreated,
    required this.type,
    required this.userId,
    required this.url,
    required this.isShared,
    required this.likes,
    required this.id,
    required this.textpost,
    required this.name,
    required this.profilePicture,
    required this.usertype,
    required this.sharerId,
    required this.sharerName,
    required this.sharerProfilePicture,
    required this.sharerUsertype,
    required this.contactno,
    required this.originalUserTextPost,
    required this.isPlaying,
    required this.isLike,
    required this.userFcmToken,
    required this.sharerFcmToken,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        originalUserId: json["originalUserID"],
        datecreated: DateTime.parse(json["datecreated"]),
        type: json["type"],
        userId: json["userID"],
        isLike: (json["likes"] as List).contains(
                Get.find<StorageServices>().storage.read('id') ?? "N/A")
            ? true.obs
            : false.obs,
        textpost: json["textpost"],
        url: json["url"],
        isShared: json["isShared"],
        originalUserTextPost: json["originalUserTextPost"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        id: json["id"],
        name: json["name"],
        contactno: json["contactno"],
        profilePicture: json["profilePicture"],
        usertype: json["usertype"],
        sharerId: json["sharerID"],
        sharerName: json["sharerName"],
        sharerProfilePicture: json["sharerProfilePicture"],
        sharerUsertype: json["sharerUsertype"],
        isPlaying: false.obs,
        sharerFcmToken: json["sharerFcmToken"],
        userFcmToken: json["userFcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "originalUserID": originalUserId,
        "originalUserTextPost": originalUserTextPost,
        "datecreated": datecreated.toIso8601String(),
        "type": type,
        "userID": userId,
        "url": url,
        "isLike": isLike,
        "textpost": textpost,
        "isShared": isShared,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "id": id,
        "name": name,
        "contactno": contactno,
        "profilePicture": profilePicture,
        "usertype": usertype,
        "sharerID": sharerId,
        "sharerName": sharerName,
        "sharerProfilePicture": sharerProfilePicture,
        "sharerUsertype": sharerUsertype,
        "isPlaying": isPlaying,
        "sharerFcmToken": sharerFcmToken,
        "userFcmToken": userFcmToken,
      };
}
