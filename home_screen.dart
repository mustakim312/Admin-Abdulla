import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/location_service.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSharingLocation = false;

  void _toggleLocationSharing(bool value) async {
    setState(() => _isSharingLocation = value);
    final user = SupabaseService.client.auth.currentUser;
    if (value && user != null) {
      await LocationService.uploadCurrentLocation(user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location sharing active with consent.')),
      );
    }
  }

  void _logout() async {
    await SupabaseService.client.auth.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text('Consent Location Sharing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Switch(
                      value: _isSharingLocation,
                      activeColor: AppColors.primaryBlue,
                      onChanged: _toggleLocationSharing,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, padding: const EdgeInsets.all(15)),
              onPressed: () {
                // Implement Check-In logic
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checked In Successfully')));
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('Attendance Check-In', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}