import 'package:sqflite/sqflite.dart';
import '../../services/services.dart';
import 'transaction_db_model.dart';

class SettingModel {
  static const kTableName = 'setting';

  SettingModel({
    required this.key,
    required this.value,
  });

  final String key;
  final String value;

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        key: json['key'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };

  Future<TransactionDbModel<SettingModel>> save() async {
    try {
      final data = toJson();
      final database = await DatabaseService.database;

      await database.insert(
        SettingModel.kTableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return TransactionDbModel(model: this, isSuccess: true, error: '');
    } catch (e) {
      return TransactionDbModel(
          model: this, isSuccess: false, error: e.toString());
    }
  }
}
