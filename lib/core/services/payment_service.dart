import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<String> createVNPayUrl(String offerId) async {
    final token = await _storage.read(key: 'access_token');
    if (token == null) {
      throw Exception('Chưa đăng nhập');
    }

    final url = Uri.parse('$_baseUrl/payments/create-vnpay-url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'offer_id': offerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['paymentUrl'];
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Tạo phiên thanh toán thất bại');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi tạo phiên thanh toán');
    }
  }
}