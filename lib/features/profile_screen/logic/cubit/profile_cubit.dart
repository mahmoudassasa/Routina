import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:routina/features/home_screen/data/habit_service.dart';
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

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (isClosed) return;
      if (!userDoc.exists) throw Exception('User document not found');
      final userData = userDoc.data()!;

      final habits = await HabitService().fetchHabitsForCurrentUser();
      if (isClosed) return;

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
            totalHabitsCount: total,
            currentStreakCount: currentActiveStreak,
            completionRate: "${avgCompletion.toInt()}%",
            bestStreakCount: bestStreak,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }

  final _picker = ImagePicker();

  Future<void> updateProfileImage({required ImageSource source}) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked == null) return;

      emit(state.copyWith(loading: true));

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;
      final file = File(picked.path);
      final fileName =
          '$uid-profile-${DateTime.now().millisecondsSinceEpoch}.jpg';

      await _deleteSupabaseImage(uid);

      await _supabase.storage
          .from('users')
          .upload(
            fileName,
            file,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl = _supabase.storage.from('users').getPublicUrl(fileName);

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'imageUrl': imageUrl,
      });

      if (!isClosed) {
        emit(state.copyWith(loading: false, imageUrl: imageUrl));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }

  Future<void> deleteProfileImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      emit(state.copyWith(loading: true));

      await _deleteSupabaseImage(user.uid);

      const defaultUrl =
          'https://gvqgliulacfmhscswyid.supabase.co/storage/v1/object/public/users/unknown.png';

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'imageUrl': defaultUrl},
      );

      if (!isClosed) {
        emit(state.copyWith(loading: false, imageUrl: defaultUrl));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }

  Future<void> _deleteSupabaseImage(String uid) async {
    try {
      final files = await _supabase.storage.from('users').list();
      final userFiles = files
          .where((f) => f.name.startsWith('$uid-profile-'))
          .map((f) => f.name)
          .toList();
      if (userFiles.isNotEmpty) {
        await _supabase.storage.from('users').remove(userFiles);
      }
    } catch (_) {}
  }

  Future<void> updateName(String newName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      emit(state.copyWith(loading: true));

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': newName},
      );

      if (!isClosed) {
        emit(state.copyWith(loading: false, name: newName));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }
}