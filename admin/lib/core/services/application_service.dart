import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ApplicationService {
  static String get baseUrl => '${dotenv.get('BACKEND_URL', fallback: 'http://localhost:5000/api')}/applications';

  // Updated Cloudinary Settings from user
  static const String cloudinaryCloudName = "dtaruu90e";
  static const String cloudinaryUploadPreset = "Portfolio";

  static Future<String?> uploadToCloudinary(XFile? file) async {
    if (file == null) return null;

    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudinaryCloudName/upload');
      
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = cloudinaryUploadPreset
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          await file.readAsBytes(),
          filename: file.name,
          contentType: MediaType('image', 'jpeg'),
        ));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);
        return json['secure_url'];
      } else {
        print('Cloudinary upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getAllApplications() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch applications');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> submitApplication(Map<String, dynamic> data) async {
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
        throw Exception(error['message'] ?? 'Failed to submit application');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateApplication(String id, Map<String, dynamic> data) async {
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
        throw Exception(error['message'] ?? 'Failed to update application');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteApplication(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete application');
      }
    } catch (e) {
      rethrow;
    }
  }
}
