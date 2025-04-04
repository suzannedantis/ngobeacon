import 'package:flutter/material.dart';
import '/Auth/auth_service.dart';


class LogoutButton extends StatelessWidget {
  final AuthService authService;
  final String buttonText;
  final IconData? icon;
  final VoidCallback onLogoutSuccess; // Changed to required callback

  const LogoutButton({
    super.key,
    required this.authService,
    required this.onLogoutSuccess, // Now required
    this.buttonText = 'Logout',
    this.icon = Icons.logout,
  });

  Future<void> _logout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await authService.signOut();
      Navigator.of(context).pop(); // Close loading
      onLogoutSuccess(); // Trigger navigation
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(buttonText),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Logout'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          await _logout(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
      ),
    );
  }
}