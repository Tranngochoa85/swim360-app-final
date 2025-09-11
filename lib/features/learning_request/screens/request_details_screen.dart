import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/offer_service.dart';
import 'package:swim360_app/features/learning_request/models/learning_request_model.dart';

class RequestDetailsScreen extends StatefulWidget {
  final LearningRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final OfferService _offerService = OfferService();
  bool _isLoading = false;

  void _showSendOfferDialog() {
    final formKey = GlobalKey<FormState>();
    final priceController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gửi Ưu Đãi'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Học phí đề xuất (*)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Vui lòng nhập một số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(labelText: 'Lời nhắn'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Hủy'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Gửi'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                setState(() { _isLoading = true; });
                Navigator.of(ctx).pop(); // Đóng dialog trước

                try {
                  await _offerService.createOffer(
                    requestId: widget.request.id,
                    price: double.parse(priceController.text),
                    message: messageController.text,
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gửi ưu đãi thành công!'), backgroundColor: Colors.green),
                    );
                    Navigator.of(context).pop(); // Quay về màn hình danh sách
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
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Yêu Cầu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(context, Icons.pool, 'Loại khóa học', widget.request.courseType),
            _buildDetailRow(context, Icons.flag, 'Mục tiêu', widget.request.courseObjective),
            _buildDetailRow(context, Icons.child_friendly, 'Độ tuổi', widget.request.ageGroup),
            _buildDetailRow(context, Icons.people, 'Số lượng', '${widget.request.numAdults} người lớn, ${widget.request.numChildren} trẻ em'),
            _buildDetailRow(context, Icons.repeat, 'Số buổi/tuần', '${widget.request.sessionsPerWeek} buổi'),
            _buildDetailRow(context, Icons.timer_outlined, 'Thời lượng', '${widget.request.sessionDuration} phút/buổi'),
            _buildDetailRow(context, Icons.calendar_today, 'Ngày học', widget.request.preferredDays.join(', ')),
            _buildDetailRow(context, Icons.access_time, 'Giờ học', widget.request.preferredTime),
            if (widget.request.notes != null && widget.request.notes!.isNotEmpty)
              _buildDetailRow(context, Icons.notes, 'Ghi chú', widget.request.notes!),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _showSendOfferDialog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Gửi Ưu Đãi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}