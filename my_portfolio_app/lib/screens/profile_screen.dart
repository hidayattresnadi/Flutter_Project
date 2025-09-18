import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
              SizedBox(height: 20),
              buildSocialLinks(
                context,
                profile?.email,
                profile?.linkedIn,
                profile?.github,
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

Widget buildSocialLinks(
  BuildContext context,
  String? email,
  String? linkedIn,
  String? github,
) {
  final String githubUrl = 'https://github.com/$github';
  final String emailLink = 'mailto:$email';

  Future<void> launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  return Card(
    color: Colors.black,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "Social Links",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.github,
                  color: Colors.white,
                ),
                tooltip: 'GitHub',
                onPressed: () {
                  if (github != null) {
                    launchLink(githubUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please add your github',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.email, color: Colors.redAccent),
                tooltip: 'Email',
                onPressed: () {
                  if (email != null) {
                    launchLink(emailLink);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please add your email',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: Colors.lightBlueAccent,
                ),
                tooltip: 'LinkedIn',
                onPressed: () {
                  if (linkedIn != null) {
                    launchLink(linkedIn);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please add your linkedIn url',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
