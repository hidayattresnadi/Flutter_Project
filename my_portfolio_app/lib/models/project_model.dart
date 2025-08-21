class Project {
  final String title;
  final String category;
  final DateTime completionDate;
  final String description;
  final String? link;
  final String technologies;
  final String imagePath;

  Project({
    required this.title,
    required this.category,
    required this.completionDate,
    required this.description,
    this.link,
    required this.technologies,
    required this.imagePath,
  });
}
