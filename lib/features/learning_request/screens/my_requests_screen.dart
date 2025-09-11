import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/learning_request_service.dart';
import 'package:swim360_app/features/learning_request/models/learning_request_model.dart';
import 'package:swim360_app/features/offer/screens/offers_list_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final LearningRequestService _service = LearningRequestService();
  late Future<List<LearningRequest>> _myRequestsFuture;

  @override
  void initState() {
    super.initState();
    _myRequestsFuture = _service.getMyRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu Cầu Của Tôi'),
      ),
      body: FutureBuilder<List<LearningRequest>>(
        future: _myRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bạn chưa tạo yêu cầu nào.'));
          }

          final myRequests = snapshot.data!;
          return ListView.builder(
            itemCount: myRequests.length,
            itemBuilder: (context, index) {
              final request = myRequests[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${request.courseType} - ${request.courseObjective}'),
                  subtitle: Text('Trạng thái: ${request.status}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Điều hướng đến màn hình xem danh sách ưu đãi
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OffersListScreen(learningRequest: request),
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