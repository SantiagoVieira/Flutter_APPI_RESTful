class Product {
  final int? id;
  String title;
  double price;
  String description;
  String category;
  String image;
  double rating;
  int ratingCount;

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingObj = json['rating'];
    return Product(
      id: json['id'] is int ? json['id'] : (json['id'] != null ? int.parse(json['id'].toString()) : null),
      title: json['title'] ?? '',
      price: (json['price'] is int) ? (json['price'] as int).toDouble()
            : (json['price'] is double) ? json['price'] : double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: ratingObj != null ? (ratingObj['rate'] != null ? (ratingObj['rate'] as num).toDouble() : 0.0) : 0.0,
      ratingCount: ratingObj != null ? (ratingObj['count'] ?? 0) as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
    if (id != null) data['id'] = id;
    return data;
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    double? rating,
    int? ratingCount,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }
}
