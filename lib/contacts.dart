import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'TelephoneIndexPage.dart';
import 'PoliceMapPage.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  // 🚨 Call 119
  Future<void> _callEmergency() async {
    final Uri url = Uri.parse("tel:119");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Cannot make a call";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Dashboard"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // 📞 Telephone Index
            _buildCard(
              context,
              title: "Telephone Index",
              icon: Icons.phone,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TelephoneIndexPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🗺 Police Map
            _buildCard(
              context,
              title: "Police Station Map",
              icon: Icons.map,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PoliceMapPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // 🚨 Emergency Call
            _buildCard(
              context,
              title: "Emergency Call (119)",
              icon: Icons.warning,
              color: Colors.red,
              onTap: _callEmergency,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable Card Widget
  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}