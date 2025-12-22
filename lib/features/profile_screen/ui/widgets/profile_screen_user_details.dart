import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class ProfileScreenUserDetails extends StatelessWidget {
  const ProfileScreenUserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.loading) {
          return const CircularProgressIndicator();
        }

        if (state.errorMessage != null) {
          return Text(
            "Error: ${state.errorMessage}",
            style: const TextStyle(color: Colors.red),
          );
        }

        return Column(
          children: [
            Text(
              state.name ?? "Unknown User",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.email ?? "No Email",
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}
