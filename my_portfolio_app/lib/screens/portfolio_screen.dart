import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/project_model.dart';
import 'package:my_portfolio_app/provider/project_provider.dart';
import 'package:my_portfolio_app/routes.dart';
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

class PortfolioScreen extends StatefulWidget {
  final bool withScaffold;
  final ValueChanged<int>? onTabChanged;

  const PortfolioScreen({
    this.withScaffold = false,
    this.onTabChanged,
    super.key,
  });

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectFormProvider>().projects;

    return widget.withScaffold
        ? portFolioScaffold(
            context: context,
            projects: projects,
            currentIndex: _currentIndex,
            onTabChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )
        : buildPortfolioBody(
            context: context,
            projects: projects,
            onTabChanged: widget.onTabChanged,
          );
  }
}

Widget portFolioScaffold({
  required BuildContext context,
  required List projects,
  required int currentIndex,
  required Function(int) onTabChanged,
}) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text("My Portfolio"),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
    ),
    body: buildPortfolioBody(
      context: context,
      projects: projects,
      onTabChanged: onTabChanged,
    ),
    floatingActionButton: currentIndex == 0
        ? FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.addPortfolio);
            },
            child: const Icon(Icons.add),
          )
        : null,
  );
}

Widget buildPortfolioBody({
  context,
  projects,
  ValueChanged<int>? onTabChanged,
}) {
  return DefaultTabController(
    length: 3,
    child: Builder(
      builder: (context) {
        final controller = DefaultTabController.of(context);
        controller.addListener(() {
          if (!controller.indexIsChanging && onTabChanged != null) {
            onTabChanged(controller.index); // kirim index balik
          }
        });

        return Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Web Projects'),
                Tab(text: 'Mobile App'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  buildProjectGrid(context: context, projects: projects),
                  buildProjectGrid(
                    context: context,
                    projects: projects
                        .where((p) => p.category == 'Web Development')
                        .toList(),
                  ),
                  buildProjectGrid(
                    context: context,
                    projects: projects
                        .where((p) => p.category == 'Mobile App')
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget buildProjectGrid({
  required BuildContext context,
  required List projects,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;

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

      return projects.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: MasonryGridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
            )
          : const Center(
              child: Text(
                'No Portfolio yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
    },
  );
}
