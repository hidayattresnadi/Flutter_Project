import 'package:flutter/material.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileHeader(
                profile?.name,
                profile?.profession,
                profile?.photo,
              ),
              Divider(height: 24),
              buildMyPortfolio(context),
              SizedBox(height: 30),
              buildProfileInfo(
                profile?.email,
                profile?.phone,
                profile?.address,
              ),
              SizedBox(height: 30),
              buildProfileBio(profile?.bio),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildProfileHeader(String? name, String? profession, String? photo) {
  return Row(
    children: [
      CircleAvatar(
        radius: 55,
        backgroundImage: photo != null ? NetworkImage(photo) : null,
        child: photo == null ? const Icon(Icons.person, size: 55) : null,
      ),
      SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? "No name provided",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            Text(
              profession ?? "Not specified",
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
                  Navigator.pushNamed(context, AppRoutes.portfolioList);
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

Widget buildProfileInfo(String? email, String? phone, String? address) {
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
          label: email ?? "No enail provided",
          padding: 25.0,
          topPadding: 25.0,
        ),
        Divider(height: 0, thickness: 2, color: Colors.white),
        buildReusableColumn(
          icon: Icons.phone,
          label: phone ?? "Unknown",
          padding: 25.0,
          topPadding: 25.0,
        ),
        Divider(height: 0, thickness: 2, color: Colors.white),
        buildReusableColumn(
          icon: Icons.location_on,
          label: address ?? "Not specified",
          padding: 25.0,
          topPadding: 25.0,
        ),
      ],
    ),
  );
}

Widget buildProfileBio(String? bio) {
  return Card(
    color: Colors.black,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          child: Text(
            bio ?? 'No bio provided',
            style: TextStyle(fontSize: 20, color: Colors.white),
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
