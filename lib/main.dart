import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swim360_app/auth_wrapper.dart';
import 'package:swim360_app/core/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider sẽ cung cấp AuthProvider cho toàn bộ ứng dụng
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Swim360',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // "Người gác cổng" bây giờ là màn hình chính
        home: const AuthWrapper(),
      ),
    );
  }
}