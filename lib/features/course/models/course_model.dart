import 'dart:convert';

class Course {
  final String id;
  final String coachId;
  final String title;
  final String status;
  final double price;
  // Thêm các trường khác bạn muốn hiển thị trong danh sách

  Course({
    required this.id,
    required this.coachId,
    required this.title,
    required this.status,
    required this.price,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      coachId: json['coach_id'],
      title: json['title'],
      status: json['status'],
      price: double.parse(json['price'].toString()),
    );
  }
}