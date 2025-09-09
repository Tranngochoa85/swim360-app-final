import 'package:flutter/material.dart';

class LearningRequestFormScreen extends StatefulWidget {
  const LearningRequestFormScreen({super.key});

  @override
  State<LearningRequestFormScreen> createState() =>
      _LearningRequestFormScreenState();
}

class _LearningRequestFormScreenState extends State<LearningRequestFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Biến để lưu trữ các giá trị được chọn
  String? _selectedCourseType;
  String? _selectedObjective;
  String? _selectedAgeGroup;
  TimeOfDay? _selectedTime;

  // Controllers cho các ô text
  final _sessionsPerWeekController = TextEditingController();
  final _preferredDaysController = TextEditingController();
  final _sessionDurationController = TextEditingController();
  final _numAdultsController = TextEditingController(text: '1');
  final _numChildrenController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  // Các lựa chọn cho dropdowns
  final List<String> _courseTypes = ['Bơi ếch', 'Bơi sải', 'Bơi bướm', 'Bơi ngửa'];
  final List<String> _objectives = ['Cơ bản', 'Nâng cao', 'Duy trì', 'Luyện thi'];
  final List<String> _ageGroups = ['4-5 tuổi', '6-15 tuổi', '16-18 tuổi', '> 18 tuổi'];

  @override
  void dispose() {
    // Dọn dẹp controllers để tránh rò rỉ bộ nhớ
    _sessionsPerWeekController.dispose();
    _preferredDaysController.dispose();
    _sessionDurationController.dispose();
    _numAdultsController.dispose();
    _numChildrenController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Hàm để hiển thị bảng chọn thời gian
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logic gửi dữ liệu sẽ được thêm ở bước sau
      print('Form hợp lệ, sẵn sàng để gửi đi!');
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
                // === Các trường chọn (Dropdown) ===
                _buildDropdown(_selectedCourseType, _courseTypes, 'Chọn khóa học (*)', (val) => setState(() => _selectedCourseType = val)),
                const SizedBox(height: 16),
                _buildDropdown(_selectedObjective, _objectives, 'Mục tiêu (*)', (val) => setState(() => _selectedObjective = val)),
                const SizedBox(height: 16),
                _buildDropdown(_selectedAgeGroup, _ageGroups, 'Độ tuổi (*)', (val) => setState(() => _selectedAgeGroup = val)),
                const SizedBox(height: 16),
                
                // === Các trường nhập liệu (Text) ===
                _buildTextFormField(_sessionsPerWeekController, 'Số buổi / tuần (*)', TextInputType.number),
                const SizedBox(height: 16),
                _buildTextFormField(_preferredDaysController, 'Ngày học mong muốn (*) (cách nhau bởi dấu phẩy)'),
                const SizedBox(height: 16),
                _buildTextFormField(_sessionDurationController, 'Thời lượng / buổi (phút) (*)', TextInputType.number),
                const SizedBox(height: 16),
                _buildTextFormField(_numAdultsController, 'Số lượng người lớn (*)'),
                const SizedBox(height: 16),
                _buildTextFormField(_numChildrenController, 'Số lượng trẻ em (*)'),
                const SizedBox(height: 16),
                _buildTextFormField(_notesController, 'Ghi chú thêm', null, maxLines: 3, isRequired: false),
                const SizedBox(height: 16),
                
                // === Trường chọn thời gian ===
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(color: Colors.grey.shade600)
                  ),
                  title: Text(_selectedTime == null ? '  Chọn thời gian học (*)' : '  Thời gian học: ${_selectedTime!.format(context)}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: _selectTime,
                ),
                const SizedBox(height: 32),

                // === Nút Gửi ===
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Gửi Yêu Cầu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm trợ giúp để tạo Dropdown, tránh lặp code
  Widget _buildDropdown(String? currentValue, List<String> items, String label, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? 'Vui lòng chọn' : null,
    );
  }

  // Hàm trợ giúp để tạo TextFormField, tránh lặp code
  Widget _buildTextFormField(TextEditingController controller, String label, [TextInputType? keyboardType, {int? maxLines = 1, bool isRequired = true}]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      validator: isRequired ? (val) => val == null || val.isEmpty ? 'Vui lòng nhập' : null : null,
    );
  }
}