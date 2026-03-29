import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final int price;
  final bool isPreorder;
  final int sortOrder;
  final String imageKey;
  final List<String> measurementFields;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.isPreorder,
    required this.sortOrder,
    required this.imageKey,
    required this.measurementFields,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? 0,
      isPreorder: data['isPreorder'] ?? false,
      sortOrder: data['sortOrder'] ?? 0,
      imageKey: data['imageKey'] ?? doc.id,
      measurementFields: List<String>.from(
        data['measurementFields'] ?? const [],
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'price': price,
    'isPreorder': isPreorder,
    'sortOrder': sortOrder,
    'imageKey': imageKey,
    'measurementFields': measurementFields,
  };
}
