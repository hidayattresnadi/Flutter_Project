import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/screens/edit_profile_screen.dart';
import 'package:my_portfolio_app/screens/forbidden_screen.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();

    // pertama kali load (All)
    _loadData();
  }

  Future<void> _loadData() {
    final provider = context.read<ProfileProvider>();
    return provider.fetchUsers(); // All
  }

  @override
  Widget build(BuildContext context) {
    final profiles = context.watch<ProfileProvider>().profiles;
    bool isLoading = context.read<ProfileProvider>().isLoading;
    final role = Provider.of<ProfileProvider>(context).profile?.role;
    String? errorMessage = context.read<ProfileProvider>().errorMessage;

    if (role != "admin") {
      return ForbiddenPage();
    }

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : errorMessage != null
        ? Center(
            child: Text(
              errorMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        : profiles.isNotEmpty
        ? ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profile.photo != null
                            ? NetworkImage(profile.photo!)
                            : null,
                        child: profile.photo == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profile.profession ?? 'Not specified',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Actions
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditProfileScreen(uid: profile.uid),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Cancel'),
                                  content: const Text(
                                    'Are you sure you want to delete user?',
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
                              if (shouldDelete == true) {
                                bool success = await context
                                    .read<ProfileProvider>()
                                    .deleteUser(profile.uid);
                                if (success) {
                                  Fluttertoast.showToast(
                                    msg: 'data is deleted',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  } else {
                                    if (context.mounted) {
                                      final errorMessage = context
                                          .read<ProfileProvider>()
                                          .errorMessage;
                                      Fluttertoast.showToast(
                                        msg: '$errorMessage',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : const Center(
            child: Text(
              'No Portfolio yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
  }
}
