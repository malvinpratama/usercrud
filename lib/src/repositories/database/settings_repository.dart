import 'package:sqflite/sqflite.dart';

import '../../models/models.dart';

class SettingsRepository {
  SettingsRepository(
    Future<Database> database,
  ) : _database = database;

  final Future<Database> _database;

  Future<SettingModel?> getSettingByKey(String key) async {
    final db = await _database;
    return await db.query(SettingModel.kTableName,
        where: 'key = ?', whereArgs: [key]).then(
      (result) {
        if (result.isNotEmpty) {
          final settingModelList = List.from(result.map(
            (x) {
              return SettingModel.fromJson(x);
            },
          ));
          return settingModelList[0];
        }
        return null;
      },
    );
  }
}
