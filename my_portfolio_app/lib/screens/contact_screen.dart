import 'package:flutter/material.dart';
import 'package:my_portfolio_app/provider/profile_provider.dart';
import 'package:provider/provider.dart';

String office = "Tech Company";

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildProfileHeader(
                profile?.name,
                profile?.profession,
                profile?.photo,
              ),
              Divider(height: 24),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              buildProfileInfo(
                profile?.email,
                profile?.phone,
                profile?.address,
              ),
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

Widget buildProfileInfo(String? email, String? phone, String? address) {
  return Column(
    children: [
      buildPaddingContact(
        icon: Icons.email,
        info: email ?? "No enail provided",
        color: Colors.blue,
      ),
      buildPaddingContact(
        icon: Icons.phone,
        info: phone ?? "Unknown",
        color: Colors.green,
      ),
      buildPaddingContact(
        icon: Icons.location_on,
        info: address ?? "Not specified",
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
