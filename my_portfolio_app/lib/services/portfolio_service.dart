import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_portfolio_app/models/project_form_model.dart';
import 'package:my_portfolio_app/models/project_model.dart';

class PortfolioService {
  static const String baseUrl = 'http://10.0.2.2:3000/portfolios';

  // Fetch todos from the API
  static Future<List<Project>> fetchPortfolios({String? category}) async {
    Uri uri = Uri.parse(baseUrl);
    if (category != null) {
      uri = uri.replace(queryParameters: {'category': category});
    }
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load projects");
    }
  }

  //Add a new project
  static Future<void> addPortolio(ProjectForm project) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(project.toJson()),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['error'] ?? 'Unknown error';
        throw Exception("Failed to add project: $message");
      }
    } catch (e) {
      throw Exception("Request failed: $e");
    }
  }

  // Update project
  static Future<void> updateProject(Project project) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${project.id}'),
      headers: <String, String>{'Content-Type': 'application/json'},

      body: json.encode({
        'title': project.title,
        'category': project.category,
        'completion_date': project.completionDate!,
        'description': project.description,
        'project_link': project.link,
        'technologies': project.technologies,
        'image_path': project.imagePath,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update project');
    }
  }

  // Delete a project
  static Future<void> deleteProject(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete project');
    }
  }
}
