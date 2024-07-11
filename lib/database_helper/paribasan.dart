import 'database_helper.dart';

class Paribasan {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertParibasanData(Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      for (final paribasan in jsonData['data']) {
        final existingParibasan = await db.query(
          'paribasan',
          where: 'id = ?',
          whereArgs: [paribasan['id']],
        );

        var row = {
          'id': paribasan['id'],
          'paribasan': paribasan['paribasan'],
          'meaning_in_java': paribasan['meaning_in_java'],
          'meaning_in_indo': paribasan['meaning_in_indo'],
          'created_at': paribasan['created_at'],
          'updated_at': paribasan['updated_at'],
        };

        if (existingParibasan.isEmpty) {
          // memasukkan data baru
          await db.insert('paribasan', row);
        } else {
          // Update data
          await db.update(
            'paribasan',
            row,
            where: 'id = ?',
            whereArgs: [paribasan['id']],
          );
        }
      }
    } catch (e) {
      print('Error insert database table paribasan: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getParibasanData() async {
    try {
      final db = await _databaseHelper.database;

      final existingParibasan = await db.query(
        'paribasan',
      );

      if (existingParibasan.isNotEmpty) {
        return {
          'data': existingParibasan
              .map((paribasan) => {
            'id': paribasan['id'],
            'paribasan': paribasan['paribasan'],
            'meaning_in_java': paribasan['meaning_in_java'],
            'meaning_in_indo': paribasan['meaning_in_indo'],
            'created_at': paribasan['created_at'],
            'updated_at': paribasan['updated_at'],
          })
              .toList()
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error querying database table paribasan: $e');
      return null;
    }
  }
}