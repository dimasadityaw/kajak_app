import 'database_helper.dart';

class CurrentAnswer {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertCurrentAnswerData(Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      final existingCurrentAnswer = await db.query(
        'current_answer',
        where: 'question_id = ?',
        whereArgs: [jsonData['question']['id']],
      );

      var row = {
        'id': jsonData['current_answer']['id'],
        'question_id': jsonData['question']['id'],
        'answer': jsonData['current_answer']['answer'],
        'is_correct': jsonData['current_answer']['is_correct'] == '1',
        'created_at': jsonData['current_answer']['created_at'],
        'updated_at': jsonData['current_answer']['updated_at'],
      };

      if (existingCurrentAnswer.isEmpty) {
        // memasukkan data baru
        await db.insert('current_answer', row);
      } else {
        // Update data yang sudah ada
        await db.update(
          'current_answer',
          row,
          where: 'question_id = ?',
          whereArgs: [jsonData['question']['id']],
        );
      }
    } catch (e) {
      print('Error insert database table current_answer: $e');
      return null;
    }
  }
}