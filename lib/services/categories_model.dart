// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<CategoriesModel> categoriesModelFromJson(String str) =>
    List<CategoriesModel>.from(
        json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  String name;
  DateTime datecreated;
  String id;
  RxBool isSelected;

  CategoriesModel({
    required this.name,
    required this.datecreated,
    required this.id,
    required this.isSelected,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        name: json["name"],
        datecreated: DateTime.parse(json["datecreated"]),
        id: json["id"],
        isSelected: false.obs,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "datecreated": datecreated.toIso8601String(),
        "id": id,
      };
}
