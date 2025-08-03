// Required for DateTime

// Model for a News Item
class NewsItem {
  final String title;
  final String content;
  final String category;
  final DateTime date;

  NewsItem({
    required this.title,
    required this.content,
    required this.category,
    required this.date,
  });
}
