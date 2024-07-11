import 'database_helper.dart';

class ExamResults {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertExamResultData(Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      final existingExamResult = await db.query(
        'exam_results',
        where: 'attempt_id = ?',
        whereArgs: [jsonData['attempt']['id']],
      );

      var status = jsonData['status'] ? 1 : 0;

      var row = {
        'status': status,
        'message': jsonData['message'],
        'attempt_id': jsonData['attempt']['id'],
        'exam_id': jsonData['attempt']['exam_id'],
        'started_at': jsonData['attempt']['started_at'],
        'finished_at': jsonData['attempt']['finished_at'],
        'score': jsonData['attempt']['score'],
        'created_at': jsonData['attempt']['created_at'],
        'updated_at': jsonData['attempt']['updated_at'],
        'deleted_at': jsonData['attempt']['deleted_at'],
        'user_id': jsonData['attempt']['user_id'],
        'password': jsonData['attempt']['password'],
      };

      if (existingExamResult.isEmpty) {
        // memasukkan data baru
        await db.insert('exam_results', row);
      } else {
        // Update data
        await db.update(
          'exam_results',
          row,
          where: 'attempt_id = ?',
          whereArgs: [jsonData['attempt']['id']],
        );
      }
    } catch (e) {
      print('Error insert database table exam_results: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getExamResultData(String attempt_id) async {
    try {
      final db = await _databaseHelper.database;
      // final List<Map<String, dynamic>> result = await db.query('exam_results');

      final existingExamResult = await db.query(
        'exam_results',
        where: 'attempt_id = ?',
        whereArgs: [attempt_id],
      );

      if (existingExamResult.isNotEmpty) {
        final item = existingExamResult.first;
        return {
          'id': item['id'],
          'status': item['status'] == 1,
          'message': item['message'],
          'attempt': {
            'id': item['attempt_id'],
            'exam_id': item['exam_id'],
            'started_at': item['started_at'],
            'finished_at': item['finished_at'],
            'score': item['score'],
            'created_at': item['created_at'],
            'updated_at': item['updated_at'],
            'deleted_at': item['deleted_at'],
            'user_id': item['user_id'],
            'password': item['password'],
          },
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error querying database table exam_results: $e');
      return null;
    }
  }
}