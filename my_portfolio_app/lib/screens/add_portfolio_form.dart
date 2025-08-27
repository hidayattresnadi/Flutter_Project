import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_app/provider/project_provider.dart';
import 'package:my_portfolio_app/widgets/image_picker_form.dart';
import 'package:provider/provider.dart';

class PortfolioFormScreen extends StatelessWidget {
  const PortfolioFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioFormProvider = Provider.of<ProjectFormProvider>(context);
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Add Portfolio", textAlign: TextAlign.end),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 1000 ? 700 : 500,
            ),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: portfolioFormProvider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Form
                      Center(
                        child: Text(
                          "Portfolio Form",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return portfolioFormProvider.previousTitleEntries
                              .where(
                                (name) => name.toLowerCase().startsWith(
                                  textEditingValue.text.toLowerCase(),
                                ),
                              );
                        },
                        onSelected: (String selection) {
                          portfolioFormProvider.savedProjectName(selection);
                        },
                        fieldViewBuilder:
                            (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              if (textEditingController.text.isEmpty &&
                                  portfolioFormProvider
                                      .titleController
                                      .text
                                      .isNotEmpty) {
                                textEditingController.text =
                                    portfolioFormProvider.titleController.text;
                              }

                              // listen ke perubahan input, update provider
                              textEditingController.addListener(() {
                                portfolioFormProvider.titleController.text =
                                    textEditingController.text;
                              });

                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Project Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  portfolioFormProvider.titleController.text =
                                      value; // sync
                                },
                                onFieldSubmitted: (_) => onFieldSubmitted(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter project name';
                                  }
                                  return null;
                                },
                              );
                            },
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        value: portfolioFormProvider.formData.category,
                        items: ['Mobile App', 'Web Development', 'UI Design']
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                        onChanged: portfolioFormProvider.setCategory,
                        validator: (value) =>
                            value == null ? 'Please select a category' : null,
                      ),
                      const SizedBox(height: 16),

                      // Date Picker
                      FormField<DateTime>(
                        validator: (value) {
                          if (context
                                  .read<ProjectFormProvider>()
                                  .formData
                                  .completionDate ==
                              null) {
                            return 'Completion date is required';
                          }
                          return null;
                        },
                        builder: (field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputDecorator(
                              decoration: InputDecoration(
                                labelText: "Completion Date",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Consumer<ProjectFormProvider>(
                                      builder: (context, provider, child) {
                                        return Text(
                                          provider.formData.completionDate ==
                                                  null
                                              ? 'No date selected'
                                              : dateFormat.format(
                                                  provider
                                                      .formData
                                                      .completionDate!,
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () async {
                                      await context
                                          .read<ProjectFormProvider>()
                                          .pickDate(context);
                                      field.didChange(
                                        context
                                            .read<ProjectFormProvider>()
                                            .formData
                                            .completionDate,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  field.errorText!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: portfolioFormProvider.descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      ),
                      // technologies
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: portfolioFormProvider.techController,
                        decoration: const InputDecoration(
                          labelText: 'Tech Stack',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter tech stack';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Image Picker
                      ImagePickerExample(
                        onImageSelected: (path) {
                          portfolioFormProvider.formData.imagePath =
                              path; // simpan ke model
                          portfolioFormProvider.setImageError(null);
                        },
                      ),
                      if (portfolioFormProvider.imageError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'No image selected',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Url Link
                      TextFormField(
                        controller: portfolioFormProvider.linkController,
                        decoration: const InputDecoration(
                          labelText: 'Project Link',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14.0),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          final urlPattern =
                              r'^(https?:\/\/)?' // http:// atau https:// optional
                              r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' // domain
                              r'(\/[^\s]*)?$'; // path optional
                          if (!RegExp(urlPattern).hasMatch(value)) {
                            return 'Enter a valid URL';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Submit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: () async {
                              final shouldUpdate = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Cancel'),
                                  content: const Text(
                                    'Are you sure you want to cancel submit?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Back'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                ),
                              );

                              if (!context.mounted) return;
                              if (shouldUpdate == true) {
                                portfolioFormProvider.resetForm();
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 25),
                          ElevatedButton(
                            onPressed: () {
                              if (portfolioFormProvider.validateForm()) {
                                portfolioFormProvider.saveForm();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Portfolio item added successfully!',
                                    ),
                                  ),
                                );
                                if (!portfolioFormProvider.previousTitleEntries
                                    .contains(
                                      portfolioFormProvider
                                          .titleController
                                          .text,
                                    )) {
                                  portfolioFormProvider.savedProjectName(
                                    portfolioFormProvider.titleController.text,
                                  );
                                }
                                portfolioFormProvider.resetForm();
                                Navigator.of(context).pop(false);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
