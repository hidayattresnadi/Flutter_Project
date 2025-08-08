import 'package:flutter/material.dart';

String fullName = "Muhammad Hidayat Tresnadi";
String position = "Junior Mobile Developer";
String department = "IT";
String email = "john.doe@email.com";
String phone = "+62 812-3456-7890";
String location = "Jakarta, Indonesia";
String bio =
    "Passionate mobile developer with 3+ years experience in Flutter and React Native. Love creating beautiful and functional mobile applications.";
String totalLeaves = "10 Taken";
String paySLips = "3 available";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileSection(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileInfo(),
                buildAdditionalInfo(),
                Divider(height: 0, thickness: 2),
                buildProfileBio(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCoverProfile() {
  return Container(height: 210, color: Color(0xFF004966));
}

Widget buildProfileHeader() {
  return Column(
    children: [
      CircleAvatar(
        radius: 55,
        backgroundImage: AssetImage('assets/images/profile.jpg'),
      ),
      SizedBox(height: 15),
      Column(
        children: [
          Text(
            fullName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          Text(
            position,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildProfileSection() {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [buildCoverProfile(), buildProfileHeader()],
  );
}

Widget buildAdditionalInfo() {
  return Padding(
    padding: EdgeInsets.only(top: 25.0, left: 5.0, right: 15.0, bottom: 25.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.airplanemode_active, color: Colors.pink),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Leaves",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              totalLeaves,
              style: TextStyle(fontSize: 17, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 70),
        Icon(Icons.wallet, color: Colors.pink),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payslips",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(paySLips, style: TextStyle(fontSize: 17, color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}

Widget buildProfileInfo() {
  return Column(
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
          "Employee Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      buildReusableColumn(
        icon: Icons.business,
        label: department,
        padding: 25.0,
        topPadding: 10.0,
      ),
      Divider(height: 0, thickness: 2),
      buildReusableColumn(
        icon: Icons.email,
        label: email,
        padding: 25.0,
        topPadding: 25.0,
      ),
      Divider(height: 0, thickness: 2),
      buildReusableColumn(
        icon: Icons.phone,
        label: phone,
        padding: 25.0,
        topPadding: 25.0,
      ),
      Divider(height: 0, thickness: 2),
      buildReusableColumn(
        icon: Icons.location_on,
        label: location,
        padding: 25.0,
        topPadding: 25.0,
      ),
      Divider(height: 0, thickness: 2),
    ],
  );
}

Widget buildProfileBio() {
  return Column(
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            Column(children: [Text(bio, style: TextStyle(fontSize: 16))]),
          ],
        ),
      ),
    ],
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
        Icon(icon, color: Colors.pink),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
