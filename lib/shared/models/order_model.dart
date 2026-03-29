import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_size_model.dart';

enum OrderStatus { placed, sewing, ready }

enum PaymentMethod { kaspi, card, cash }

enum PaymentStatus { pending, paid }

extension PaymentMethodPresentation on PaymentMethod {
  String get label => switch (this) {
    PaymentMethod.kaspi => 'Kaspi',
    PaymentMethod.card => 'Card',
    PaymentMethod.cash => 'Cash',
  };

  String get checkoutTitle => switch (this) {
    PaymentMethod.kaspi => 'Kaspi перевод',
    PaymentMethod.card => 'Банковская карта',
    PaymentMethod.cash => 'Оплата при получении',
  };
}

extension PaymentStatusPresentation on PaymentStatus {
  String get label => switch (this) {
    PaymentStatus.pending => 'Ожидает оплаты',
    PaymentStatus.paid => 'Оплачено',
  };
}

class OrderModel {
  final String id;
  final String clientId;
  final String clientName;
  final String productName;
  final OrderSizeModel sizing;
  final int price;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? preorderDate;
  final PaymentMethod? paymentMethod;
  final PaymentStatus paymentStatus;
  final DateTime? paidAt;

  const OrderModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.productName,
    required this.sizing,
    required this.price,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.preorderDate,
    this.paymentMethod,
    this.paymentStatus = PaymentStatus.pending,
    this.paidAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final paymentMethodRaw = data['paymentMethod'] as String?;
    return OrderModel(
      id: doc.id,
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      productName: data['productName'] ?? '',
      sizing: OrderSizeModel.fromMap(
        data['sizing'] == null
            ? null
            : Map<String, dynamic>.from(data['sizing'] as Map),
        legacySize: data['size'] ?? '',
      ),
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
      paymentMethod: paymentMethodRaw == null
          ? null
          : PaymentMethod.values.firstWhere(
              (method) => method.name == paymentMethodRaw,
              orElse: () => PaymentMethod.card,
            ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (status) => status.name == data['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      paidAt: data['paidAt'] != null
          ? (data['paidAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'clientId': clientId,
    'clientName': clientName,
    'productName': productName,
    'size': sizing.summary,
    'sizing': sizing.toMap(),
    'price': price,
    'status': status.name,
    'createdAt': Timestamp.fromDate(createdAt),
    if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
    if (preorderDate != null) 'preorderDate': Timestamp.fromDate(preorderDate!),
    if (paymentMethod != null) 'paymentMethod': paymentMethod!.name,
    'paymentStatus': paymentStatus.name,
    if (paidAt != null) 'paidAt': Timestamp.fromDate(paidAt!),
  };

  String get size => sizing.summary;
}
