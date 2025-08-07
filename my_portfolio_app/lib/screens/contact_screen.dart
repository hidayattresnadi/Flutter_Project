import 'package:flutter/material.dart';

String name = "Muhammad Hidayat Tresnadi";
String profession = "Mobile Developer";
String email = "john.doe@email.com";
String phone = "+62 812-3456-7890";
String address = "Jakarta, Indonesia";
String office = "Tech Company";

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildProfileHeader(),
              Divider(height: 24),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              buildProfileInfo(),
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

Widget buildProfileInfo() {
  return Column(
    children: [
      buildPaddingContact(icon: Icons.email, info: email, color: Colors.blue),
      buildPaddingContact(icon: Icons.phone, info: phone, color: Colors.green),
      buildPaddingContact(
        icon: Icons.location_on,
        info: address,
        color: Colors.red,
      ),
      buildPaddingContact(
        icon: Icons.apartment,
        info: office,
        color: Colors.black,
      ),
    ],
  );
}

Widget buildPaddingContact({
  required IconData icon,
  required String info,
  required Color color,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
    child: Card(
      color: Colors.amber.shade800,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(width: 40),
            Text(
              info,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
