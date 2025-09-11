import 'package:flutter/material.dart';
import 'package:my_portfolio_app/provider/app_auth_provider.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:my_portfolio_app/screens/admin/admin_dashboard.dart';
import 'package:my_portfolio_app/screens/contact_screen.dart';
import 'package:my_portfolio_app/screens/edit_profile_screen.dart';
import 'package:my_portfolio_app/screens/forbidden_screen.dart';
import 'package:my_portfolio_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 1;
  late PageController _pageController;

  final List<String> _titles = ['Profile', 'Admin Dashboard', 'Settings'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final role = Provider.of<ProfileProvider>(context).profile?.role;
    final screens = [ProfileScreen(), AdminDashboardScreen(), ContactScreen()];

    if (role != "admin") {
      return ForbiddenPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: screens,
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.registerUser);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Manage Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Drawer Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('SettingsPage'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.settingPage),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('AboutPage'),
              onTap: () => Navigator.pushNamed(context, AppRoutes.aboutPage),
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Log Out'),
              onTap: () async {
                // final profileProvider = Provider.of<ProfileProvider>(
                //   context,
                //   listen: false,
                // );
                // profileProvider.clearProfile();
                await authProvider.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false, // clear navigation stack
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
