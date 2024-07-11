import 'database_helper.dart';

class Answers {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertAnswerData(List<dynamic> answerList) async {
    try {
      final db = await _databaseHelper.database;

      for (var answerData in answerList) {
        final existingAnswer = await db.query(
          'answers',
          where: 'id = ?',
          whereArgs: [answerData['id']],
        );

        var row = {
          'id': answerData['id'],
          'question_id': answerData['question_id'],
          'answer': answerData['answer'],
          'is_correct': answerData['is_correct'] == '1',
          'created_at': answerData['created_at'],
          'updated_at': answerData['updated_at'],
        };

        if (existingAnswer.isEmpty) {
          // Insert new answer
          await db.insert('answers', row);
        } else {
          // Update existing answer
          await db.update(
            'answers',
            row,
            where: 'id = ?',
            whereArgs: [answerData['id']],
          );
        }
      }
    } catch (e) {
      print('Error insert database table answers: $e');
      return null;
    }
  }
}