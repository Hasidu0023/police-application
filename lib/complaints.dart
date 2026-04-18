import 'package:flutter/material.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints")),
      body: const Center(
        child: Text("File and Track Complaints 🚨", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}