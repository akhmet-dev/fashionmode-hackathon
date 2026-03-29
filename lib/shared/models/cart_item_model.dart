import 'product_model.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final int price;
  final bool isSelected;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.isSelected = true,
  });

  factory CartItemModel.fromProduct(ProductModel product) {
    final uniqueId =
        '${product.id}-${DateTime.now().microsecondsSinceEpoch.toString()}';
    return CartItemModel(
      id: uniqueId,
      productId: product.id,
      productName: product.name,
      price: product.price,
    );
  }

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    int? price,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
