import 'database_helper.dart';

class Tembang {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertTembangData(List<dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      for (final tembang in jsonData) {
        final existingTembang = await db.query(
          'tembang',
          where: 'id = ?',
          whereArgs: [tembang['id']],
        );

        var row = {
          'id': tembang['id'],
          'name': tembang['name'],
          'subtitle': tembang['subtitle'],
          'image': tembang['image'],
          'description': tembang['description'],
          'parent_id': tembang['parent_id'],
          'created_at': tembang['created_at'],
          'updated_at': tembang['updated_at'],
        };

        if (existingTembang.isEmpty) {
          // memasukkan data baru
          await db.insert('tembang', row);
        } else {
          // Update data
          await db.update(
            'tembang',
            row,
            where: 'id = ?',
            whereArgs: [tembang['id']],
          );
        }

        if (tembang['child'].toString() != '[]') {
          for (final child in tembang['child']) {
            final existingChild = await db.query(
              'tembang',
              where: 'id = ?',
              whereArgs: [child['id']],
            );

            var rowChild = {
              'id': child['id'],
              'name': child['name'],
              'subtitle': child['subtitle'],
              'image': child['image'],
              'description': child['description'],
              'parent_id': child['parent_id'],
              'created_at': child['created_at'],
              'updated_at': child['updated_at'],
            };

            if (existingChild.isEmpty) {
              // Masukkan data baru
              await db.insert('tembang', rowChild);
            } else {
              // Update data yang sudah ada
              await db.update(
                'tembang',
                row,
                where: 'id = ?',
                whereArgs: [child['id']],
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error insert database table tembang: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getTembangData() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> result = [];

      // Fetch parent tembang
      final List<Map<String, dynamic>> tembang = await db.query('tembang');

      for (var tembangData in tembang) {
        if (tembangData['parent_id'].toString() == 'null') {
          final List<Map<String, dynamic>> childTembang = await db.query(
            'tembang',
            where: 'parent_id = ?',
            whereArgs: [tembangData['id']],
          );

          // Create a new map from the existing tembangData and add the child entries
          final Map<String, dynamic> tembangWithChild =
          Map<String, dynamic>.from(tembangData);
          tembangWithChild['child'] =
          (childTembang.isNotEmpty) ? childTembang : [];
          result.add(tembangWithChild);
        }
      }

      return result;
    } catch (e) {
      print('Error querying database table tembang: $e');
      return [];
    }
  }
}