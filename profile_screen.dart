import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Employee Profile', style: TextStyle(color: Colors.white)), backgroundColor: AppColors.primaryBlue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 40, backgroundColor: AppColors.lightBlue, child: Icon(Icons.person, size: 40, color: AppColors.primaryBlue)),
            const SizedBox(height: 20),
            Text('Email: ${user?.email ?? "N/A"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Role: Employee', style: TextStyle(fontSize: 16, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}