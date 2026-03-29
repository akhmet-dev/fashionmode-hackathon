import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { placed, sewing, ready }

class OrderModel {
  final String id;
  final String clientId;
  final String clientName;
  final String productName;
  final int price;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? preorderDate;

  const OrderModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.productName,
    required this.price,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.preorderDate,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      productName: data['productName'] ?? '',
      price: data['price'] ?? 0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => OrderStatus.placed,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      preorderDate: data['preorderDate'] != null
          ? (data['preorderDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'clientName': clientName,
    'productName': productName,
    'price': price,
    'status': status.name,
    'createdAt': Timestamp.fromDate(createdAt),
    if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
    if (preorderDate != null) 'preorderDate': Timestamp.fromDate(preorderDate!),
  };
}
