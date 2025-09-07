import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/coach_profile_service.dart';

class CoachProfileFormScreen extends StatefulWidget {
  const CoachProfileFormScreen({super.key});

  @override
  State<CoachProfileFormScreen> createState() => _CoachProfileFormScreenState();
}

class _CoachProfileFormScreenState extends State<CoachProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _yearsExpController = TextEditingController();
  final _bioController = TextEditingController();
  final _specializationsController = TextEditingController();
  final _profileLinkController = TextEditingController();
  
  bool _isLoading = false;
  final _profileService = CoachProfileService();

  @override
  void dispose() {
    _yearsExpController.dispose();
    _bioController.dispose();
    _specializationsController.dispose();
    _profileLinkController.dispose();
    super.dispose();
  }

  // Hàm validator chung cho các trường bắt buộc
  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }

  Future<void> _submitForm() async {
    // Chỉ gửi khi form hợp lệ
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      try {
        final profileData = {
          "years_of_experience": int.parse(_yearsExpController.text),
          "bio": _bioController.text.trim(),
          "specializations": _specializationsController.text.split(',').map((e) => e.trim()).toList(),
          "profile_link": _profileLinkController.text.trim(),
        };

        await _profileService.createProfile(profileData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hồ sơ đã được gửi thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }

      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() { _isLoading = false; });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ Sơ Huấn Luyện Viên'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _yearsExpController,
                  decoration: const InputDecoration(labelText: 'Số năm kinh nghiệm (*)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) { return 'Vui lòng nhập số năm kinh nghiệm'; }
                    if (int.tryParse(value) == null) { return 'Vui lòng chỉ nhập số'; }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Giới thiệu bản thân (*)'),
                  maxLines: 4,
                  // THÊM VALIDATOR
                  validator: (value) => _validateRequired(value, 'giới thiệu bản thân'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _specializationsController,
                  decoration: const InputDecoration(
                    labelText: 'Các chuyên môn (*) (cách nhau bởi dấu phẩy)',
                    helperText: 'Ví dụ: Bơi ếch, Bơi sải, Cứu hộ',
                  ),
                  // THÊM VALIDATOR
                  validator: (value) => _validateRequired(value, 'chuyên môn'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _profileLinkController,
                  decoration: const InputDecoration(labelText: 'Link hồ sơ (nếu có) (*)'),
                  keyboardType: TextInputType.url,
                  // THÊM VALIDATOR
                  validator: (value) => _validateRequired(value, 'link hồ sơ'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Gửi Yêu Cầu Xét Duyệt'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}