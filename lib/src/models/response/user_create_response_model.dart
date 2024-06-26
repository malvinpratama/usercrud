// To parse this JSON data, do
//
//     final userCreateResponseModel = userCreateResponseModelFromJson(jsonString);

import 'dart:convert';

UserCreateResponseModel userCreateResponseModelFromJson(String str) =>
    UserCreateResponseModel.fromJson(json.decode(str));

String userCreateResponseModelToJson(UserCreateResponseModel data) =>
    json.encode(data.toJson());

class UserCreateResponseModel {
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  String? job;
  String? id;
  DateTime? createdAt;

  UserCreateResponseModel({
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.job,
    this.id,
    this.createdAt,
  });

  factory UserCreateResponseModel.fromJson(Map<String, dynamic> json) =>
      UserCreateResponseModel(
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        avatar: json['avatar'],
        job: json['job'],
        id: json['id'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
        'job': job,
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
      };
}
