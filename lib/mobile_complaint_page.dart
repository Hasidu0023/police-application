import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MobileComplaintPage extends StatefulWidget {
  const MobileComplaintPage({super.key});

  @override
  State<MobileComplaintPage> createState() => _MobileComplaintPageState();
}

class _MobileComplaintPageState extends State<MobileComplaintPage> {
  final _formKey = GlobalKey<FormState>();

  // ================= PERSONAL =================
  final name = TextEditingController();
  final nic = TextEditingController();
  final contact = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();

  String? selectedDistrict;

  // ================= PHONE =================
  final phoneBrand = TextEditingController();
  final phoneModel = TextEditingController();
  final color = TextEditingController();
  final imei = TextEditingController();
  final simNumber = TextEditingController();

  String detectedNetwork = "";

  // ================= INCIDENT =================
  final incidentDate = TextEditingController();
  final incidentTime = TextEditingController();
  final location = TextEditingController();
  final description = TextEditingController();

  String? selectedIncidentType;

  bool showReview = false;

  // ================= DATA =================
  List<String> districts = [
    "Colombo",
    "Gampaha",
    "Kalutara",
    "Kandy",
    "Matale",
    "Nuwara Eliya",
    "Galle",
    "Matara",
    "Hambantota",
    "Jaffna",
    "Kilinochchi",
    "Mannar",
    "Mullaitivu",
    "Vavuniya",
    "Trincomalee",
    "Batticaloa",
    "Ampara",
    "Kurunegala",
    "Puttalam",
    "Anuradhapura",
    "Polonnaruwa",
    "Badulla",
    "Monaragala",
    "Ratnapura",
    "Kegalle",
  ];

  List<String> incidentTypes = [
    "Lost",
    "Stolen",
    "Snatched",
    "Misplaced",
    "Robbery",
    "Suspicious Missing",
    "SIM / Cyber Fraud",
  ];

  // ================= NETWORK DETECTION =================
  String getNetworkFromSim(String number) {
    if (number.length < 3) return "Invalid";

    String prefix = number.substring(0, 3);

    if (["070", "071", "074", "077"].contains(prefix)) {
      return "Dialog";
    } else if (["072", "078"].contains(prefix)) {
      return "Mobitel / Hutch";
    } else if (["075"].contains(prefix)) {
      return "Airtel";
    } else {
      return "Unknown";
    }
  }

  // ================= VALIDATION =================
  String? validateName(String v) {
    if (v.isEmpty) return "Name required";
    if (!RegExp(r'^[a-zA-Z ]{1,50}$').hasMatch(v)) {
      return "Only letters (max 50)";
    }
    return null;
  }

  String? validateNIC(String nic) {
    if (nic.isEmpty) return "NIC required";
    if (RegExp(r'^[0-9]{9}[VXvx]$').hasMatch(nic)) return null;
    if (RegExp(r'^[0-9]{12}$').hasMatch(nic)) return null;
    return "Invalid NIC";
  }

  String? validatePhone(String v) {
    if (v.isEmpty) return "Required";
    if (!RegExp(r'^07[0-9]{8}$').hasMatch(v)) {
      return "Invalid phone number";
    }
    return null;
  }

  String? validateEmail(String v) {
    if (v.isEmpty) return "Required";
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
      return "Invalid email";
    }
    return null;
  }

  String? validateAddress(String v) {
    if (v.isEmpty) return "Required";
    if (v.length < 10) return "Min 10 characters";
    return null;
  }

  // ================= SUBMIT =================
  Future<void> submitData() async {
    await FirebaseFirestore.instance
        .collection("MobilePhoneLostComplaint")
        .add({
          "name": name.text,
          "nic": nic.text,
          "contact": contact.text,
          "email": email.text,
          "address": address.text,
          "district": selectedDistrict,

          "phoneBrand": phoneBrand.text,
          "phoneModel": phoneModel.text,
          "color": color.text,
          "imei": imei.text,
          "simNumber": simNumber.text,
          "network": detectedNetwork,

          "incidentDate": incidentDate.text,
          "incidentTime": incidentTime.text,
          "location": location.text,
          "incidentType": selectedIncidentType,
          "description": description.text,

          "createdAt": Timestamp.now(),
        });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint Submitted Successfully")),
    );

    // CLEAR ALL
    name.clear();
    nic.clear();
    contact.clear();
    email.clear();
    address.clear();
    phoneBrand.clear();
    phoneModel.clear();
    color.clear();
    imei.clear();
    simNumber.clear();
    incidentDate.clear();
    incidentTime.clear();
    location.clear();
    description.clear();

    setState(() {
      showReview = false;
      selectedDistrict = null;
      selectedIncidentType = null;
      detectedNetwork = "";
    });

    _formKey.currentState!.reset();
  }

  // ================= FIELD =================
  Widget field(
    TextEditingController c,
    String label, {
    String? Function(String)? validator,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: c,
        maxLength: maxLength,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => validator != null ? validator(v!) : null,
      ),
    );
  }

  Widget title(String t) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget review(String t, String v) =>
      ListTile(title: Text(t), subtitle: Text(v.isEmpty ? "-" : v));

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mobile Complaint")),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // ================= PERSONAL =================
              title("Personal Information"),
              field(name, "Name", validator: validateName),
              field(nic, "NIC", validator: validateNIC),
              field(contact, "Contact", validator: validatePhone),
              field(email, "Email", validator: validateEmail),
              field(address, "Address", validator: validateAddress),

              DropdownButtonFormField<String>(
                value: selectedDistrict,
                decoration: const InputDecoration(
                  labelText: "District",
                  border: OutlineInputBorder(),
                ),
                items: districts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) => setState(() => selectedDistrict = v),
                validator: (v) => v == null ? "Select district" : null,
              ),

              const SizedBox(height: 10),

              // ================= PHONE =================
              title("Phone Information"),

              field(
                phoneBrand,
                "Phone Brand",
                maxLength: 10,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              field(
                phoneModel,
                "Phone Model",
                maxLength: 10,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              field(
                color,
                "Color",
                maxLength: 10,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              field(
                imei,
                "IMEI",
                maxLength: 15,
                validator: (v) => v!.length > 15 ? "Invalid IMEI" : null,
              ),

              // ================= SIM NUMBER =================
              TextFormField(
                controller: simNumber,
                maxLength: 10,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: "SIM Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  if (value.length >= 3) {
                    setState(() {
                      detectedNetwork = getNetworkFromSim(value);
                    });
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (!RegExp(r'^07[0-9]{8}$').hasMatch(v)) {
                    return "Invalid Sri Lankan number";
                  }
                  if (getNetworkFromSim(v) == "Unknown") {
                    return "Invalid network prefix";
                  }
                  return null;
                },
              ),

              // ================= DETECTED NETWORK =================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Detected Network",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  controller: TextEditingController(text: detectedNetwork),
                ),
              ),

              const SizedBox(height: 10),

              // ================= INCIDENT =================
              title("Incident Information"),

              DropdownButtonFormField<String>(
                value: selectedIncidentType,
                decoration: const InputDecoration(
                  labelText: "Incident Type",
                  border: OutlineInputBorder(),
                ),
                items: incidentTypes
                    .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                    .toList(),
                onChanged: (v) => setState(() => selectedIncidentType = v),
                validator: (v) => v == null ? "Select type" : null,
              ),

              TextFormField(
                controller: incidentDate,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Incident Date"),
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (d != null) {
                    incidentDate.text = d.toString().split(" ")[0];
                  }
                },
              ),

              TextFormField(
                controller: incidentTime,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Incident Time"),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (t != null) {
                    incidentTime.text = t.format(context);
                  }
                },
              ),

              field(location, "Location", maxLength: 20),
              field(description, "Description", maxLength: 100),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => showReview = true);
                    }
                  },
                  child: const Text("Review Details"),
                ),
              ),

              if (showReview) ...[
                title("Review & Submit"),

                review("Name", name.text),
                review("NIC", nic.text),
                review("Contact", contact.text),
                review("Email", email.text),
                review("Address", address.text),
                review("District", selectedDistrict ?? ""),

                review("Brand", phoneBrand.text),
                review("Model", phoneModel.text),
                review("Color", color.text),
                review("IMEI", imei.text),
                review("SIM", simNumber.text),
                review("Network", detectedNetwork),

                review("Type", selectedIncidentType ?? ""),
                review("Date", incidentDate.text),
                review("Time", incidentTime.text),
                review("Location", location.text),
                review("Description", description.text),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: submitData,
                    child: const Text("Submit Complaint"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
