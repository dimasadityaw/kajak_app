import 'database_helper.dart';

class Questions {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertQuestionData(
      String page, Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      final existingQuestion = await db.query(
        'questions',
        where: 'page = ?',
        whereArgs: [page],
      );

      var row = {
        'page': page,
        'id': jsonData['question']['id'],
        'exam_id': jsonData['question']['exam_id'],
        'question': jsonData['question']['question'],
        'explanation': jsonData['explanation'],
        'created_at': jsonData['question']['created_at'],
        'updated_at': jsonData['question']['updated_at'],
      };

      if (existingQuestion.isEmpty) {
        // memasukkan data baru
        await db.insert('questions', row);
      } else {
        // Update data
        await db.update(
          'questions',
          row,
          where: 'page = ?',
          whereArgs: [page],
        );
      }
    } catch (e) {
      print('Error insert database table questions: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getQuizData(String page) async {
    try {
      final db = await _databaseHelper.database;

      // Fetch the question
      final questionResult = await db.query(
        'questions',
        where: 'page = ?',
        whereArgs: [page],
      );

      if (questionResult.isEmpty) {
        return null; // No question found
      }

      final questionData = questionResult.first;

      // Fetch the answers for this question
      final answerResult = await db.query(
        'answers',
        where: 'question_id = ?',
        whereArgs: [questionData['id']],
      );

      Map<String, dynamic> result = {
        'data': {
          'answer': answerResult
              .map((answer) => {
            'id': answer['id'],
            'question_id': answer['question_id'],
            'answer': answer['answer'],
            'is_correct': answer['is_correct'],
            'created_at': answer['created_at'],
            'updated_at': answer['updated_at'],
          })
              .toList(),
          'question': {
            'id': questionData['id'],
            'exam_id': questionData['exam_id'],
            'question': questionData['question'],
            'created_at': questionData['created_at'],
            'updated_at': questionData['updated_at'],
          },
          'explanation': questionData['explanation'],
        }
      };

      final currentAnswerResult = await db.query(
        'current_answer',
        where: 'question_id = ?',
        whereArgs: [questionData['id']],
      );

      if (currentAnswerResult.isNotEmpty) {
        final currentAnswerData = currentAnswerResult.first;
        result['data']['current_answer'] = {
          'id': currentAnswerData['id'],
          'question_id': currentAnswerData['question_id'],
          'answer': currentAnswerData['answer'],
          'is_correct': currentAnswerData['is_correct'],
          'created_at': currentAnswerData['created_at'],
          'updated_at': currentAnswerData['updated_at'],
        };
      } else {
        result['data']['current_answer'] = null;
      }

      return result;
    } catch (e) {
      print('Error querying database table current_answer: $e');
      return null;
    }
  }
}