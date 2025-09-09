import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LearningRequestService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<void> createRequest(Map<String, dynamic> requestData) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực.');
    }

    final url = Uri.parse('$_baseUrl/learning-requests/');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Tạo yêu cầu thất bại');
      }
      
      // print('Yêu cầu học bơi đã được tạo thành công!');

    } catch (e) {
      // print('Lỗi khi tạo yêu cầu học bơi: $e');
      throw Exception('Không thể gửi yêu cầu. Vui lòng thử lại.');
    }
  }
}