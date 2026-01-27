class CartItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      productName: map['productName'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}
