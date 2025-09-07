import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swim360_app/core/providers/auth_provider.dart';
import 'package:swim360_app/features/auth/screens/login_screen.dart';
import 'package:swim360_app/features/dashboard/screens/dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Dựa vào trạng thái isAuthenticated để quyết định hiển thị màn hình nào
    if (authProvider.isAuthenticated) {
      return const DashboardScreen();
    } else {
      return const LoginScreen();
    }
  }
}