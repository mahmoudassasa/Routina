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
  final _picker = ImagePicker();

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

      final name = userData['name'] as String?;
      final phone = userData['phone'] as String?;
      final dob = userData['dob'] as String?;
      final email = userData['email'] as String?;
      
      String? imageUrl = userData['imageUrl'] as String?;
      if (imageUrl != null && imageUrl.contains('unknown.png')) {
        imageUrl = null;
      }

      final phoneVerified = userData['phoneVerified'] as bool? ?? false;

      final profileCompleted = (name?.isNotEmpty ?? false) &&
          (phone?.isNotEmpty ?? false) &&
          (dob?.isNotEmpty ?? false) &&
          phoneVerified;

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
            name: name,
            email: email,
            imageUrl: imageUrl,
            phone: phone,
            dob: dob,
            phoneVerified: phoneVerified,
            totalHabitsCount: total,
            currentStreakCount: currentActiveStreak,
            completionRate: "${avgCompletion.toInt()}%",
            bestStreakCount: bestStreak,
            profileCompleted: profileCompleted,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }

  Future<void> updateProfileData({
    String? name,
    String? phone,
    String? dob,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      emit(state.copyWith(loading: true));

      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (dob != null) updateData['dob'] = dob;

      final phoneChanged = phone != null && phone != state.phone;
      if (phone != null) updateData['phone'] = phone;
      if (phoneChanged) updateData['phoneVerified'] = false;

      if (updateData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(updateData);
      }

      await loadUserData();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(loading: false, errorMessage: e.toString()));
      }
    }
  }

  Future<void> confirmPhoneVerified(String verifiedPhone) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'phone': verifiedPhone,
        'phoneVerified': true,
      });

      await loadUserData();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

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

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'imageUrl': null,
      });

      if (!isClosed) {
        emit(state.copyWith(loading: false, imageUrl: null));
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
    await updateProfileData(name: newName);
  }

  Future<void> updatePhone(String newPhone) async {
    await updateProfileData(phone: newPhone);
  }

  Future<void> updateDob(String newDob) async {
    await updateProfileData(dob: newDob);
  }
}