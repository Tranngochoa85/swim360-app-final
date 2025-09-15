import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:swim360_app/features/course/models/course_model.dart';

class CourseService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<List<Course>> getMyCourses() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception('Chưa đăng nhập');

    final url = Uri.parse('$_baseUrl/courses/my-courses');
    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Lấy danh sách khóa học thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối');
    }
  }
  
  // HÀM MỚI: Tạo một khóa học
  Future<void> createCourse(Map<String, dynamic> courseData) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception('Chưa đăng nhập');

    final url = Uri.parse('$_baseUrl/courses/');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(courseData),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Tạo khóa học thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi tạo khóa học');
    }
  }
}