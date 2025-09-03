import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/project_form_model.dart';
import 'package:my_portfolio_app/models/project_model.dart';
import 'package:my_portfolio_app/services/portfolio_service.dart';

class ProjectFormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  List<Project> _projects = [];
  String? _errorMessage;
  String? _imageError;
  bool _isLoading = false;

  String? get imageError => _imageError;
  List<Project> get projects => _projects;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  final techController = TextEditingController();

  List<String> previousTitleEntries = [];

  ProjectForm formData = ProjectForm();

  void savedProjectName(String name) {
    if (!previousTitleEntries.contains(name)) {
      previousTitleEntries.add(name);
    }
  }

  // get all data from API
  Future<void> fetchPortfolios({String? category}) async {
    _errorMessage = null;
    _isLoading = true;
    _projects = [];

    await Future.delayed(const Duration(seconds: 2));
    // notifyListeners();

    try {
      _projects = await PortfolioService.fetchPortfolios(category: category);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String? value) {
    formData.category = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setDate(DateTime? date) {
    formData.completionDate = date;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      formData.completionDate = picked;
      notifyListeners();
    }
  }

  void setImageError(String? error) {
    _imageError = error;
    notifyListeners();
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;

    if (formData.imagePath == null) {
      _imageError = "Please select an image";
    } else {
      _imageError = null;
    }
    notifyListeners(); // biar UI rebuild dan error muncul
    return isValid && formData.imagePath != null;
  }

  // Add Project
  Future<bool> addProject() async {
    try {
      formData.title = titleController.text;
      formData.description = descriptionController.text;
      formData.link = linkController.text;
      formData.technologies = techController.text;
      await PortfolioService.addPortolio(formData);
      await fetchPortfolios();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void saveForm() {
    formData.title = titleController.text;
    formData.description = descriptionController.text;
    formData.link = linkController.text;
    formData.technologies = techController.text;
    // final project = formData.toProject();
    // projects.add(project);
    notifyListeners();
  }

  void resetForm() {
    formData = ProjectForm();
    titleController.clear();
    descriptionController.clear();
    linkController.clear();
    techController.clear();
    _errorMessage = null;
    _imageError = null;
  }
}
