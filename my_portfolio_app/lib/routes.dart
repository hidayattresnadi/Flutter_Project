import 'package:flutter/material.dart';
import 'package:my_portfolio_app/main.dart';
import 'package:my_portfolio_app/screens/about_screen.dart';
import 'package:my_portfolio_app/screens/add_portfolio_form.dart';
import 'package:my_portfolio_app/screens/edit_profile_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:my_portfolio_app/screens/settings_screen.dart';

class AppRoutes {
  static const settingPage = '/settings';
  static const aboutPage = '/about';
  static const editProfile = '/edit_profile';
  static const addPortfolio = '/add_portfolio';
  static const portfolioList = '/list_portfolio';

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
      default:
        return MaterialPageRoute(builder: (_) => MainScreen());
    }
  }
}
