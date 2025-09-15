import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:swim360_app/features/learning_request/models/learning_request_model.dart';

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

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Tạo yêu cầu thất bại');
      }
    } catch (e) {
      throw Exception('Không thể gửi yêu cầu. Vui lòng thử lại.');
    }
  }

  Future<List<LearningRequest>> discoverRequests() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực.');
    }

    final url = Uri.parse('$_baseUrl/learning-requests/discover');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LearningRequest.fromJson(json)).toList();
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Lấy danh sách yêu cầu thất bại');
      }
    } catch (e) {
      throw Exception('Không thể kết nối. Vui lòng thử lại.');
    }
  }

  Future<List<LearningRequest>> getMyRequests() async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception('Chưa đăng nhập');

    final url = Uri.parse('$_baseUrl/learning-requests/my-requests');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LearningRequest.fromJson(json)).toList();
      } else {
        throw Exception('Lấy danh sách yêu cầu của bạn thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy yêu cầu');
    }
  }
}