import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/provider/project_provider.dart';
import 'package:my_portfolio_app/screens/contact_screen.dart';
import 'package:my_portfolio_app/screens/edit_profile_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ProjectFormProvider()),
      ],
      child: MyApp(),
    ),
  );
}

final PageController _pageController = PageController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
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

  final List<Widget> _screens = [
    ProfileScreen(),
    PortfolioScreen(withScaffold: false),
    ContactScreen(),
  ];
  final List<String> _titles = ['Profile', 'My Portfolio', 'My Contact'];

  @override
  Widget build(BuildContext context) {
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
                final profile = context.read<ProfileProvider>().profile;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: profile.name,
                      profession: profile.profession,
                      email: profile.email,
                      phone: profile.phone,
                      address: profile.address,
                      bio: profile.bio,
                    ),
                  ),
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
          });
        },
        children: _screens, // list of widgets
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
    );
  }
}
