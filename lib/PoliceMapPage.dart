import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliceMapPage extends StatefulWidget {
  const PoliceMapPage({super.key});

  @override
  State<PoliceMapPage> createState() => _PoliceMapPageState();
}

class _PoliceMapPageState extends State<PoliceMapPage> {
  bool _opened = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openGoogleMaps();
    });
  }

  Future<void> _openGoogleMaps() async {
    if (_opened) return;
    _opened = true;

    // ✅ Clean Google Maps search URL
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=police+stations+in+sri+lanka",
    );

    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // 🔥 opens Google Maps / browser
      );
    } catch (e) {
      _showError("Failed to open Google Maps");
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Police Map"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text("Opening Google Maps...", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
