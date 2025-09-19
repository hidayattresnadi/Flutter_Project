import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/providers/app_auth_provider.dart';
import 'package:hr_attendance_tracker/providers/attendance_record_provider.dart';
import 'package:hr_attendance_tracker/providers/employee_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/screens/admin/admin_main_screen.dart';
import 'package:hr_attendance_tracker/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:hr_attendance_tracker/screens/attendance_history.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:firebase_auth/firebase_auth.dart' as fb;

void main() async {
  late List<CameraDescription> cameras;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  cameras = await availableCameras();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: dotenv.env['PROJECT_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!, //Project Number
      apiKey: dotenv.env['API_KEY']!, //Web API Key
      appId: dotenv.env['APP_ID']!, // App ID
    ),
  );

  await sb.Supabase.initialize(
    url: dotenv.env['URL_SUPABASE']!,
    anonKey: dotenv.env['API_KEY_SUPABASE']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceRecordProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
      ],
      child: MyApp(cameras: cameras),
    ),
  );

  // // //beri waktu splash screen 2 detik

  // await Future.delayed(const Duration(seconds: 2));

  // // // hapus splash screen dengan function remove()

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final List<CameraDescription>? cameras;

  const MyApp({super.key, this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) =>
          AppRoutes.generateRoute(settings, cameras!),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb.User?>(
      stream: fb.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final employeeProvider = Provider.of<EmployeeProvider>(
          context,
          listen: false,
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // semisal nutup aplikasi tanpa log out
          if (employeeProvider.employee == null) {
            return const SplashScreen();
          }

          if (employeeProvider.employee!.role == "admin") {
            return const AdminMainScreen();
          } else {
            return const MainScreen();
          }
        }

        return const SplashScreen();
      },
    );
  }
}

final PageController _pageController = PageController();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
    AttendanceHistoryScreen(),
  ];
  final List<String> _titles = ['Home', 'Profile', 'Attendance History'];

  @override
  Widget build(BuildContext context) {
    final employee = context.watch<EmployeeProvider>().employee;
    final authProvider = Provider.of<AppAuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens, // list of widgets
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_turned_in_sharp),
              label: 'Attendance History',
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
