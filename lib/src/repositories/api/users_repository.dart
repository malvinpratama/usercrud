import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../../utils/utils.dart';

class UsersRepository {
  UsersRepository(Dio client) : _client = client;
  final Dio _client;

  Future<UserResponseModel> getUserList(int page, int limit) async {
    try {
      return await _client.get(Endpoints.kUsers, queryParameters: {
        'page': page,
        'per_page': limit,
      }).then(
        (response) {
          final result = UserResponseModel.fromJson(response.data);
          return result;
        },
      );
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<List<UserModel>> getSelectedUserList(int page, int limit) async {
    final database = await DatabaseService.database;
    final result = await database.query(UserModel.kTableName,
        limit: limit, offset: (page - 1) * limit);
    return List<UserModel>.from(
      result.map(
        (x) {
          final user = UserModel.fromJson(x);
          return user;
        },
      ),
    );
  }

  Future<int> countSelectedUser() async {
    final database = await DatabaseService.database;
    final count =
        await database.rawQuery('SELECT COUNT(*) FROM ${UserModel.kTableName}');
    return Sqflite.firstIntValue(count)!;
  }

  Future<UserCreateResponseModel> create(Map<String, dynamic> data) async {
    try {
      return await _client.post(Endpoints.kUsers, data: data).then(
        (response) {
          final result = UserCreateResponseModel.fromJson(response.data);
          return result;
        },
      );
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<UserCreateResponseModel> update(
      Map<String, dynamic> data, int id) async {
    try {
      return await _client.put('${Endpoints.kUsers}/$id', data: data).then(
        (response) {
          final result = UserCreateResponseModel.fromJson(response.data);
          return result;
        },
      );
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<int?> delete(int id) async {
    try {
      return await _client
          .delete(
        '${Endpoints.kUsers}/$id',
      )
          .then(
        (response) {
          return response.statusCode;
        },
      );
    } on DioException catch (_) {
      rethrow;
    }
  }
}
