import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ---------------- CONTROLLERS ----------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobileController = TextEditingController();
  final nicController = TextEditingController();
  final addressController = TextEditingController();

  DateTime? dob;

  String gender = "Male";
  String district = "Colombo";
  String policeDivision = "";

  // ---------------- ERROR STATES (REAL TIME UI) ----------------
  String? nameError;
  String? emailError;
  String? passwordError;
  String? phoneError;
  String? nicError;
  String? addressError;

  // ---------------- DATA ----------------
  Map<String, List<String>> policeData = {
    "Colombo": [
      "Colombo Fort",
      "Maradana",
      "Pettah",
      "Cinnamon Garden",
      "Borella",
      "Kollupitiya",
      "Wellawatte",
      "Dehiwala",
      "Mount Lavinia",
      "Narahenpita",
    ],
    "Gampaha": [
      "Negombo",
      "Gampaha",
      "Katunayake Airport",
      "Wattala",
      "Kelaniya",
      "Ja-Ela",
      "Kandana",
      "Minuwangoda",
      "Divulapitiya",
    ],
    "Kalutara": [
      "Kalutara",
      "Panadura",
      "Horana",
      "Beruwala",
      "Aluthgama",
      "Ingiriya",
    ],
    "Kandy": [
      "Kandy",
      "Peradeniya",
      "Gampola",
      "Katugastota",
      "Kadugannawa",
      "Nawalapitiya",
    ],
    "Matale": ["Matale", "Dambulla", "Galewela", "Ukuwela"],
    "Nuwara Eliya": [
      "Nuwara Eliya",
      "Hatton",
      "Talawakele",
      "Maskeliya",
      "Ragala",
    ],
    "Galle": ["Galle", "Hikkaduwa", "Ambalangoda", "Elpitiya", "Bentota"],
    "Matara": ["Matara", "Weligama", "Akuressa", "Dickwella", "Hakmana"],
    "Hambantota": ["Hambantota", "Tangalle", "Tissamaharama", "Ambalantota"],
    "Jaffna": ["Jaffna", "Chavakachcheri", "Point Pedro", "Kayts", "Nallur"],
    "Kilinochchi": ["Kilinochchi", "Paranthan", "Pallai"],
    "Mannar": ["Mannar", "Talaimannar", "Murunkan"],
    "Mullaitivu": ["Mullaitivu", "Oddusuddan", "Puthukkudiyiruppu"],
    "Vavuniya": ["Vavuniya", "Omanthai", "Cheddikulam"],
    "Trincomalee": ["Trincomalee", "Kinniya", "Kantale", "Nilaveli"],
    "Batticaloa": ["Batticaloa", "Kaluwanchikudy", "Valachchenai", "Eravur"],
    "Ampara": ["Ampara", "Kalmunai", "Akkaraipattu", "Sammanthurai"],
    "Kurunegala": ["Kurunegala", "Kuliyapitiya", "Nikaweratiya", "Wariyapola"],
    "Puttalam": ["Puttalam", "Chilaw", "Wennappuwa", "Marawila"],
    "Anuradhapura": [
      "Anuradhapura",
      "Kekirawa",
      "Thambuttegama",
      "Medawachchiya",
    ],
    "Polonnaruwa": ["Polonnaruwa", "Hingurakgoda", "Medirigiriya"],
    "Badulla": ["Badulla", "Bandarawela", "Ella", "Hali Ela"],
    "Monaragala": ["Monaragala", "Wellawaya", "Buttala"],
    "Ratnapura": ["Ratnapura", "Balangoda", "Embilipitiya", "Kahawatta"],
    "Kegalle": ["Kegalle", "Mawanella", "Warakapola", "Rambukkana"],
  };

  List<String> getDivisions() => policeData[district] ?? [];

  // ---------------- VALIDATION ----------------
  void validateFields() {
    setState(() {
      nameError = RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text)
          ? null
          : "Only letters allowed";

      emailError =
          RegExp(
            r'^[a-zA-Z0-9]+([._%+-]?[a-zA-Z0-9]+)*@gmail\.com$',
          ).hasMatch(emailController.text.trim())
          ? null
          : "Email must be @gmail.com";

      passwordError =
          RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{5,}$',
          ).hasMatch(passwordController.text)
          ? null
          : "Min 5 chars, A-Z, a-z, 0-9, @# required";

      phoneError =
          RegExp(
            r'^0(7[0-9]{8}|[1-9][0-9]{8})$',
          ).hasMatch(mobileController.text)
          ? null
          : "Invalid Sri Lankan phone number";

      nicError =
          RegExp(r'^[0-9]{12}$').hasMatch(nicController.text) ||
              RegExp(r'^[0-9]{9}[VXvx]$').hasMatch(nicController.text)
          ? null
          : "Invalid NIC";

      addressError =
          RegExp(r'^[a-zA-Z0-9\s,.-]+$').hasMatch(addressController.text)
          ? null
          : "Invalid address";
    });
  }

  // ---------------- DOB ----------------
  Future<void> pickDOB() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => dob = picked);
    }
  }

  // ---------------- FIRESTORE ----------------
  void registerUser() async {
    validateFields();

    if ([
      nameError,
      emailError,
      passwordError,
      phoneError,
      nicError,
      addressError,
    ].any((e) => e != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fix errors before register ❌")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('Registration').add({
      "Full Name": nameController.text,
      "Email Address": emailController.text,
      "Password": passwordController.text,
      "Mobile Number": mobileController.text,
      "National ID Number": nicController.text,
      "Address": addressController.text,
      "Gender": gender,
      "District": district,
      "Police Division": policeDivision,
      "Date of Birth": dob.toString(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Registered Successfully ✅")));

    Navigator.pop(context);
  }

  // ---------------- INPUT FIELD UI (MODERN LIGHT BLUE) ----------------
  Widget buildField({
    required TextEditingController controller,
    required String label,
    String? error,
    bool obscure = false,
    TextInputType? type,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: type,
          onChanged: (_) => validateFields(),
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.blue.shade700),
            hintText: "Enter $label",
            hintStyle: TextStyle(color: Colors.blue.shade200),
            prefixIcon: Icon(
              _getIconForField(label),
              color: Colors.blue.shade600,
              size: 22,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.blue.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: Colors.red.shade700),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }

  IconData _getIconForField(String label) {
    switch (label) {
      case "Full Name":
        return Icons.person_outline;
      case "Email Address":
        return Icons.email_outlined;
      case "Password":
        return Icons.lock_outline;
      case "Mobile Number":
        return Icons.phone_android_outlined;
      case "National ID Number":
        return Icons.badge_outlined;
      case "Address":
        return Icons.home_outlined;
      default:
        return Icons.edit_outlined;
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          "Police Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shadowColor: Colors.blue.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Header Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Join Sri Lanka Police Emergency System",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  
                  // Form Fields
                  buildField(
                    controller: nameController,
                    label: "Full Name",
                    error: nameError,
                  ),
                  buildField(
                    controller: emailController,
                    label: "Email Address",
                    error: emailError,
                  ),
                  buildField(
                    controller: passwordController,
                    label: "Password",
                    error: passwordError,
                    obscure: true,
                  ),
                  buildField(
                    controller: mobileController,
                    label: "Mobile Number",
                    error: phoneError,
                    type: TextInputType.phone,
                  ),
                  buildField(
                    controller: nicController,
                    label: "National ID Number",
                    error: nicError,
                  ),
                  buildField(
                    controller: addressController,
                    label: "Address",
                    error: addressError,
                  ),

                  // GENDER
                  DropdownButtonFormField(
                    value: gender,
                    decoration: InputDecoration(
                      labelText: "Gender",
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                      prefixIcon: Icon(Icons.people_outline, color: Colors.blue.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    items: ["Male", "Female"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => gender = v!),
                  ),
                  const SizedBox(height: 12),

                  // DISTRICT
                  DropdownButtonFormField(
                    value: district,
                    decoration: InputDecoration(
                      labelText: "District",
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                      prefixIcon: Icon(Icons.location_city_outlined, color: Colors.blue.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    items: policeData.keys
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        district = v!;
                        policeDivision = "";
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // POLICE DIVISION
                  DropdownButtonFormField(
                    value: policeDivision.isEmpty ? null : policeDivision,
                    decoration: InputDecoration(
                      labelText: "Police Division",
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                      prefixIcon: Icon(Icons.local_police_outlined, color: Colors.blue.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                    ),
                    items: getDivisions()
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => policeDivision = v!),
                  ),
                  const SizedBox(height: 12),

                  // DOB BUTTON
                  ElevatedButton.icon(
                    onPressed: pickDOB,
                    icon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
                    label: Text(
                      dob == null
                          ? "Select Date of Birth"
                          : dob.toString().split(" ")[0],
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue.shade200),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}