import 'package:flutter/material.dart';

class Project {
  final String title;
  final String description;
  final String technologies;
  final String imagePath;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.imagePath,
  });
}

final List<Project> projects = [
  Project(
    title: 'Portfolio App',
    description: 'A personal app to showcase my projects.',
    technologies: 'Flutter, Firebase',
    imagePath: 'assets/portfolio.png',
  ),
  Project(
    title: 'Chat App',
    description: 'A real-time messaging app.',
    technologies: 'Flutter, Node.js',
    imagePath: 'assets/chat.jpg',
  ),
  Project(
    title: 'E-commerce UI',
    description: 'Front-end design for e-commerce.',
    technologies: 'Flutter',
    imagePath: 'assets/ecommerce.jpg',
  ),
  Project(
    title: 'Smart Home App',
    description: 'Mobile app to control smart home devices remotely.',
    technologies: 'Flutter, Firebase',
    imagePath: 'assets/smarthome.jpg',
  ),
];

Widget buildProjectCard(BuildContext context, Project project) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              project.imagePath,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tech: ${project.technologies}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    ),
  );
}

class PortfolioScreen extends StatelessWidget {
  final bool withScaffold;
  const PortfolioScreen({this.withScaffold = false, super.key});

  @override
  Widget build(BuildContext context) {
    return withScaffold == true
        ? portFolioScaffold(context)
        : buildPortfolioBody(context: context, project: projects);
  }
}

Widget portFolioScaffold(context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text("My Portfolio"),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    body: buildPortfolioBody(context: context, project: projects),
  );
}

Widget buildPortfolioBody({context, project}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: projects
          .map(
            (project) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: buildProjectCard(context, project),
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}
