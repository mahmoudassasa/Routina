import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/routing/routes.dart';

class ProfileScreenLogoutButton extends StatefulWidget {
  const ProfileScreenLogoutButton({super.key});

  @override
  State<ProfileScreenLogoutButton> createState() =>
      _ProfileScreenLogoutButtonState();
}

class _ProfileScreenLogoutButtonState extends State<ProfileScreenLogoutButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 24.h),
      child: SizedBox(
          width: double.infinity,
        child: OutlinedButton(
          onPressed: () => context.pushReplacementNamed(Routes.loginScreen),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFEF4444)),
            foregroundColor: const Color(0xFFEF4444),
            padding:  EdgeInsets.symmetric(vertical: 14.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child:  Text(
            'Logout',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
