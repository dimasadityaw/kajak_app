import 'database_helper.dart';

class Parikan {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertParikanData(Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      for (final parikan in jsonData['data']) {
        final existingParikan = await db.query(
          'parikan',
          where: 'id = ?',
          whereArgs: [parikan['id']],
        );

        var row = {
          'id': parikan['id'],
          'parikan': parikan['parikan'],
          'meaning_in_java': parikan['meaning_in_java'],
          'meaning_in_indo': parikan['meaning_in_indo'],
          'created_at': parikan['created_at'],
          'updated_at': parikan['updated_at'],
        };

        if (existingParikan.isEmpty) {
          // memasukkan data baru
          await db.insert('parikan', row);
        } else {
          // Update data
          await db.update(
            'parikan',
            row,
            where: 'id = ?',
            whereArgs: [parikan['id']],
          );
        }
      }
    } catch (e) {
      print('Error insert database table parikan: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getParikanData() async {
    try {
      final db = await _databaseHelper.database;

      final existingParikan = await db.query(
        'parikan',
      );

      if (existingParikan.isNotEmpty) {
        return {
          'data': existingParikan
              .map((parikan) => {
            'id': parikan['id'],
            'parikan': parikan['parikan'],
            'meaning_in_java': parikan['meaning_in_java'],
            'meaning_in_indo': parikan['meaning_in_indo'],
            'created_at': parikan['created_at'],
            'updated_at': parikan['updated_at'],
          })
              .toList()
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error querying database table parikan: $e');
      return null;
    }
  }
}