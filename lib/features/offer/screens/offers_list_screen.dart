import 'package:flutter/material.dart';
import 'package:swim360_app/core/services/offer_service.dart';
import 'package:swim360_app/features/learning_request/models/learning_request_model.dart';
import 'package:swim360_app/features/offer/models/offer_model.dart';
import 'package:swim360_app/features/payment/screens/payment_confirmation_screen.dart'; // Import màn hình mới

class OffersListScreen extends StatefulWidget {
  final LearningRequest learningRequest;
  const OffersListScreen({super.key, required this.learningRequest});

  @override
  State<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> {
  final OfferService _offerService = OfferService();
  late Future<List<CourseOffer>> _offersFuture;

  @override
  void initState() {
    super.initState();
    _offersFuture = _offerService.getOffersForRequest(widget.learningRequest.id);
  }

  Future<void> _acceptOffer(CourseOffer offer) async {
    try {
      await _offerService.acceptOffer(offer.id);
      if (!mounted) return;
      // Sau khi chấp nhận thành công, điều hướng đến màn hình thanh toán
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(offer: offer),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ưu Đãi Cho Yêu Cầu')),
      body: FutureBuilder<List<CourseOffer>>(
        future: _offersFuture,
        builder: (context, snapshot) {
          // ... (Code FutureBuilder giữ nguyên) ...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có ưu đãi nào.'));
          }

          final offers = snapshot.data!;
          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Card(
                color: offer.status == 'accepted' ? Colors.green.shade100 : null,
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Ưu đãi từ HLV (ID: ...${offer.coachId.substring(offer.coachId.length - 6)})'),
                  subtitle: Text('Học phí: ${offer.price} VND\nTrạng thái: ${offer.status}'),
                  trailing: offer.status == 'sent'
                      ? ElevatedButton(
                          child: const Text('Chấp nhận'),
                          onPressed: () => _acceptOffer(offer),
                        )
                      : (offer.status == 'accepted' 
                          ? const Chip(label: Text('Đã chấp nhận'), backgroundColor: Colors.greenAccent)
                          : null),
                ),
              );
            },
          );
        },
      ),
    );
  }
}