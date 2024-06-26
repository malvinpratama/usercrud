import '../models/models.dart';

class M20240625Init {
  static const query = [
    '''
      CREATE TABLE ${SettingModel.kTableName} (key TEXT PRIMARY KEY,
      value TEXT)
    ''',
    '''
      INSERT INTO ${SettingModel.kTableName} (key, value) VALUES('first_time', 1)
    ''',
    '''
      CREATE TABLE ${UserModel.kTableName} (id INTEGER PRIMARY KEY,
      first_name TEXT, last_name TEXT, email TEXT, avatar TEXT, job TEXT)
    ''',
  ];
}
