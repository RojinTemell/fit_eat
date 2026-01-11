class Category {
  final String id;
  final String title;
  final String imageUrl;

  const Category({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
    );
  }
}
