# SQLite
Banco de dados relacional compativel com MacOS, IOS e Android

## Intalação
`flutter pub add sqflite`, por garantia salvar o pubspec.yaml para aplicar as alterações.
`flutter pub add path`, para gerenciar o path de onde o bd ficará

## uso 
```dart
import 'package:sqflite/sqflite.dart' as SQL;
import 'package:path/path.dart' as path;

class DbUtil {
  final String file;
  final String table;
  final List<String> scheema;
  final int version;

  const DbUtil({
    required this.file,
    required this.table,
    required this.scheema,
    this.version = 1,
  });

  Future<SQL.Database> database(String table) async {
    final dbPath = await SQL.getDatabasesPath();
    return SQL.openDatabase(
      path.join(dbPath, '$file.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE $table (${scheema.join(' ')})');
      },
      onDowngrade: SQL.onDatabaseDowngradeDelete,
      version: version,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database(table);
    return await db.insert(table, data,
        conflictAlgorithm: SQL.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database(table);
    return await db.query(table);
  }

  Future<void> remove(String table, String id) async {
    final db = await database(table);
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
    return getData(table);
  }
}

```