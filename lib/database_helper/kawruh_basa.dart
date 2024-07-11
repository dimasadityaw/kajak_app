import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class KawruhBasa {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertKawruhBasaData(Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      for (final kawruhBasa in jsonData['data']) {
        final existingKawruhBasa = await db.query(
          'kawruh_basa',
          where: 'id = ?',
          whereArgs: [kawruhBasa['id']],
        );

        var row = {
          'id': kawruhBasa['id'],
          'javanese': kawruhBasa['javanese'],
          'aranan': kawruhBasa['aranan'],
          'indonesian': kawruhBasa['indonesian'],
          'image': kawruhBasa['img'],
          'type': kawruhBasa['type'],
          'created_at': kawruhBasa['created_at'],
          'updated_at': kawruhBasa['updated_at'],
          'parent_id': kawruhBasa['parent_id'],
          'is_open': kawruhBasa['is_open'],
        };

        if (existingKawruhBasa.isEmpty) {
          // Masukkan data baru
          await db.insert('kawruh_basa', row);
        } else {
          // Update data yang sudah ada
          await db.update(
            'kawruh_basa',
            row,
            where: 'id = ?',
            whereArgs: [kawruhBasa['id']],
          );
        }
      }
    } catch (e) {
      print('Error insert database table kawruh_basa: $e');
      return null;
    }
  }

  Future<Object> getKawruhBasaData(String type) async {
    try {
      final db = await _databaseHelper.database;

      final existingKawruhBasa = await db.query(
        'kawruh_basa',
        where: 'type = ?',
        whereArgs: [type],
      );

      if (existingKawruhBasa.isNotEmpty) {
        return {
          'data': existingKawruhBasa
              .map((kawruhBasa) => {
            'id': kawruhBasa['id'],
            'javanese': kawruhBasa['javanese'],
            'aranan': kawruhBasa['aranan'],
            'indonesian': kawruhBasa['indonesian'],
            'img': kawruhBasa['image'],
            'type': kawruhBasa['type'],
            'created_at': kawruhBasa['created_at'],
            'updated_at': kawruhBasa['updated_at'],
            'parent_id': kawruhBasa['parent_id'],
            'is_open': kawruhBasa['is_open'] == 1,
          })
              .toList()
        };
      } else {
        return {'data': []};
      }
    } catch (e) {
      print('Error querying database table kawruh_basa: $e');
      return {'data': []};
    }
  }
}