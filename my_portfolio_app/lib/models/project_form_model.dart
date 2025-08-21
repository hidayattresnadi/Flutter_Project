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

  Project toProject() {
    return Project(
      title: title,
      category: category ?? "Uncategorized",
      completionDate: completionDate ?? DateTime.now(),
      description: description,
      link: link,
      technologies: technologies ?? "Unknown",
      imagePath: imagePath ?? "assets/images/default.png",
    );
  }
}
