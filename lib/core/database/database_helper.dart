import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

@module
abstract class DatabaseModule {
  @preResolve
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pantry.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pantry_items (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            expiry_date INTEGER NOT NULL,
            quantity REAL NOT NULL,
            unit TEXT NOT NULL,
            category TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
