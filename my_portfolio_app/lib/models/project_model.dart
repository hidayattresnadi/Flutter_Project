class Project {
  final int? id;
  final String title;
  final String category;
  final String completionDate;
  final String description;
  final String? link;
  final String technologies;
  final String imagePath;

  Project({
    this.id,
    required this.title,
    required this.category,
    required this.completionDate,
    required this.description,
    this.link,
    required this.technologies,
    required this.imagePath,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      completionDate: json['completion_date'],
      description: json['description'],
      link: json['project_link'],
      technologies: json['technologies'],
      imagePath: json['image_path'],
    );
  }
}
