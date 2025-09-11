import 'package:flutter/material.dart';
import 'package:my_portfolio_app/main.dart';
import 'package:my_portfolio_app/screens/about_screen.dart';
import 'package:my_portfolio_app/screens/add_portfolio_form.dart';
import 'package:my_portfolio_app/screens/admin/add_user_screen.dart';
import 'package:my_portfolio_app/screens/admin/admin_dashboard.dart';
import 'package:my_portfolio_app/screens/admin/admin_main_screen.dart';
import 'package:my_portfolio_app/screens/edit_profile_screen.dart';
import 'package:my_portfolio_app/screens/login_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:my_portfolio_app/screens/register_screen.dart';
import 'package:my_portfolio_app/screens/settings_screen.dart';

class AppRoutes {
  static const settingPage = '/settings';
  static const aboutPage = '/about';
  static const editProfile = '/edit_profile';
  static const addPortfolio = '/add_portfolio';
  static const portfolioList = '/list_portfolio';
  static const home = '/home';
  static const login = '/login';
  static const register = '/register';
  static const registerUser = '/register_user';
  static const admindashboard = '/admin_dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case settingPage:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case aboutPage:
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case addPortfolio:
        return MaterialPageRoute(builder: (_) => PortfolioFormScreen());
      case portfolioList:
        return MaterialPageRoute(
          builder: (_) => PortfolioScreen(withScaffold: true),
        );
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case admindashboard:
        return MaterialPageRoute(builder: (_) => AdminMainScreen());
      case registerUser:
        return MaterialPageRoute(builder: (_) => RegisterUserScreen());
      default:
        return MaterialPageRoute(builder: (_) => MainScreen());
    }
  }
}
