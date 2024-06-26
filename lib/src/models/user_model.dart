import 'package:sqflite/sqflite.dart';

import '../services/services.dart';
import 'models.dart';

class UserModel {
  static const kTableName = 'selected_users';

  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  String? job;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.job,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        avatar: json['avatar'],
        job: json['job'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'avatar': avatar,
        'job': job,
      };

  Future<TransactionDbModel<UserModel>> save() async {
    try {
      final data = toJson();
      final database = await DatabaseService.database;

      await database.insert(
        UserModel.kTableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return TransactionDbModel(model: this, isSuccess: true, error: '');
    } catch (e) {
      return TransactionDbModel(
          model: this, isSuccess: false, error: e.toString());
    }
  }

  Future<TransactionDbModel<UserModel>> delete() async {
    try {
      final database = await DatabaseService.database;
      await database
          .delete(UserModel.kTableName, where: "id = ?", whereArgs: [id]);
      return TransactionDbModel(model: this, isSuccess: true, error: '');
    } catch (e) {
      return TransactionDbModel(
          model: this, isSuccess: false, error: e.toString());
    }
  }
}
