class UserStats {
  final int followersCount;
  final int followingCount;
  final int recipeCount;
  final int totalLikes;
  final List<String> badges;

  const UserStats({
    this.followersCount = 0,
    this.followingCount = 0,
    this.recipeCount = 0,
    this.totalLikes = 0,
    this.badges = const [],
  });
}
