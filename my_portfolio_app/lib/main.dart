import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio_app/provider/app_auth_provider.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/provider/project_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:my_portfolio_app/screens/admin/admin_main_screen.dart';
import 'package:my_portfolio_app/screens/contact_screen.dart';
import 'package:my_portfolio_app/screens/edit_profile_screen.dart';
import 'package:my_portfolio_app/screens/login_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: dotenv.env['PROJECT_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!, //Project Number
      apiKey: dotenv.env['API_KEY']!, //Web API Key
      appId: dotenv.env['APP_ID']!, // App ID
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProjectFormProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
      onGenerateRoute: AppRoutes.generateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final profileProvider = Provider.of<ProfileProvider>(
          context,
          listen: false,
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // semisal nutup aplikasi tanpa log out
          if (profileProvider.profile == null) {
            return const LoginScreen();
          }

          if (profileProvider.profile!.role == "admin") {
            return const AdminMainScreen();
          } else {
            return const MainScreen();
          }
        }

        return const LoginScreen();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  int _portfolioTabIndex = 0; // <- simpan index tab portfolio
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<String> _titles = ['Profile', 'My Portfolio', 'My Contact'];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final List<Widget> screens = [
      ProfileScreen(),
      PortfolioScreen(
        withScaffold: false,
        onTabChanged: (index) {
          setState(() {
            _portfolioTabIndex = index;
          });
        },
      ),
      ContactScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
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
          setState(() {
            _currentIndex = index;
            if (index == 1) {
              _portfolioTabIndex = 0; // reset ke tab awal
            }
          });
        },
        children: screens, // list of widgets
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.work),
            label: 'My Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: ' My Contact',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1 && _portfolioTabIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addPortfolio);
              },
              child: const Icon(Icons.add),
            )
          : null,
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
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
