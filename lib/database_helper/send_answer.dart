import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'database_helper.dart';
import 'package:http/http.dart' as http;

class SendAnswer {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> insertSendAnswer(Map<String, dynamic> jsonData) async {
    try {
      final db = await _databaseHelper.database;

      final existingSendAnswer = await db.query(
        'send_answer',
        where: 'question_id = ?',
        whereArgs: [jsonData['question_id']],
      );

      var row = {
        'question_id': jsonData['question_id'],
        'answer_id': jsonData['answer_id'],
        'attempt_id': jsonData['attempt_id'],
        'is_send': jsonData['is_send'],
      };

      if (existingSendAnswer.isEmpty) {
        // memasukkan data baru
        await db.insert('send_answer', row);
      } else {
        // Update data
        await db.update(
          'send_answer',
          row,
          where: 'question_id = ?',
          whereArgs: [jsonData['question_id']],
        );
      }
    } catch (e) {
      print('Error insert database table send_answer: $e');
      return null;
    }
  }

  Future checkSendAnswer() async {
    try {
      final db = await _databaseHelper.database;

      SharedPreferences pref = await SharedPreferences.getInstance();
      var user = json.decode(pref.getString("user")!);
      String token = user['token'];
      String attempt_id = user['attempt']['id'].toString();

      final existingSendAnswer = await db.query(
        'send_answer',
        where: 'attempt_id = ?',
        whereArgs: [attempt_id],
      );

      if (existingSendAnswer.isNotEmpty) {
        existingSendAnswer.forEach((item) async {
          // Iterate through each item
          if (item['is_send'] == 0) {
            // Check if is_send is 0
            var apiResult = await http.post(
              Uri.parse(
                  '${const String.fromEnvironment('apiUrl')}/exam/$attempt_id/question'),
              body: {
                'question_id': item['question_id'].toString(),
                'answer_id': item['answer_id'].toString(),
                'attempt_id': item['attempt_id'].toString(),
              },
              headers: {
                "Accept": "Application/json",
                "Authorization": "Bearer $token"
              },
            );

            if (apiResult.statusCode == 200) {
              // Success: Update is_send to 1 in local database
              await db.update(
                'send_answer',
                {'is_send': 1},
                where: 'id = ?',
                whereArgs: [item['id']],
              );
            }
          }
        });
      }
    } catch (e) {
      // print('Error in checkSendAnswer: $e');
    }
  }

  Future hasBeenAnswered() async {
    try {
      final db = await _databaseHelper.database;

      SharedPreferences pref = await SharedPreferences.getInstance();
      var user = json.decode(pref.getString("user")!);
      String attempt_id = user['attempt']['id'].toString();

      final existingSendAnswer = await db.query(
        'send_answer',
        where: 'attempt_id = ? AND is_send = ?',
        whereArgs: [attempt_id, 1],
      );

      if (existingSendAnswer.isNotEmpty) {
        return {
          'data': {'answer': existingSendAnswer}
        };
      } else {
        return null;
      }
    } catch (e) {
      // print('Error in checkSendAnswer: $e');
    }
  }
}