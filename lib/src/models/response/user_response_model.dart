import '../models.dart';
// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

UserResponseModel userResponseModelFromJson(String str) => UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) => json.encode(data.toJson());

class UserResponseModel {
    int? page;
    int? perPage;
    int? total;
    int? totalPages;
    List<UserModel>? user;
    SupportModel? support;

    UserResponseModel({
        this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.user,
        this.support,
    });

    factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
        page: json['page'],
        perPage: json['per_page'],
        total: json['total'],
        totalPages: json['total_pages'],
        user: json['data'] == null ? [] : List<UserModel>.from(json['data']!.map((x) => UserModel.fromJson(x))),
        support: json['support'] == null ? null : SupportModel.fromJson(json['support']),
    );

    Map<String, dynamic> toJson() => {
        'page': page,
        'per_page': perPage,
        'total': total,
        'total_pages': totalPages,
        'user': user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
        'support': support?.toJson(),
    };
}

