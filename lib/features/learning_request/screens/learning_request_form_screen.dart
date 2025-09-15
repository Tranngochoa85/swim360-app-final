import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/learning_request_service.dart';

class LearningRequestFormScreen extends StatefulWidget {
  const LearningRequestFormScreen({super.key});

  @override
  State<LearningRequestFormScreen> createState() =>
      _LearningRequestFormScreenState();
}

class _LearningRequestFormScreenState extends State<LearningRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _requestService = LearningRequestService();
  bool _isLoading = false;

  String? _selectedCourseType;
  String? _selectedObjective;
  String? _selectedAgeGroup;
  TimeOfDay? _selectedTime;

  final _sessionsPerWeekController = TextEditingController();
  final _preferredDaysController = TextEditingController();
  final _sessionDurationController = TextEditingController();
  final _numAdultsController = TextEditingController(text: '1');
  final _numChildrenController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  final List<String> _courseTypes = ['Bơi ếch', 'Bơi sải', 'Bơi bướm', 'Bơi ngửa'];
  final List<String> _objectives = ['Cơ bản', 'Nâng cao', 'Duy trì', 'Luyện thi'];
  final List<String> _ageGroups = ['4-5 tuổi', '6-15 tuổi', '16-18 tuổi', '> 18 tuổi'];

  @override
  void dispose() {
    _sessionsPerWeekController.dispose();
    _preferredDaysController.dispose();
    _sessionDurationController.dispose();
    _numAdultsController.dispose();
    _numChildrenController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    // Ẩn bàn phím trước khi xử lý
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      if (_selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn thời gian học'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() { _isLoading = true; });

      try {
        final requestData = {
          "course_type": _selectedCourseType,
          "course_objective": _selectedObjective,
          "age_group": _selectedAgeGroup,
          "sessions_per_week": int.parse(_sessionsPerWeekController.text),
          "preferred_days": _preferredDaysController.text.split(',').map((e) => e.trim()).toList(),
          "preferred_time": "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00",
          "session_duration": int.parse(_sessionDurationController.text),
          "num_adults": int.parse(_numAdultsController.text),
          "num_children": int.parse(_numChildrenController.text),
          "notes": _notesController.text,
        };
        
        await _requestService.createRequest(requestData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo yêu cầu thành công!'), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red),
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
        title: const Text('Tạo Yêu Cầu Học Bơi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdown(_selectedCourseType, _courseTypes, 'Chọn khóa học (*)', (val) => setState(() => _selectedCourseType = val)),
                const SizedBox(height: 16),
                _buildDropdown(_selectedObjective, _objectives, 'Mục tiêu (*)', (val) => setState(() => _selectedObjective = val)),
                const SizedBox(height: 16),
                _buildDropdown(_selectedAgeGroup, _ageGroups, 'Độ tuổi (*)', (val) => setState(() => _selectedAgeGroup = val)),
                const SizedBox(height: 16),
                
                // SỬA LỖI: Thêm keyboardType cho các trường số
                _buildTextFormField(controller: _sessionsPerWeekController, label: 'Số buổi / tuần (*)', keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextFormField(controller: _preferredDaysController, label: 'Ngày học mong muốn (*) (cách nhau bởi dấu phẩy)'),
                const SizedBox(height: 16),
                _buildTextFormField(controller: _sessionDurationController, label: 'Thời lượng / buổi (phút) (*)', keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                 _buildTextFormField(controller: _numAdultsController, label: 'Số lượng người lớn (*)', keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                 _buildTextFormField(controller: _numChildrenController, label: 'Số lượng trẻ em (*)', keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextFormField(controller: _notesController, label: 'Ghi chú thêm', isRequired: false, maxLines: 3),
                const SizedBox(height: 16),
                
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: BorderSide(color: Colors.grey.shade600)),
                  title: Text(_selectedTime == null ? '  Chọn thời gian học (*)' : '  Thời gian học: ${_selectedTime!.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: _selectTime,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Gửi Yêu Cầu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String? currentValue, List<String> items, String label, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: currentValue,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Vui lòng chọn' : null,
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label, TextInputType keyboardType = TextInputType.text, int maxLines = 1, bool isRequired = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: isRequired ? (val) => val == null || val.trim().isEmpty ? 'Vui lòng nhập' : null : null,
    );
  }
}