import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IGPComplaintPage extends StatefulWidget {
  const IGPComplaintPage({super.key});

  @override
  State<IGPComplaintPage> createState() => _IGPComplaintPageState();
}

class _IGPComplaintPageState extends State<IGPComplaintPage> {
  final _formKey = GlobalKey<FormState>();

  final String messageId =
      DateTime.now().millisecondsSinceEpoch.toString();

  final fullNameController = TextEditingController();
  final nicController = TextEditingController();
  final contactController = TextEditingController();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  String? selectedDistrict;
  String? selectedMessageType;
  String? selectedPriority;

  bool isLoading = false;

  final List<String> sriLankaDistricts = [/* same list */];
  final List<String> messageTypes = [/* same list */];
  final List<String> priorities = ["High", "Medium", "Low"];

  String? validateNIC(String nic) {
    if (nic.isEmpty) return "NIC is required";
    if (RegExp(r'^[0-9]{9}[VXvx]$').hasMatch(nic)) return null;
    if (RegExp(r'^[0-9]{12}$').hasMatch(nic)) return null;
    return "Invalid Sri Lankan NIC number";
  }

  Future<void> sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDistrict == null ||
        selectedMessageType == null ||
        selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all dropdown values")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection("Sending_Message_to_IGP")
          .doc(messageId)
          .set({
        "Auto_Message_ID": messageId,
        "Full_Name": fullNameController.text.trim(),
        "NIC": nicController.text.trim(),
        "Contact_Number": contactController.text.trim(),
        "District": selectedDistrict,
        "Message_Type": selectedMessageType,
        "Priority_Level": selectedPriority,
        "Subject": subjectController.text.trim(),
        "Discription": messageController.text.trim(),
        "Date_Time": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message Sent Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  // ================= INPUT STYLE =================
  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text("Tell IGP"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.security, size: 40, color: Colors.blueAccent),
                  const SizedBox(height: 8),
                  const Text(
                    "IGP Complaint Portal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("Message ID: $messageId"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= FORM CARD =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      initialValue: messageId,
                      readOnly: true,
                      decoration: _inputStyle("Auto Message ID"),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: fullNameController,
                      decoration: _inputStyle("Full Name"),
                      maxLength: 40,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(v)) {
                          return "Only letters allowed";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: nicController,
                      decoration: _inputStyle("NIC"),
                      validator: (v) => validateNIC(v ?? ""),
                    ),

                    TextFormField(
                      controller: contactController,
                      decoration: _inputStyle("Contact Number"),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Required";
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(v)) {
                          return "Invalid phone number";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField(
                      value: selectedDistrict,
                      decoration: _inputStyle("District"),
                      items: sriLankaDistricts
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedDistrict = v),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField(
                      value: selectedMessageType,
                      decoration: _inputStyle("Message Type"),
                      items: messageTypes
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedMessageType = v),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField(
                      value: selectedPriority,
                      decoration: _inputStyle("Priority Level"),
                      items: priorities
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedPriority = v),
                    ),

                    const SizedBox(height: 12),

                    TextFormField(
                      controller: subjectController,
                      decoration: _inputStyle("Subject"),
                      maxLength: 100,
                    ),

                    TextFormField(
                      controller: messageController,
                      decoration: _inputStyle("Description"),
                      maxLines: 5,
                      maxLength: 1000,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : sendMessage,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Send to IGP",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}