import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

String name = "Muhammad Hidayat Tresnadi";
String profession = "Mobile Developer";
String email = "john.doe@email.com";
String phone = "+62 812-3456-7890";
String address = "Jakarta, Indonesia";
String bio =
    "Passionate mobile developer with 3+ years experience in Flutter and React Native. Love creating beautiful and functional mobile applications.";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Action for edit button
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileHeader(),
                Divider(height: 24),
                buildProfileInfo(),
                Divider(height: 24),
                buildProfileBio(),
              ],
            ),
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

Widget buildProfileInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.email, color: Colors.blue),
          SizedBox(width: 10),
          Text(email, style: TextStyle(fontSize: 17)),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Icon(Icons.phone, color: Colors.green),
          SizedBox(width: 10),
          Text(phone, style: TextStyle(fontSize: 17)),
        ],
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Icon(Icons.location_on, color: Colors.red),
          SizedBox(width: 10),
          Text(address, style: TextStyle(fontSize: 17)),
        ],
      ),
    ],
  );
}

Widget buildProfileBio() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "About Me",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text(bio, style: TextStyle(fontSize: 16)),
    ],
  );
}
