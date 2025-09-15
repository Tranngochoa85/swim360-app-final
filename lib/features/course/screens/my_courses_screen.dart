import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/course_service.dart';
import 'package:swim360_app/features/course/models/course_model.dart';
import 'package:swim360_app/features/course/screens/create_course_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  late Future<List<Course>> _myCoursesFuture;
  final CourseService _service = CourseService();

  @override
  void initState() {
    super.initState();
    _myCoursesFuture = _service.getMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa Học Của Tôi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tạo khóa học mới',
            onPressed: () {
             Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const CreateCourseScreen()),
  ).then((_) {
    // Tải lại danh sách sau khi quay về
    setState(() {
      _myCoursesFuture = _service.getMyCourses();
    });
  });
},
          )
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _myCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bạn chưa tạo khóa học nào.'));
          }

          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(course.title),
                  subtitle: Text('Trạng thái: ${course.status} - ${course.price} VND'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}