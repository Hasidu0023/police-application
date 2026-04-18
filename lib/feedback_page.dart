import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final feedbackController = TextEditingController();

  String? selectedDistrict;
  String? selectedCategory;

  bool isLoading = false;

  // ================= DISTRICTS =================
  final List<String> sriLankaDistricts = [
    "Colombo","Gampaha","Kalutara",
    "Kandy","Matale","Nuwara Eliya",
    "Galle","Matara","Hambantota",
    "Jaffna","Kilinochchi","Mannar","Mullaitivu","Vavuniya",
    "Trincomalee","Batticaloa","Ampara",
    "Kurunegala","Puttalam",
    "Anuradhapura","Polonnaruwa",
    "Badulla","Monaragala",
    "Ratnapura","Kegalle"
  ];

  // ================= CATEGORY =================
  final List<String> categories = [
    "Public Safety Issue",
    "Police Service Feedback",
    "Suggestion / Improvement",
    "Complaint about service",
    "Community concern",
    "Traffic issue"
  ];

  // ================= VALIDATIONS =================

  String? validatePhone(String number) {
    if (number.isEmpty) {
      return "Phone number is required";
    }

    if (!RegExp(r'^07[0-9]{8}$').hasMatch(number)) {
      return "Enter valid Sri Lankan mobile number";
    }

    return null;
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return "Email is required";
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email)) {
      return "Enter a valid email address";
    }

    return null;
  }

  // ================= SEND =================
  Future<void> submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDistrict == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all dropdowns")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection("Community_Feedback")
          .add({
        "Name": nameController.text.trim(),
        "Contact_Number": contactController.text.trim(),
        "Email": emailController.text.trim(),
        "District": selectedDistrict,
        "Feedback_Category": selectedCategory,
        "Feedback_Message": feedbackController.text.trim(),
        "Date_Time": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback Submitted Successfully")),
      );

      _formKey.currentState!.reset();
      nameController.clear();
      contactController.clear();
      emailController.clear();
      feedbackController.clear();

      setState(() {
        selectedDistrict = null;
        selectedCategory = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community Feedback")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // ================= NAME =================
              TextFormField(
                controller: nameController,
                decoration: inputStyle("Your Name"),
                validator: (v) {
                  if (v!.isEmpty) return "Enter name";
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
                    return "Only letters allowed";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // ================= CONTACT =================
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Contact Number"),
                validator: (v) => validatePhone(v ?? ""),
              ),

              const SizedBox(height: 12),

              // ================= EMAIL =================
              TextFormField(
                controller: emailController,
                decoration: inputStyle("Email"),
                validator: (v) => validateEmail(v ?? ""),
              ),

              const SizedBox(height: 12),

              // ================= DISTRICT =================
              DropdownButtonFormField(
                value: selectedDistrict,
                decoration: inputStyle("District"),
                items: sriLankaDistricts
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => selectedDistrict = v),
                validator: (v) => v == null ? "Select district" : null,
              ),

              const SizedBox(height: 12),

              // ================= CATEGORY =================
              DropdownButtonFormField(
                value: selectedCategory,
                decoration: inputStyle("Feedback Category"),
                items: categories
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => selectedCategory = v),
                validator: (v) => v == null ? "Select category" : null,
              ),

              const SizedBox(height: 12),

              // ================= FEEDBACK =================
              TextFormField(
                controller: feedbackController,
                maxLines: 4,
                decoration: inputStyle("Feedback Message"),
                validator: (v) {
                  if (v!.isEmpty) return "Enter feedback";
                  if (!RegExp(r'^[a-zA-Z0-9 .,!?()\-]+$').hasMatch(v)) {
                    return "Only letters & numbers allowed";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ================= BUTTON =================
              ElevatedButton(
                onPressed: isLoading ? null : submitFeedback,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}