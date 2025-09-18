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
import 'package:my_portfolio_app/screens/main_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:my_portfolio_app/screens/splash_screen.dart';
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
            return SplashScreen();
          }

          if (profileProvider.profile!.role == "admin") {
            return const AdminMainScreen();
          } else {
            return const MainScreen();
          }
        }

        return SplashScreen();
      },
    );
  }
}
