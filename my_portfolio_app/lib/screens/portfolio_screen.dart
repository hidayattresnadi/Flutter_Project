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
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
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
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      // final crossAxisCount = screenWidth < 600 ? 1 : 2;
      int crossAxisCount;
      if (screenWidth < 600) {
        crossAxisCount = 1; // HP
      } else if (screenWidth < 1024) {
        crossAxisCount = 2; // Tablet
      } else {
        crossAxisCount = 3; // Desktop
      }
      final spacing = 16 * (crossAxisCount - 1);
      final itemWidth = (screenWidth - spacing) / crossAxisCount;
      final itemHeight = 501.0; // tinggi fix
      final childAspectRatio = itemWidth / itemHeight;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 50,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final project = projects[index];
            return buildProjectCard(context, project);
          },
        ),
      );
    },
  );
}
