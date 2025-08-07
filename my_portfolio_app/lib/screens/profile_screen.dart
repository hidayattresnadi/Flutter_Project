import 'package:flutter/material.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';

String name = "Muhammad Hidayat Tresnadi";
String profession = "Mobile Developer";
String email = "john.doe@email.com";
String phone = "+62 812-3456-7890";
String address = "Jakarta, Indonesia";
String bio =
    "Passionate mobile developer with 3+ years experience in Flutter and React Native. Love creating beautiful and functional mobile applications.";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileHeader(),
              Divider(height: 24),
              buildMyPortfolio(context),
              SizedBox(height: 30),
              buildProfileInfo(),
              SizedBox(height: 30),
              buildProfileBio(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildProfileHeader() {
  return Row(
    children: [
      CircleAvatar(
        radius: 55,
        backgroundImage: AssetImage('assets/profile.jpg'),
      ),
      SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            Text(
              profession,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildMyPortfolio(BuildContext context) {
  return Card(
    color: Colors.black,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 25.0,
            left: 15.0,
            right: 25.0,
            bottom: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Portfolio",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PortfolioScreen(withScaffold: true),
                    ),
                  );
                },
                child: Icon(Icons.chevron_right_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildProfileInfo() {
  return Card(
    color: Colors.black,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 25.0,
            left: 15.0,
            right: 25.0,
            bottom: 15.0,
          ),
          child: Text(
            "My Contact",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Divider(height: 0, thickness: 2, color: Colors.white),
        buildReusableColumn(
          icon: Icons.email,
          label: email,
          padding: 25.0,
          topPadding: 25.0,
        ),
        Divider(height: 0, thickness: 2, color: Colors.white),
        buildReusableColumn(
          icon: Icons.phone,
          label: phone,
          padding: 25.0,
          topPadding: 25.0,
        ),
        Divider(height: 0, thickness: 2, color: Colors.white),
        buildReusableColumn(
          icon: Icons.location_on,
          label: address,
          padding: 25.0,
          topPadding: 25.0,
        ),
      ],
    ),
  );
}

Widget buildProfileBio() {
  return Card(
    color: Colors.black,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 25.0,
            left: 15.0,
            right: 25.0,
            bottom: 10.0,
          ),
          child: Text(
            "About Me",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 2.0,
            left: 15.0,
            right: 25.0,
            bottom: 15.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    bio,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildReusableColumn({
  required IconData icon,
  required String label,
  required double padding,
  required double topPadding,
}) {
  return Padding(
    padding: EdgeInsets.only(
      top: topPadding,
      left: 15.0,
      right: padding,
      bottom: padding,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.pink, size: 30),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
