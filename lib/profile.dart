import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart'; // Make sure to import your login page

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({super.key, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for form fields - Updated to match your database columns
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController policeDivisionController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;
  String documentId = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fetch all user data from Firestore
  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Registration')
          .where('Email Address', isEqualTo: widget.userEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        documentId = doc.id;

        // Get all field values with exact column names from your database
        fullNameController.text = doc['Full Name'] ?? '';
        emailController.text = doc['Email Address'] ?? '';
        mobileNumberController.text = doc['Mobile Number'] ?? '';
        addressController.text = doc['Address'] ?? '';
        nationalIDController.text = doc['National ID Number'] ?? '';
        dateOfBirthController.text = doc['Date of Birth'] ?? '';
        districtController.text = doc['District'] ?? '';
        genderController.text = doc['Gender'] ?? '';
        policeDivisionController.text = doc['Police Division'] ?? '';
        passwordController.text = doc['Password'] ?? '';
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User data not found")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading data: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Registration')
          .doc(documentId)
          .update({
            'Full Name': fullNameController.text,
            'Email Address': emailController.text,
            'Mobile Number': mobileNumberController.text,
            'Address': addressController.text,
            'National ID Number': nationalIDController.text,
            'Date of Birth': dateOfBirthController.text,
            'District': districtController.text,
            'Gender': genderController.text,
            'Police Division': policeDivisionController.text,
            'Password': passwordController.text,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error updating: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Show delete confirmation dialog
  Future<void> confirmDelete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => deleteAccount(),
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Delete user account
  Future<void> deleteAccount() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('Registration')
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted successfully")),
      );

      // Navigate back to login page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting: $e")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Logout method
  void logout() async {
    // Show confirmation dialog
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Navigate back to login page and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logged out successfully")));
    }
  }

  // Enable edit mode
  void enableEditMode() {
    setState(() {
      isEditing = true;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    nationalIDController.dispose();
    dateOfBirthController.dispose();
    districtController.dispose();
    genderController.dispose();
    policeDivisionController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.person, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Full Name
                          _buildInfoRow(
                            label: "Full Name",
                            icon: Icons.person,
                            controller: fullNameController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // Email Address
                          _buildInfoRow(
                            label: "Email Address",
                            icon: Icons.email,
                            controller: emailController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // Mobile Number
                          _buildInfoRow(
                            label: "Mobile Number",
                            icon: Icons.phone,
                            controller: mobileNumberController,
                            isEditing: isEditing,
                            keyboardType: TextInputType.phone,
                          ),
                          const Divider(),

                          // Address
                          _buildInfoRow(
                            label: "Address",
                            icon: Icons.location_on,
                            controller: addressController,
                            isEditing: isEditing,
                            maxLines: 2,
                          ),
                          const Divider(),

                          // National ID Number
                          _buildInfoRow(
                            label: "National ID Number",
                            icon: Icons.badge,
                            controller: nationalIDController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // Date of Birth
                          _buildInfoRow(
                            label: "Date of Birth",
                            icon: Icons.cake,
                            controller: dateOfBirthController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // District
                          _buildInfoRow(
                            label: "District",
                            icon: Icons.location_city,
                            controller: districtController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // Gender
                          _buildInfoRow(
                            label: "Gender",
                            icon: Icons.people,
                            controller: genderController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // Police Division
                          _buildInfoRow(
                            label: "Police Division",
                            icon: Icons.local_police,
                            controller: policeDivisionController,
                            isEditing: isEditing,
                          ),
                          const Divider(),

                          // Password
                          _buildInfoRow(
                            label: "Password",
                            icon: Icons.lock,
                            controller: passwordController,
                            isEditing: isEditing,
                            isPassword: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Button Section - New Structure
                  if (isEditing)
                    // Show Save Changes button when in edit mode
                    ElevatedButton(
                      onPressed: updateUserData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                  if (!isEditing)
                    Column(
                      children: [
                        // 1. LOGOUT BUTTON (First)
                        OutlinedButton.icon(
                          onPressed: logout,
                          icon: const Icon(Icons.logout, color: Colors.orange),
                          label: const Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.orange,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 2. EDIT PROFILE BUTTON (Second)
                        ElevatedButton.icon(
                          onPressed: enableEditMode,
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            "Edit Profile",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 3. DELETE ACCOUNT BUTTON (Third/Last)
                        ElevatedButton.icon(
                          onPressed: confirmDelete,
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text(
                            "Delete Account",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 246, 39, 24),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool isEditing,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isPassword = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              if (isEditing)
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter $label",
                    suffixIcon: isPassword
                        ? IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // You can implement password visibility toggle here
                            },
                          )
                        : null,
                  ),
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  obscureText: isPassword,
                  enabled: isEditing,
                )
              else
                Text(
                  controller.text.isEmpty ? "Not provided" : controller.text,
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
