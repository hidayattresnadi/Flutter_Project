class ProjectForm {
  String title;
  String? category;
  DateTime? completionDate;
  String description;
  String? link;
  String? technologies;
  String? imagePath;

  ProjectForm({
    this.title = '',
    this.category,
    this.completionDate,
    this.description = '',
    this.link,
    this.technologies = '',
  });

  // Fungsi untuk mengubah objek project menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'completion_date': completionDate!.toLocal().toString().split(' ')[0],
      'description': description,
      'project_link': link,
      'technologies': technologies,
      'image_path': imagePath,
    };
  }
}
