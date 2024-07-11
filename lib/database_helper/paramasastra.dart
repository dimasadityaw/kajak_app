import 'database_helper.dart';

class Paramasastra {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertParamasastraData(List<dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      for (final paramasastra in jsonData) {
        final existingParamasastra = await db.query(
          'paramasastra',
          where: 'id = ?',
          whereArgs: [paramasastra['id']],
        );

        var row = {
          'id': paramasastra['id'],
          'name': paramasastra['name'],
          'description': paramasastra['description'],
          'parent_id': paramasastra['parent_id'],
          'created_at': paramasastra['created_at'],
          'updated_at': paramasastra['updated_at'],
          'is_open': paramasastra['is_open'],
        };

        if (existingParamasastra.isEmpty) {
          // memasukkan data baru
          await db.insert('paramasastra', row);
        } else {
          // Update data
          await db.update(
            'paramasastra',
            row,
            where: 'id = ?',
            whereArgs: [paramasastra['id']],
          );
        }

        if (paramasastra['child'].toString() != '[]') {
          for (final child in paramasastra['child']) {
            final existingChild = await db.query(
              'paramasastra',
              where: 'id = ?',
              whereArgs: [child['id']],
            );

            var rowChild = {
              'id': child['id'],
              'name': child['name'],
              'description': child['description'],
              'parent_id': child['parent_id'],
              'created_at': child['created_at'],
              'updated_at': child['updated_at'],
              'is_open': child['is_open'],
            };

            if (existingChild.isEmpty) {
              // Masukkan data baru
              await db.insert('paramasastra', rowChild);
            } else {
              // Update data yang sudah ada
              await db.update(
                'paramasastra',
                row,
                where: 'id = ?',
                whereArgs: [child['id']],
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error insert database table paramasastra: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getParamasastraData() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> result = [];

      // Fetch parent paramasastra
      final List<Map<String, dynamic>> paramasastra = await db.query('paramasastra');

      for (var paramasastraData in paramasastra) {
        if (paramasastraData['parent_id'].toString() == 'null') {
          final List<Map<String, dynamic>> childParamasastra = await db.query(
            'paramasastra',
            where: 'parent_id = ?',
            whereArgs: [paramasastraData['id']],
          );

          // Create a new map from the existing paramasastraData and add the child entries
          final Map<String, dynamic> paramasastraWithChild =
          Map<String, dynamic>.from(paramasastraData);
          paramasastraWithChild['child'] =
          (childParamasastra.isNotEmpty) ? childParamasastra : [];
          result.add(paramasastraWithChild);
        }
      }

      return result;
    } catch (e) {
      print('Error querying database table paramasastra: $e');
      return [];
    }
  }
}