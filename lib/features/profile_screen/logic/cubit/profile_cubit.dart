import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  final _supabase = Supabase.instance.client;

  Future<void> loadUserData() async {
    if (!isClosed) {
      emit(state.copyWith(loading: true, errorMessage: null));
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // 1. Fetch User Data from Firebase Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
if (isClosed) return;
      if (!userDoc.exists) throw Exception('User document not found');
      final userData = userDoc.data()!;

      // 2. Fetch Habits Data from Supabase
      final List<dynamic> habits = await _supabase
          .from('habits')
          .select()
          .eq('user_id', user.uid);
if (isClosed) return;
      // --- Calculations ---
      int total = habits.length;
      int bestStreak = 0;
      int currentActiveStreak = 0;
      double totalProgress = 0;

      for (var habit in habits) {
    
        int streak = habit['streak'] as int? ?? 0;
        totalProgress += (habit['progress'] as num? ?? 0).toDouble();
        if (streak > bestStreak) bestStreak = streak;

        if (streak > currentActiveStreak) currentActiveStreak = streak;
      }

      double avgCompletion = total == 0 ? 0 : (totalProgress / total) * 100;
      if (!isClosed) {
        emit(
          state.copyWith(
            loading: false,
            name: userData['name'] as String?,
            email: userData['email'] as String?,
            imageUrl: userData['imageUrl'] as String?,
            totalHabits: "$total active",
            currentStreak:
                "$currentActiveStreak days", 
            completionRate: "${avgCompletion.toInt()}%",
            bestStreak: "$bestStreak days",
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }
}
