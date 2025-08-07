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

Widget buildProjectCard(Project project) {
  return Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      height: 340,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              project.imagePath,
              width: double.infinity,
              height: 130,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    project.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue, size: 17),
                      const SizedBox(width: 10),
                      Text(
                        "Description:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Text(
                    project.description,
                    style: TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.developer_board_outlined,
                        color: Colors.blue,
                        size: 17,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Tech:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    project.technologies,
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PortfolioScreen extends StatelessWidget {
  final bool withScaffold;
  const PortfolioScreen({this.withScaffold = false, super.key});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget content = GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: projects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isLandscape ? 3 : 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: isLandscape ? 0.75 : 0.5,
      ),
      itemBuilder: (context, index) {
        return buildProjectCard(projects[index]);
      },
    );
    return withScaffold == true
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("My Portfolio"),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            body: content,
          )
        : content;
  }
}
