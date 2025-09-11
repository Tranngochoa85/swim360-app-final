class LearningRequest {
  final String id;
  final String userId;
  final String status;
  final String courseType;
  final String courseObjective;
  final String ageGroup;
  final int sessionsPerWeek;
  final List<String> preferredDays;
  final String preferredTime;
  final int sessionDuration;
  final int numAdults;
  final int numChildren;
  final String? notes;
  final DateTime createdAt;

  LearningRequest({
    required this.id,
    required this.userId,
    required this.status,
    required this.courseType,
    required this.courseObjective,
    required this.ageGroup,
    required this.sessionsPerWeek,
    required this.preferredDays,
    required this.preferredTime,
    required this.sessionDuration,
    required this.numAdults,
    required this.numChildren,
    this.notes,
    required this.createdAt,
  });

  factory LearningRequest.fromJson(Map<String, dynamic> json) {
    return LearningRequest(
      id: json['id'],
      userId: json['user_id'],
      status: json['status'],
      courseType: json['course_type'],
      courseObjective: json['course_objective'],
      ageGroup: json['age_group'],
      sessionsPerWeek: json['sessions_per_week'],
      preferredDays: List<String>.from(json['preferred_days']),
      preferredTime: json['preferred_time'],
      sessionDuration: json['session_duration'],
      numAdults: json['num_adults'],
      numChildren: json['num_children'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}