// NGO Profile Page with Supabase Integration (including address field)
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'change_password.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_nav_bar.dart';

class NGOProfilePage extends StatefulWidget {
  const NGOProfilePage({super.key});

  @override
  State<NGOProfilePage> createState() => _NGOProfilePageState();
}

class _NGOProfilePageState extends State<NGOProfilePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _ngoNameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _spocController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final response = await _supabase
          .from('ngo_profile')
          .select()
          .eq('authid', userId)
          .maybeSingle();

      setState(() {
        if (response != null) {
          _profileData = response;
          _ngoNameController.text = response['ngo_name'] ?? '';
          _regNoController.text = response['registration_no'] ?? '';
          _spocController.text = response['spoc_name'] ?? '';
          _emailController.text = response['contact_email'] ?? '';
          _phoneController.text = response['contact_phone_no'] ?? '';
          _addressController.text = response['address'] ?? '';
        }
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: ${e.toString()}')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated!')),
        );
        return;
      }

      final updateData = {
        'authid': userId,
        'ngo_name': _ngoNameController.text,
        'registration_no': _regNoController.text,
        'spoc_name': _spocController.text,
        'contact_email': _emailController.text,
        'contact_phone_no': _phoneController.text,
        'address': _addressController.text,
      };

      // Use upsert to create or update the profile
      final response = await _supabase
          .from('ngo_profile')
          .upsert(updateData)
          .select()
          .single();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      // Reload data after update
      await _loadProfileData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _ngoNameController.dispose();
    _regNoController.dispose();
    _spocController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose(); // Dispose address controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: _profileData?['logo_url'] != null
                      ? NetworkImage(_profileData!['logo_url'])
                      : null,
                  child: _profileData?['logo_url'] == null
                      ? const Icon(Icons.people, size: 40, color: Colors.blue)
                      : null,
                ),
                const SizedBox(height: 20),
                _buildTextField("NGO Name", _ngoNameController),
                _buildTextField("Registration Number", _regNoController),
                _buildTextField("SPOC Name", _spocController),
                _buildTextField("Email", _emailController),
                _buildTextField("Phone Number", _phoneController),
                _buildTextField("Address", _addressController, isRequired: false), // Added address field
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF002B5B),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Save Changes"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF002B5B),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        } : null,
      ),
    );
  }

}

