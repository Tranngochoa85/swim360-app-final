import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/learning_request_service.dart';
import 'package:swim360_app/features/learning_request/models/learning_request_model.dart';
import 'package:swim360_app/features/learning_request/screens/request_details_screen.dart'; // Import màn hình chi tiết

class DiscoverRequestsScreen extends StatefulWidget {
  const DiscoverRequestsScreen({super.key});

  @override
  State<DiscoverRequestsScreen> createState() => _DiscoverRequestsScreenState();
}

class _DiscoverRequestsScreenState extends State<DiscoverRequestsScreen> {
  late Future<List<LearningRequest>> _requestsFuture;
  final LearningRequestService _service = LearningRequestService();

  @override
  void initState() {
    super.initState();
    _requestsFuture = _service.discoverRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khám Phá Yêu Cầu'),
      ),
      body: FutureBuilder<List<LearningRequest>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có yêu cầu nào.'));
          }
          
          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('${request.courseType} - ${request.courseObjective}'),
                  subtitle: Text('Độ tuổi: ${request.ageGroup}\nSố buổi: ${request.sessionsPerWeek} buổi/tuần'),
                  isThreeLine: true,
                  // SỬA LỖI: Thêm hành động điều hướng khi nhấn vào
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // Điều hướng đến màn hình chi tiết và truyền dữ liệu 'request' qua
                        builder: (context) => RequestDetailsScreen(request: request),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}