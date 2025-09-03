import 'package:my_portfolio_app/models/project_model.dart';

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

  // Project toProject() {
  //   return Project(
  //     title: title,
  //     category: category ?? "Uncategorized",
  //     completionDate: completionDate ?? DateTime.now(),
  //     description: description,
  //     link: link,
  //     technologies: technologies ?? "Unknown",
  //     imagePath: imagePath ?? "assets/images/default.png",
  //   );
  // }

  // Fungsi untuk mengubah objek Todo menjadi format JSON
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
