import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swim360_app/core/providers/auth_provider.dart';
import 'package:swim360_app/core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Tạo một instance của AuthService để sử dụng
  final AuthService _authService = AuthService();

  // Biến để quản lý trạng thái loading
  bool _isLoading = false;

  // Hàm xử lý logic đăng nhập đã được cập nhật
  Future<void> _login() async {
    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    // Bật trạng thái loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Dùng authService để lấy token
      final token = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      // Dùng Provider để thông báo cho "người gác cổng" về trạng thái đăng nhập mới
      // context.read<T>() là cách gọi tắt của Provider.of<T>(context, listen: false)
      // Chúng ta dùng nó ở đây vì chỉ cần gọi hàm, không cần widget này phải build lại.
      if (mounted) {
        context.read<AuthProvider>().login(token);
      }

    } catch (e) {
      // Nếu có lỗi, hiển thị SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      // Tắt trạng thái loading dù thành công hay thất bại
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Nhập'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ô nhập liệu cho Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16), // Khoảng cách giữa các widget

                // Ô nhập liệu cho Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Ẩn mật khẩu
                ),
                const SizedBox(height: 24),

                // Nút bấm Đăng nhập
                ElevatedButton(
                  // Vô hiệu hóa nút khi đang loading, nếu không thì gọi hàm _login
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Nút rộng hết màn hình
                  ),
                  // Hiển thị vòng xoay loading hoặc chữ tùy vào trạng thái _isLoading
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Đăng Nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}