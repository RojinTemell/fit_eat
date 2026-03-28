import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String? name;
  final String? surname;
  final String? avatar;
  final List<String> badges; // Rozet ID listesi
  final int totalLikes;
  final int recipeCount;
  // ... diğer istatistikler

  const User({
    required this.uid,
    this.name,
    this.surname,
    this.avatar,
    this.badges = const [],
    this.totalLikes = 0,
    this.recipeCount = 0,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    surname,
    avatar,
    badges,
    totalLikes,
    recipeCount,
  ];

  // toJson, fromJson ve copyWith eklemelisin
}
