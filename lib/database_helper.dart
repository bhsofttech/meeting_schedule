// 

import 'package:meeting_schedule/meeting.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:timezone/timezone.dart' as tz;

class DatabaseHelper {
  static Database? _database;
  static const String _tableName = 'meetings';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'meetings_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            startTime TEXT NOT NULL,
            endTime TEXT NOT NULL,
            participants TEXT,
            location TEXT,
            isAllDay INTEGER DEFAULT 0,
            color INTEGER,
            isCompleted INTEGER DEFAULT 0,
            reminderMinutes INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> insertMeeting(Meeting meeting) async {
    final db = await database;
    return await db.insert(_tableName, meeting.toMap());
  }

  Future<List<Meeting>> getAllMeetings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Meeting.fromMap(maps[i]);
    });
  }

  Future<List<Meeting>> getMeetingsByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'startTime >= ? AND startTime < ?',
      whereArgs: [
        startOfDay.toUtc().toIso8601String(),
        endOfDay.toUtc().toIso8601String()
      ],
    );
    return List.generate(maps.length, (i) {
      return Meeting.fromMap(maps[i]);
    });
  }

  Future<int> updateMeeting(Meeting meeting) async {
    final db = await database;
    return await db.update(
      _tableName,
      meeting.toMap(),
      where: 'id = ?',
      whereArgs: [meeting.id],
    );
  }

  Future<int> deleteMeeting(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}