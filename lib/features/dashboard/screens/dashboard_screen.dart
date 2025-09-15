import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swim360_app/core/providers/auth_provider.dart';
import 'package:swim360_app/features/coach_profile/screens/coach_profile_form_screen.dart';
import 'package:swim360_app/features/learning_request/screens/discover_requests_screen.dart';
import 'package:swim360_app/features/learning_request/screens/learning_request_form_screen.dart';
import 'package:swim360_app/features/learning_request/screens/my_requests_screen.dart'; // Import màn hình mới
import 'package:swim360_app/features/course/screens/my_courses_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => context.read<AuthProvider>().logout(),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nút MỚI: Xem yêu cầu của tôi (dành cho Người học)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyRequestsScreen()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue.shade700),
                child: const Text('Xem Yêu Cầu Của Tôi'),
              ),
              const SizedBox(height: 16),

              // ... (Các nút cũ giữ nguyên)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DiscoverRequestsScreen()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.orange),
                child: const Text('Khám Phá Yêu Cầu Mới (HLV)'),
              ),
              const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CoachProfileFormScreen()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('Hồ Sơ Huấn Luyện Viên'),
              ),
              const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LearningRequestFormScreen()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green),
                child: const Text('Tạo Yêu cầu Học bơi'),
              ),
              const SizedBox(height: 16),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyCoursesScreen())); // Sửa thành màn hình MyCoursesScreen
  },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green),
                child: const Text('Quản lý Khóa học'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}