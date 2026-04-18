import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  // Function to make phone call
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Show snackbar if call fails
  void showCallError(BuildContext context, String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Could not call $phoneNumber"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.red),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Tap on any phone number to call directly",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 1. GENERAL GOVERNMENT & HELP LINES
            _buildCategorySection(
              title: "☎️ General Government & Help Lines",
              icon: Icons.account_balance,
              color: Colors.blue,
              contacts: [
                ContactItem(
                  name: "Government Information Center",
                  number: "1919",
                  description: "Any public service help, complaints, guidance",
                ),
                ContactItem(
                  name: "Police Information Desk",
                  number: "118 / 1191",
                  description: "Non-emergency police inquiries",
                  isMultiNumber: true,
                  numbers: ["118", "1191"],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 2. SPECIALIZED POLICE UNITS
            _buildCategorySection(
              title: "👮 Specialized Police Units",
              icon: Icons.local_police,
              color: Colors.indigo,
              contacts: [
                ContactItem(
                  name: "Police Headquarters (Colombo)",
                  number: "011-2444444",
                  description: "Main police HQ",
                ),
                ContactItem(
                  name: "Criminal Investigation Department (CID)",
                  number: "011-2320141",
                  description: "Serious investigations, sensitive complaints",
                ),
                ContactItem(
                  name: "Women & Children Bureau",
                  number: "011-2382209",
                  description: "Women & children protection",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3. TRAFFIC & ROAD EMERGENCIES
            _buildCategorySection(
              title: "🚓 Traffic & Road Emergencies",
              icon: Icons.traffic,
              color: Colors.orange,
              contacts: [
                ContactItem(
                  name: "Traffic Police HQ",
                  number: "011-2433333",
                  description:
                      "Traffic accidents, road issues, breakdown assistance",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 4. HOSPITAL EMERGENCY CONTACTS
            _buildCategorySection(
              title: "🏥 Hospital Emergency Contacts",
              icon: Icons.local_hospital,
              color: Colors.green,
              contacts: [
                ContactItem(
                  name: "National Hospital Colombo",
                  number: "011-2691111",
                  description: "Emergency unit coordination",
                ),
                ContactItem(
                  name: "Negombo General Hospital",
                  number: "011-2850253",
                  description: "Emergency unit coordination",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 5. AIRPORT & TOURIST HELP
            _buildCategorySection(
              title: "✈️ Airport & Tourist Help",
              icon: Icons.flight,
              color: Colors.purple,
              contacts: [
                ContactItem(
                  name: "Airport Police Katunayake",
                  number: "011-2252861",
                  description: "Airport emergencies",
                ),
                ContactItem(
                  name: "Tourist Police Hotline",
                  number: "1912",
                  description: "Foreign travelers, lost passports",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 6. WEATHER & DISASTER ALERTS
            _buildCategorySection(
              title: "🌊 Weather & Disaster Alerts",
              icon: Icons.wb_sunny,
              color: Colors.cyan,
              contacts: [
                ContactItem(
                  name: "Department of Meteorology",
                  number: "011-2681546",
                  description:
                      "Weather warnings, cyclone updates, rain forecasts",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 7. UTILITY EMERGENCY SERVICES
            _buildCategorySection(
              title: "⚡ Utility Emergency Services",
              icon: Icons.electrical_services,
              color: Colors.amber,
              contacts: [
                ContactItem(
                  name: "CEB Emergency Hotline",
                  number: "1987",
                  description: "Power failures, electric hazards",
                ),
                ContactItem(
                  name: "Water Board Hotline",
                  number: "1939",
                  description: "Water leaks, supply issues",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 8. GAS & HAZARD EMERGENCIES
            _buildCategorySection(
              title: "🧯 Gas & Hazard Emergencies",
              icon: Icons.whatshot,
              color: Colors.deepOrange,
              contacts: [
                ContactItem(
                  name: "LPG Gas Emergency (Litro)",
                  number: "1311",
                  description: "Gas leaks, explosions",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 9. SOCIAL & SUPPORT SERVICES
            _buildCategorySection(
              title: "🧍 Social & Support Services",
              icon: Icons.favorite,
              color: Colors.pink,
              contacts: [
                ContactItem(
                  name: "Women Help Line",
                  number: "1938",
                  description: "Domestic violence, harassment",
                ),
                ContactItem(
                  name: "Elder Abuse Help",
                  number: "1926",
                  description: "Elder abuse support",
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required IconData icon,
    required Color color,
    required List<ContactItem> contacts,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contacts List
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: contacts.map((contact) {
                return _buildContactTile(contact, color);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(ContactItem contact, Color categoryColor) {
    if (contact.isMultiNumber) {
      // For contacts with multiple numbers
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: categoryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 20, color: categoryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contact.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: contact.numbers!.map((number) {
                return ElevatedButton.icon(
                  onPressed: () => makePhoneCall(number),
                  icon: const Icon(Icons.call, size: 18),
                  label: Text(number),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: categoryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    } else {
      // For single number contacts
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: categoryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 20, color: categoryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contact.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => makePhoneCall(contact.number),
              icon: const Icon(Icons.call, size: 18),
              label: Text(contact.number),
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// Contact Item Model
class ContactItem {
  final String name;
  final String number;
  final String description;
  final bool isMultiNumber;
  final List<String>? numbers;

  ContactItem({
    required this.name,
    required this.number,
    required this.description,
    this.isMultiNumber = false,
    this.numbers,
  });
}
