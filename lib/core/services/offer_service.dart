import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:swim360_app/features/offer/models/offer_model.dart';

// Đảm bảo tất cả các hàm đều nằm bên trong cặp ngoặc nhọn {} của class này
class OfferService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<void> createOffer({
    required String requestId,
    required double price,
    String? message,
  }) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực.');
    }

    final url = Uri.parse('$_baseUrl/learning-requests/$requestId/offers');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'price': price,
          'message': message ?? '',
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Gửi ưu đãi thất bại');
      }
    } catch (e) {
      throw Exception('Không thể gửi ưu đãi. Vui lòng thử lại.');
    }
  }

  Future<List<CourseOffer>> getOffersForRequest(String requestId) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception('Chưa đăng nhập');

    final url = Uri.parse('$_baseUrl/learning-requests/$requestId/offers');
    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CourseOffer.fromJson(json)).toList();
      } else {
        throw Exception('Lấy danh sách ưu đãi thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy ưu đãi');
    }
  }

  Future<void> acceptOffer(String offerId) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) throw Exception('Chưa đăng nhập');

    final url = Uri.parse('$_baseUrl/offers/$offerId/accept');
    try {
      final response = await http.post(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Chấp nhận ưu đãi thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi chấp nhận ưu đãi');
    }
  }
}