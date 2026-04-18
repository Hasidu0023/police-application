import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(text: "Press Releases", icon: Icon(Icons.newspaper)),
    Tab(text: "Notable Services", icon: Icon(Icons.verified)),
    Tab(text: "Special Events", icon: Icon(Icons.event)),
    Tab(text: "Wanted Persons", icon: Icon(Icons.warning)),
    Tab(text: "Missing Persons", icon: Icon(Icons.person_off)),
    Tab(text: "Tender Notices", icon: Icon(Icons.description)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Media Center",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 63, 153, 255),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: true,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          padding: const EdgeInsets.symmetric(horizontal: 5),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PressReleasesPage(),
          NotableServicesPage(),
          SpecialEventsPage(),
          WantedPersonsPage(),
          MissingPersonsPage(),
          TenderNoticesPage(),
        ],
      ),
    );
  }
}

// ==================== PRESS RELEASES PAGE ====================

class PressReleasesPage extends StatefulWidget {
  const PressReleasesPage({super.key});

  @override
  State<PressReleasesPage> createState() => _PressReleasesPageState();
}

class _PressReleasesPageState extends State<PressReleasesPage> {
  final CollectionReference _pressReleasesCollection = FirebaseFirestore
      .instance
      .collection('PressReleases');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _pressReleasesCollection
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.newspaper, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Press Releases Available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for updates',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Data loaded successfully
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            // Extract data with proper type conversion
            final String title = data['title']?.toString() ?? 'Untitled';
            final String date =
                data['date']?.toString() ?? 'Date not specified';
            final String summary =
                data['summary']?.toString() ?? 'No description available';
            final bool isImportant =
                data['isImportant'] == true || data['isImportant'] == 'true';

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isImportant
                      ? Border(
                          left: BorderSide(
                            color: Colors.red.shade700,
                            width: 4,
                          ),
                        )
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isImportant ? Colors.red.shade700 : Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        summary,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.blue),
                    onPressed: () => _showReleaseDetails(
                      title: title,
                      date: date,
                      summary: summary,
                      isImportant: isImportant,
                    ),
                  ),
                  onTap: () => _showReleaseDetails(
                    title: title,
                    date: date,
                    summary: summary,
                    isImportant: isImportant,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showReleaseDetails({
    required String title,
    required String date,
    required String summary,
    required bool isImportant,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (isImportant)
              const Icon(Icons.priority_high, color: Colors.red, size: 20),
            if (isImportant) const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date: $date",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(summary, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For more information, please contact:",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "📞 Police Media Division: 0112854880",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "📧 Email: media@police.gov.lk",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

// ==================== NOTABLE SERVICES PAGE ====================
class NotableServicesPage extends StatelessWidget {
  const NotableServicesPage({super.key});

  final List<Map<String, dynamic>> services = const [
    {
      "title": "24/7 Emergency Response",
      "icon": Icons.emergency,
      "color": 0xFFE53935,
      "description":
          "Rapid response team available round the clock for emergency situations.",
      "details":
          "Call 119 or 118 for immediate assistance. Average response time under 10 minutes.",
    },
    {
      "title": "Community Policing Program",
      "icon": Icons.people,
      "color": 0xFF1E88E5,
      "description":
          "Building trust and cooperation between police and local communities.",
      "details":
          "Regular community meetings, school programs, and neighborhood watch initiatives.",
    },
    {
      "title": "Women & Child Protection",
      "icon": Icons.family_restroom,
      "color": 0xFF9C27B0,
      "description":
          "Specialized unit dedicated to protecting vulnerable individuals.",
      "details":
          "24/7 helpline for women and children in distress. Confidential counseling available.",
    },
    {
      "title": "Cyber Crime Investigation",
      "icon": Icons.security,
      "color": 0xFF00ACC1,
      "description":
          "Advanced cyber forensics and digital crime investigation unit.",
      "details":
          "Report online fraud, harassment, and cyber crimes through dedicated portal.",
    },
    {
      "title": "Traffic Management System",
      "icon": Icons.traffic,
      "color": 0xFFF57C00,
      "description": "Modern traffic control and accident response system.",
      "details":
          "Real-time traffic updates, accident reporting, and emergency vehicle routing.",
    },
    {
      "title": "Victim Support Services",
      "icon": Icons.support_agent,
      "color": 0xFF43A047,
      "description": "Comprehensive support for crime victims and witnesses.",
      "details":
          "Counseling, legal aid, and protection services for victims of crime.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () => _showServiceDetails(context, service),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(service["color"]).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service["icon"],
                      size: 40,
                      color: Color(service["color"]),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    service["title"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service["description"],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showServiceDetails(BuildContext context, Map<String, dynamic> service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(service["icon"], color: Color(service["color"])),
            const SizedBox(width: 12),
            Expanded(child: Text(service["title"])),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service["details"], style: const TextStyle(height: 1.5)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "For assistance, contact:",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Police Emergency: 119",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

// ==================== SPECIAL EVENTS PAGE ====================
class SpecialEventsPage extends StatefulWidget {
  const SpecialEventsPage({super.key});

  @override
  State<SpecialEventsPage> createState() => _SpecialEventsPageState();
}

class _SpecialEventsPageState extends State<SpecialEventsPage> {
  final CollectionReference _specialEventsCollection = FirebaseFirestore
      .instance
      .collection('SpecialEvent');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _specialEventsCollection
          .orderBy('date', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Special Events Available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for updates',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Data loaded successfully
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            // Extract data with proper type conversion
            final String title = data['title']?.toString() ?? 'Untitled';
            final String date =
                data['date']?.toString() ?? 'Date not specified';
            final String location =
                data['location']?.toString() ?? 'Location not specified';
            final String description =
                data['description']?.toString() ?? 'No description available';
            final String status =
                data['status']?.toString().toLowerCase() ?? 'upcoming';

            // Determine icon based on event type or status
            IconData eventIcon = _getEventIcon(title, status);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _showEventDetails(
                  title: title,
                  date: date,
                  location: location,
                  description: description,
                  status: status,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: status == "ongoing"
                              ? Colors.green.shade100
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          eventIcon,
                          size: 32,
                          color: status == "ongoing"
                              ? Colors.green
                              : Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: status == "ongoing"
                                        ? Colors.green
                                        : status == "completed"
                                        ? Colors.grey
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    status.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: const TextStyle(fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEventDetails({
    required String title,
    required String date,
    required String location,
    required String description,
    required String status,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(status.toUpperCase()),
              backgroundColor: status == "ongoing"
                  ? Colors.green
                  : status == "completed"
                  ? Colors.grey
                  : Colors.orange,
              labelStyle: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(date),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(location)),
              ],
            ),
            const Divider(),
            Text(description),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For more information, please contact:",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "📞 Police Media Division: 0112854880",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "📧 Email: media@police.gov.lk",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          if (status == "ongoing")
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showRegistrationDialog();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Register Interest"),
            ),
        ],
      ),
    );
  }

  void _showRegistrationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Register for Event"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("To register for this event, please contact:"),
            SizedBox(height: 12),
            Text(
              "📞 Hotline: 0112854880",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "📧 Email: events@police.gov.lk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(String title, String status) {
    if (status == "completed") {
      return Icons.event_available;
    }

    String lowerTitle = title.toLowerCase();
    if (lowerTitle.contains("celebration") || lowerTitle.contains("day")) {
      return Icons.celebration;
    } else if (lowerTitle.contains("safety") ||
        lowerTitle.contains("awareness")) {
      return Icons.safety_check;
    } else if (lowerTitle.contains("traffic")) {
      return Icons.directions_car;
    } else if (lowerTitle.contains("recruitment") ||
        lowerTitle.contains("drive")) {
      return Icons.how_to_reg;
    } else if (lowerTitle.contains("drug") ||
        lowerTitle.contains("prevention")) {
      return Icons.health_and_safety;
    } else if (lowerTitle.contains("workshop") ||
        lowerTitle.contains("training")) {
      return Icons.school;
    }
    return Icons.event;
  }
}

// ==================== WANTED PERSONS PAGE ====================
class WantedPersonsPage extends StatefulWidget {
  const WantedPersonsPage({super.key});

  @override
  State<WantedPersonsPage> createState() => _WantedPersonsPageState();
}

class _WantedPersonsPageState extends State<WantedPersonsPage> {
  final CollectionReference _wantedPersonsCollection = FirebaseFirestore
      .instance
      .collection('WantedPersons');

  // Generate a consistent color based on name
  int _getColorFromName(String name) {
    final List<int> colors = [
      0xFFE53935, // Red
      0xFFF57C00, // Orange
      0xFF1E88E5, // Blue
      0xFF9C27B0, // Purple
      0xFF43A047, // Green
      0xFFD32F2F, // Dark Red
      0xFFF39C12, // Yellow/Orange
      0xFF8E24AA, // Deep Purple
    ];

    int hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }

  // Generate initials from name
  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '?';
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _wantedPersonsCollection
          .orderBy('name', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Wanted Persons at this Time',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for updates',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Data loaded successfully
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            // Extract data with proper type conversion
            final String name = data['name']?.toString() ?? 'Unknown';
            final String alias = data['alias']?.toString() ?? 'N/A';
            final String age = data['age']?.toString() ?? 'Unknown';
            final String lastSeen = data['lastSeen']?.toString() ?? 'Unknown';
            final String crime = data['crime']?.toString() ?? 'Unknown';
            final String reward = data['reward']?.toString() ?? 'Not specified';
            final String imageInitial =
                data['imageInitial']?.toString() ?? _getInitials(name);

            // Use provided color or generate from name
            final int colorValue = data['color'] != null
                ? int.tryParse(data['color'].toString()) ??
                      _getColorFromName(name)
                : _getColorFromName(name);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _showWantedDetails(
                  context,
                  name: name,
                  alias: alias,
                  age: age,
                  lastSeen: lastSeen,
                  crime: crime,
                  reward: reward,
                  imageInitial: imageInitial,
                  colorValue: colorValue,
                  docId: doc.id,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(colorValue).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red.shade700,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color(colorValue),
                          radius: 33,
                          child: Text(
                            imageInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (alias != 'N/A')
                              Text(
                                "Alias: $alias",
                                style: const TextStyle(fontSize: 13),
                              ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                crime,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (reward != 'Not specified')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                reward,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Icon(
                            Icons.warning,
                            color: Colors.red.shade700,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showWantedDetails(
    BuildContext context, {
    required String name,
    required String alias,
    required String age,
    required String lastSeen,
    required String crime,
    required String reward,
    required String imageInitial,
    required int colorValue,
    required String docId,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(colorValue),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  imageInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (alias != 'N/A') _infoRow("Alias", alias),
            if (age != 'Unknown') _infoRow("Age", age),
            if (lastSeen != 'Unknown') _infoRow("Last Seen", lastSeen),
            _infoRow("Crime", crime),
            if (reward != 'Not specified') _infoRow("Reward", reward),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "⚠️ If you have any information, please contact the nearest police station or call 119.",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () => _showReportDialog(context, name, docId),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Report Information"),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(
    BuildContext context,
    String personName,
    String docId,
  ) {
    final TextEditingController infoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report Information about $personName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Please provide any information you have:",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: infoController,
              decoration: const InputDecoration(
                hintText: "Enter your information here...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            const Text(
              "Your identity will be kept confidential.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (infoController.text.isNotEmpty) {
                _submitReport(docId, personName, infoController.text);
                Navigator.pop(context); // Close report dialog
                Navigator.pop(context); // Close details dialog
                _showThankYouDialog();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Submit Report"),
          ),
        ],
      ),
    );
  }

  void _submitReport(String docId, String personName, String information) {
    // Here you can save the report to Firestore or send to an API
    print("Report submitted for $personName (ID: $docId): $information");

    // Optional: Save reports to a separate collection
    FirebaseFirestore.instance
        .collection('WantedPersonReports')
        .add({
          'wantedPersonId': docId,
          'personName': personName,
          'information': information,
          'reportedAt': FieldValue.serverTimestamp(),
          'status': 'pending',
        })
        .catchError((error) {
          print("Error submitting report: $error");
        });
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thank You"),
        content: const Text(
          "Your information has been submitted successfully. The authorities will review it promptly.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(": $value")),
        ],
      ),
    );
  }
}

// ==================== MISSING PERSONS PAGE ====================
class MissingPersonsPage extends StatefulWidget {
  const MissingPersonsPage({super.key});

  @override
  State<MissingPersonsPage> createState() => _MissingPersonsPageState();
}

class _MissingPersonsPageState extends State<MissingPersonsPage> {
  final CollectionReference _missingPersonsCollection = FirebaseFirestore
      .instance
      .collection('MissingPersons');

  // Generate a consistent color based on name
  int _getColorFromName(String name) {
    final List<int> colors = [
      0xFFE53935, // Red
      0xFFF57C00, // Orange
      0xFF1E88E5, // Blue
      0xFF9C27B0, // Purple
      0xFF43A047, // Green
      0xFFD32F2F, // Dark Red
      0xFFF39C12, // Yellow/Orange
      0xFF8E24AA, // Deep Purple
      0xFF00ACC1, // Cyan
      0xFF7CB342, // Light Green
    ];

    int hash = name.hashCode.abs();
    return colors[hash % colors.length];
  }

  // Generate initials from name
  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '?';
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _missingPersonsCollection
          .orderBy('missingSince', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Missing Persons Reports',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for updates',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Data loaded successfully
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            // Extract data with proper type conversion
            final String name = data['name']?.toString() ?? 'Unknown';
            final String age = data['age']?.toString() ?? 'Unknown';
            final String gender = data['gender']?.toString() ?? 'Not specified';
            final String missingSince =
                data['missingSince']?.toString() ?? 'Date not specified';
            final String lastSeen =
                data['lastSeen']?.toString() ?? 'Location not specified';
            final String description =
                data['description']?.toString() ?? 'No description available';
            final String imageInitial =
                data['imageInitial']?.toString() ?? _getInitials(name);

            // Use provided color or generate from name
            final int colorValue = data['color'] != null
                ? int.tryParse(data['color'].toString()) ??
                      _getColorFromName(name)
                : _getColorFromName(name);

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _showMissingDetails(
                  context,
                  name: name,
                  age: age,
                  gender: gender,
                  missingSince: missingSince,
                  lastSeen: lastSeen,
                  description: description,
                  imageInitial: imageInitial,
                  colorValue: colorValue,
                  docId: doc.id,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(colorValue).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color(colorValue),
                          radius: 28,
                          child: Text(
                            imageInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "$age yrs • $gender",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    lastSeen,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.red.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Missing since: $missingSince",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showMissingDetails(
    BuildContext context, {
    required String name,
    required String age,
    required String gender,
    required String missingSince,
    required String lastSeen,
    required String description,
    required String imageInitial,
    required int colorValue,
    required String docId,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(colorValue),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  imageInitial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (age != 'Unknown') _infoRow("Age", age),
            if (gender != 'Not specified') _infoRow("Gender", gender),
            if (missingSince != 'Date not specified')
              _infoRow("Missing Since", missingSince),
            if (lastSeen != 'Location not specified')
              _infoRow("Last Seen", lastSeen),
            if (description != 'No description available')
              _infoRow("Description", description),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "📞 If you have any information about this person, please contact the nearest police station or call 119.",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () => _showInformationDialog(context, name, docId),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Provide Information"),
          ),
        ],
      ),
    );
  }

  void _showInformationDialog(
    BuildContext context,
    String personName,
    String docId,
  ) {
    final TextEditingController infoController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Information about $personName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Please provide any information you have:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: infoController,
              decoration: const InputDecoration(
                hintText: "Enter your information here...",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            const Text(
              "Your contact information (optional):",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                hintText: "Phone number or email",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your identity will be kept confidential.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (infoController.text.isNotEmpty) {
                _submitInformation(
                  docId,
                  personName,
                  infoController.text,
                  contactController.text,
                );
                Navigator.pop(context); // Close info dialog
                Navigator.pop(context); // Close details dialog
                _showThankYouDialog();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Submit Information"),
          ),
        ],
      ),
    );
  }

  void _submitInformation(
    String docId,
    String personName,
    String information,
    String contact,
  ) {
    // Save the information to Firestore
    FirebaseFirestore.instance
        .collection('MissingPersonReports')
        .add({
          'missingPersonId': docId,
          'personName': personName,
          'information': information,
          'contactInfo': contact.isEmpty ? 'Not provided' : contact,
          'reportedAt': FieldValue.serverTimestamp(),
          'status': 'pending',
        })
        .then((value) {
          print("Information submitted successfully for $personName");

          // Optional: Update the missing person document to show that information was received
          FirebaseFirestore.instance
              .collection('MissingPersons')
              .doc(docId)
              .update({
                'reportsCount': FieldValue.increment(1),
                'lastReportAt': FieldValue.serverTimestamp(),
              })
              .catchError((error) {
                print("Error updating report count: $error");
              });
        })
        .catchError((error) {
          print("Error submitting information: $error");
        });
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thank You"),
        content: const Text(
          "Your information has been submitted successfully. The authorities will review it promptly and take necessary action.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(": $value")),
        ],
      ),
    );
  }
}

// ==================== TENDER NOTICES PAGE ====================
class TenderNoticesPage extends StatefulWidget {
  const TenderNoticesPage({super.key});

  @override
  State<TenderNoticesPage> createState() => _TenderNoticesPageState();
}

class _TenderNoticesPageState extends State<TenderNoticesPage> {
  final CollectionReference _tendersCollection = FirebaseFirestore.instance
      .collection('TenderNotices');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tendersCollection
          .orderBy('deadline', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No Tender Notices Available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Check back later for updates',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Data loaded successfully
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;

            // Extract data with proper type conversion
            final String title = data['title']?.toString() ?? 'Untitled';
            final String ref = data['ref']?.toString() ?? 'N/A';
            final String published =
                data['published']?.toString() ?? 'Date not specified';
            final String deadline =
                data['deadline']?.toString() ?? 'Date not specified';
            final String description =
                data['description']?.toString() ?? 'No description available';
            final String status =
                data['status']?.toString().toLowerCase() ?? 'open';

            // Calculate days remaining until deadline
            int daysRemaining = _calculateDaysRemaining(deadline);
            bool isUrgent = daysRemaining <= 7 && daysRemaining >= 0;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _showTenderDetails(
                  context,
                  title: title,
                  ref: ref,
                  published: published,
                  deadline: deadline,
                  description: description,
                  status: status,
                  docId: doc.id,
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Status Row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == "open"
                                  ? Colors.green
                                  : status == "closing"
                                  ? Colors.orange
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Reference Number
                      Text(
                        "Ref: $ref",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Published Date Row
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Published: $published",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Deadline Row with Box
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUrgent
                              ? Colors.red.shade50
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isUrgent
                                ? Colors.red.shade200
                                : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 16,
                              color: isUrgent
                                  ? Colors.red.shade700
                                  : Colors.red.shade400,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Submission Deadline",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    deadline,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isUrgent
                                          ? Colors.red.shade700
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (daysRemaining >= 0 && status == "open")
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isUrgent
                                      ? Colors.red.shade100
                                      : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "$daysRemaining",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isUrgent
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                      ),
                                    ),
                                    Text(
                                      "days left",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isUrgent
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Text(
                        description,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // View Details Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => _showTenderDetails(
                            context,
                            title: title,
                            ref: ref,
                            published: published,
                            deadline: deadline,
                            description: description,
                            status: status,
                            docId: doc.id,
                          ),
                          icon: const Icon(Icons.description, size: 16),
                          label: const Text("View Details"),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _calculateDaysRemaining(String deadline) {
    try {
      // Parse the deadline string (assuming format like "April 30, 2026" or "May 15, 2026")
      List<String> months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      DateTime now = DateTime.now();
      DateTime deadlineDate = DateTime.now();

      for (String month in months) {
        if (deadline.contains(month)) {
          int monthIndex = months.indexOf(month) + 1;
          String dayStr = deadline.split(' ')[1].replaceAll(',', '');
          int day = int.parse(dayStr);
          String yearStr = deadline.split(' ')[2];
          int year = int.parse(yearStr);

          deadlineDate = DateTime(year, monthIndex, day);
          break;
        }
      }

      return deadlineDate.difference(now).inDays;
    } catch (e) {
      return -1; // Return -1 if parsing fails
    }
  }

  void _showTenderDetails(
    BuildContext context, {
    required String title,
    required String ref,
    required String published,
    required String deadline,
    required String description,
    required String status,
    required String docId,
  }) {
    int daysRemaining = _calculateDaysRemaining(deadline);
    bool isExpired = daysRemaining < 0;
    bool isUrgent = daysRemaining <= 7 && daysRemaining >= 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow("Reference No", ref),
            _infoRow("Published Date", published),
            _infoRow("Submission Deadline", deadline),
            _infoRow("Status", status.toUpperCase()),
            if (daysRemaining >= 0 && !isExpired)
              Padding(
                padding: const EdgeInsets.only(left: 110, top: 4),
                child: Text(
                  isUrgent
                      ? "⚠️ URGENT: $daysRemaining days remaining"
                      : "$daysRemaining days remaining",
                  style: TextStyle(
                    fontSize: 11,
                    color: isUrgent
                        ? Colors.red.shade700
                        : Colors.grey.shade600,
                    fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            if (isExpired)
              Padding(
                padding: const EdgeInsets.only(left: 110, top: 4),
                child: Text(
                  "⏰ Deadline has passed",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Divider(),
            _infoRow("Description", description),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📄 Tender documents can be obtained from the Police Procurement Division.",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "💰 A non-refundable fee of Rs. 5,000 applies.",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "📞 For inquiries, contact: 0112854880",
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          if (!isExpired && status == "open")
            ElevatedButton.icon(
              onPressed: () =>
                  _downloadTenderNotice(context, title, ref, docId),
              icon: const Icon(Icons.download, size: 18),
              label: const Text("Download Notice"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          if (isExpired)
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.event_busy, size: 18),
              label: const Text("Expired"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
        ],
      ),
    );
  }

  void _downloadTenderNotice(
    BuildContext context,
    String title,
    String ref,
    String docId,
  ) {
    // Show download options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Download Tender Notice"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select download option:"),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text("PDF Document"),
              onTap: () {
                Navigator.pop(context);
                _simulateDownload(context, title, "PDF");
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.blue),
              title: const Text("Word Document"),
              onTap: () {
                Navigator.pop(context);
                _simulateDownload(context, title, "DOC");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _simulateDownload(BuildContext context, String title, String format) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Preparing download..."),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate download delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Download Started"),
          content: Text(
            "$title tender notice is being downloaded as $format format.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      // Here you would implement actual file download logic
      print("Downloading $title tender notice as $format");
    });
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(": $value")),
        ],
      ),
    );
  }
}
