class FavouriteItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;

  FavouriteItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory FavouriteItem.fromMap(Map<String, dynamic> map) {
    return FavouriteItem(
      productId: map['productId'],
      productName: map['productName'],
      imageUrl: map['imageUrl'],
      price: (map['price'] as num).toDouble(),
    );
  }
}
