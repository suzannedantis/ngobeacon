import 'package:supabase_flutter/supabase_flutter.dart';
import '/Auth/auth_service.dart';


Future<void> _saveChanges() async {
  try {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Create or update the profile
    await _supabase.from('ngo_profile').upsert({
      'authid': userId,
      'ngo_name': _ngoNameController.text,
      'registration_no': _regNoController.text,
      'spoc_name': _spocController.text,
      'contact_email': _emailController.text,
      'contact_phone_no': _phoneController.text,
      'address': _addressController.text,
      'updated_at': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving profile: $e')),
    );
  }
}