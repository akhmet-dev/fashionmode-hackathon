import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final int price;
  final bool isPreorder;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.isPreorder,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      isPreorder: data['isPreorder'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'isPreorder': isPreorder,
      };
}
