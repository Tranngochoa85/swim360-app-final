class CourseOffer {
  final String id;
  final String learningRequestId;
  final String coachId;
  final String status;
  final double price;
  final String? message;
  final DateTime createdAt;

  CourseOffer({
    required this.id,
    required this.learningRequestId,
    required this.coachId,
    required this.status,
    required this.price,
    this.message,
    required this.createdAt,
  });

  factory CourseOffer.fromJson(Map<String, dynamic> json) {
    return CourseOffer(
      id: json['id'],
      learningRequestId: json['learning_request_id'],
      coachId: json['coach_id'],
      status: json['status'],
      price: double.parse(json['price'].toString()),
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}