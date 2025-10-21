import 'package:flutter/material.dart';

class ProfileScreenUserPicture extends StatefulWidget {
  const ProfileScreenUserPicture({super.key});

  @override
  State<ProfileScreenUserPicture> createState() =>
      _ProfileScreenUserPictureState();
}

class _ProfileScreenUserPictureState extends State<ProfileScreenUserPicture> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(child: Text('👤', style: TextStyle(fontSize: 48))),
      ),
    );
  }
}
