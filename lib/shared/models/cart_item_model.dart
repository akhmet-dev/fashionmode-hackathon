import 'order_size_model.dart';
import 'product_model.dart';

class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final OrderSizeModel sizing;
  final int price;
  final bool isSelected;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.sizing,
    required this.price,
    this.isSelected = true,
  });

  factory CartItemModel.fromProduct(
    ProductModel product, {
    required OrderSizeModel sizing,
  }) {
    final uniqueId =
        '${product.id}-${DateTime.now().microsecondsSinceEpoch.toString()}';
    return CartItemModel(
      id: uniqueId,
      productId: product.id,
      productName: product.name,
      sizing: sizing,
      price: product.price,
    );
  }

  CartItemModel copyWith({
    String? id,
    String? productId,
    String? productName,
    OrderSizeModel? sizing,
    int? price,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sizing: sizing ?? this.sizing,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  String get size => sizing.summary;
}
