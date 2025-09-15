import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/payment_service.dart';
import 'package:swim360_app/features/offer/models/offer_model.dart';
import 'package:swim360_app/features/payment/screens/vnpay_webview_screen.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final CourseOffer offer;
  const PaymentConfirmationScreen({super.key, required this.offer});

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = false;

  Future<void> _proceedToPayment() async {
    setState(() { _isLoading = true; });
    try {
      final paymentUrl = await _paymentService.createVNPayUrl(widget.offer.id);
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VNPayWebViewScreen(paymentUrl: paymentUrl),
        ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xác Nhận Thanh Toán')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Bạn sắp thanh toán cho ưu đãi:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('Học phí: ${widget.offer.price} VND'),
                subtitle: Text('Từ HLV: ...${widget.offer.coachId.substring(widget.offer.coachId.length - 6)}'),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _proceedToPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white) 
                : const Text('Tiến hành thanh toán qua VNPay'),
            ),
          ],
        ),
      ),
    );
  }
}