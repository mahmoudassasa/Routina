import 'package:flutter/material.dart';

class ProfileScreenUserDetails extends StatefulWidget {
  const ProfileScreenUserDetails({super.key});

  @override
  State<ProfileScreenUserDetails> createState() =>
      _ProfileScreenUserDetailsState();
}

class _ProfileScreenUserDetailsState extends State<ProfileScreenUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          const Text(
            'محمد أحمد',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
      
          const SizedBox(height: 8),
      
          Text(
            'mohamed.ahmed@routina.app',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
      
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
