import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swim360_app/core/providers/auth_provider.dart';
// Import file form chúng ta vừa tạo
import 'package:swim360_app/features/coach_profile/screens/coach_profile_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard HLV'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              context.read<AuthProvider>().logout();
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Chào mừng bạn đã đăng nhập thành công!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Điều hướng đến màn hình Form
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CoachProfileFormScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Hoàn Thiện Hồ Sơ HLV'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}