import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Địa chỉ IP đặc biệt để máy ảo Android có thể "nói chuyện" với server chạy trên máy tính của bạn
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';
  
  // THAY ĐỔI 1: Hàm bây giờ trả về Future<String> thay vì Future<void>
  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    http.Response response;

    try {
      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
    } catch (e) {
      print('Network error during login: $e');
      throw Exception('Không thể kết nối đến server. Vui lòng thử lại.');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      print('Login Successful! Token fetched.');
      
      // THAY ĐỔI 2: Trả về token, không lưu trữ ở đây nữa
      return token;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Đăng nhập thất bại');
    }
  }
}