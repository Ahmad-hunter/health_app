import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static const tableName = 'Reminders';
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'db_Manager.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE IF NOT EXISTS $tableName(id integer primary key autoincrement,'
            ' Reminder_Name TEXT,'
            ' Simi_Reminders TEXT,'
            ' Reminder_Date TEXT,'
            ' Reminder_Type TEXT,'
            ' Reminder_Completed INTEGER)');
      },
      version: 1,
    );
  }

  static Future addReminder(Map<String, Object> data) async {
    final db = await DataBaseHelper.database();
    return db.insert(tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> loadReminders() async {
    final data = await DataBaseHelper.database();
    var result = await data.query(tableName);
    return result;
  }

  static Future<void> deleteReminder(
    String table,
    int id,
  ) async {
    final data = await DataBaseHelper.database();
    await data.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
