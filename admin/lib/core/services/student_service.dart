import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StudentService {
  static String get baseUrl => '${dotenv.get('BACKEND_URL', fallback: 'http://localhost:5000/api')}/students';

  static Future<List<dynamic>> getAllStudents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> getLibraryMembers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/library/members'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> getStudentByRollNo(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/roll/$studentId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Student not found with Roll No: $studentId');
  }

  static Future<Map<String, dynamic>> createStudent(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to create student');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateStudent(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to update student');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteStudent(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete student');
      }
    } catch (e) {
      rethrow;
    }
  }
}
