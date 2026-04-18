import 'package:flutter/material.dart';

// IMPORT YOUR SUB PAGES
import 'mobile_complaint_page.dart';
import 'igp_complaint_page.dart';
import 'feedback_page.dart';

class EServicesPage extends StatelessWidget {
  const EServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("E-Services"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📱 Mobile Complaint
            _buildServiceCard(
              context,
              title: "Mobile Complaint",
              subtitle: "Report lost or stolen phone",
              icon: Icons.phone_android,
              color: Colors.blue,
              page: const MobileComplaintPage(),
            ),

            const SizedBox(height: 15),

            // 👮 IGP Complaint
            _buildServiceCard(
              context,
              title: "Tell IGP",
              subtitle: "Send complaint to Inspector General",
              icon: Icons.local_police,
              color: Colors.red,
              page: const IGPComplaintPage(),
            ),

            const SizedBox(height: 15),

            // 💬 Feedback
            _buildServiceCard(
              context,
              title: "Community Feedback",
              subtitle: "Share your feedback",
              icon: Icons.feedback,
              color: Colors.green,
              page: const FeedbackPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(width: 16),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),

            // ARROW
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}


