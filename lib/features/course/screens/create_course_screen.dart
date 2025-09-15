import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/course_service.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  // Thêm các controller khác cho các trường của khóa học...

  final CourseService _service = CourseService();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isLoading = true; });

      final courseData = {
        "title": _titleController.text,
        "price": double.parse(_priceController.text),
        // Thêm các trường dữ liệu khác ở đây
        "course_type": "Bơi sải",
        "skill_level": "Cơ bản",
        "age_group": "Người lớn",
        "total_sessions": 12,
        "session_duration": 60,
        "location_name": "Hồ bơi ABC",
        "max_students": 10,
        "start_date": "2025-12-01"
      };

      try {
        await _service.createCourse(courseData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo khóa học thành công!'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
      appBar: AppBar(title: const Text('Tạo Khóa Học Mới')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tên khóa học (*)'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Học phí (*)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập học phí' : null,
              ),
              // Thêm các TextFormField khác cho các trường còn lại
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Tạo Khóa Học'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}