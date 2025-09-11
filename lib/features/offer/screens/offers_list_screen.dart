import 'package:flutter/material.dart';
// SỬA LỖI: Sửa lại 'swim3G0_app' thành 'swim360_app' ở các dòng import dưới đây
import 'package:swim360_app/core/services/offer_service.dart';
import 'package:swim360_app/features/learning_request/models/learning_request_model.dart';
import 'package:swim360_app/features/offer/models/offer_model.dart';

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

  Future<void> _acceptOffer(String offerId) async {
    try {
      await _offerService.acceptOffer(offerId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chấp nhận ưu đãi thành công!'), backgroundColor: Colors.green),
      );
      // Tải lại trang để cập nhật trạng thái
      setState(() {
        _offersFuture = _offerService.getOffersForRequest(widget.learningRequest.id);
      });
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
                          onPressed: () => _acceptOffer(offer.id),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}