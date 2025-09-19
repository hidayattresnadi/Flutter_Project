import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/providers/app_auth_provider.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/screens/admin/admin_dashboard.dart';
import 'package:hr_attendance_tracker/screens/admin/register_employee.dart';
import 'package:hr_attendance_tracker/screens/forbidden_page_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:intl/intl.dart';
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
    final role = Provider.of<EmployeeProvider>(context).employee?.role;
    final employee = context.watch<EmployeeProvider>().employee;
    final screens = [
      ProfileScreen(),
      AdminDashboardScreen(),
      RegisterUserScreen(),
    ];

    if (role != "admin") {
      return ForbiddenPage();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade900,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _titles[_currentIndex],
                style: GoogleFonts.pacifico(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),

            Text(
              DateFormat('MMMM dd, yyyy').format(DateTime.now()),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type:
              BottomNavigationBarType.fixed, // biar semua item tetap lebar sama
          currentIndex: _currentIndex,
          backgroundColor: Color(0xFF004966),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Manage Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), // ikon register
              label: 'Register',
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                employee!.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(employee.email),
              currentAccountPicture: CircleAvatar(
                radius: 55,
                backgroundImage:
                    (employee.profilePhoto != null &&
                        employee.profilePhoto!.isNotEmpty)
                    ? NetworkImage(employee.profilePhoto!)
                    : null,
                child: employee.profilePhoto == null
                    ? const Icon(Icons.person, size: 55)
                    : null,
              ),
              decoration: BoxDecoration(color: Color(0xFF004966)),
            ),
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).colorScheme.primary,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       CircleAvatar(
            //         radius: 40,
            //         backgroundImage: AssetImage('assets/images/employee.jpg'),
            //       ),
            //       SizedBox(height: 10),
            //       Text(
            //         employee.fullName,
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //         softWrap: true,
            //         overflow: TextOverflow.visible,
            //       ),
            //       Text(
            //         employee.position,
            //         style: TextStyle(
            //           fontSize: 12,
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       Text(
            //         'HR Attendance Tracker',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // ListTile(
            //   title: Text(
            //     'HR Attendance Tracker',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
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
