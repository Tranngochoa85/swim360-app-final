// KIỂM TRA #1: Đảm bảo các dòng import này chính xác tuyệt đối
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CoachProfileService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';
  
  // KIỂM TRA #2: Đảm bảo chữ S trong "Storage" được viết hoa
  final _storage = const FlutterSecureStorage();

  Future<void> createProfile(Map<String, dynamic> profileData) async {
    final token = await _storage.read(key: 'access_token');
    
    // Thêm dòng print để kiểm tra giá trị token
    print('Token is being sent: $token');

    if (token == null) {
      throw Exception('Người dùng chưa đăng nhập hoặc không tìm thấy token');
    }

    final url = Uri.parse('$_baseUrl/coach-profiles/');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode != 201) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Gửi hồ sơ thất bại');
      }
      
      print('Hồ sơ đã được tạo thành công!');

    } catch (e) {
      print('Lỗi khi tạo hồ sơ: $e');
      throw Exception('Không thể gửi hồ sơ. Vui lòng thử lại.');
    }
  }
}