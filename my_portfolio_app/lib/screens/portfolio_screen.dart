import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/project_model.dart';
import 'package:my_portfolio_app/provider/project_provider.dart';
import 'package:my_portfolio_app/screens/add_portfolio_form.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

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
            child: Image.file(
              File(project.imagePath!),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            project.title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Category: ${project.category}',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Completed on: ${project.completionDate!.toLocal().toString().split(' ')[0]}',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            project.description,
            style: GoogleFonts.roboto(
              fontSize: 18,
              height: 1.4,
              fontWeight: FontWeight.w600, // lebih tebal dari default
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tech: ${project.technologies}',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          if (project.link != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: GestureDetector(
                onTap: () {
                  // Bisa tambahkan logic buka URL
                },
                child: Text(
                  project.link!,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
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
    final projects = context.watch<ProjectFormProvider>().projects;
    return withScaffold == true
        ? portFolioScaffold(context: context, projects: projects)
        : buildPortfolioBody(context: context, projects: projects);
  }
}

Widget portFolioScaffold({context, projects}) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text("My Portfolio"),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    body: buildPortfolioBody(context: context, projects: projects),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Navigasi ke AddPortfolioScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PortfolioFormScreen()),
        );
      },
      child: const Icon(Icons.add),
    ),
  );
}

Widget buildPortfolioBody({context, projects}) {
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

      return Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: MasonryGridView.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                buildProjectCard(context, projects[index]),
          ),

          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemCount: projects.length,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: crossAxisCount,
          //     crossAxisSpacing: 16,
          //     mainAxisSpacing: 50,
          //     childAspectRatio: childAspectRatio,
          //   ),
          //   itemBuilder: (context, index) {
          //     final project = projects[index];
          //     return buildProjectCard(context, project);
          //   },
          // ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigasi ke AddPortfolioScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PortfolioFormScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    },
  );
}
