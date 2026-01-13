// Entity class’ı oluşturmamızın sebebi;API, Firestore, JSON gibi veri kaynaklarına bağımlı olmamak ve iş modelini sade, değişmez tutmaktır
class Ingredient {
  final String id;
  final String name;
  final String category;
  final String? image;
  final List<String> allowedUnits;
  final String defaultUnit;

  Ingredient({
    required this.name,
    required this.category,
    required this.id,
    this.image,
    required this.allowedUnits,
    required this.defaultUnit,
  });
}
