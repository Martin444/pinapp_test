class PostItemData {
  final int id;
  final String title;
  final String body;
  final bool isLiked;

  const PostItemData({
    required this.id,
    required this.title,
    required this.body,
    this.isLiked = false,
  });
}
