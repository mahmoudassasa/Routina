import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/services/notification_service.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/features/home_screen/logic/cubit/home_cubit.dart';
import 'package:routina/features/home_screen/logic/cubit/home_state.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<int, bool> scheduledHabits = {};

  // Generating a unique integer ID from the habit ID
  int fastHash(String uuid) => uuid.hashCode.abs();

  @override
  void initState() {
    super.initState();
    _loadAllScheduledNotifications();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAllScheduledNotifications();
  }

  Future<void> _loadAllScheduledNotifications() async {
    final List<PendingNotificationRequest> pendingRequests =
        await notificationsPlugin.pendingNotificationRequests();

    final Map<int, bool> tempMap = {};
    for (var r in pendingRequests) {
      tempMap[r.id] = true;
    }

    if (mounted) {
      setState(() {
        scheduledHabits = tempMap;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.habitReminders,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.habits.isEmpty) {
            return Center(
              child: Text(
                context.l10n.noHabitsFound,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            itemCount: state.habits.length,
            itemBuilder: (context, index) {
              final habit = state.habits[index];
              final String idString = habit['id'].toString();
              final int habitId = fastHash(idString);
              final bool isON = scheduledHabits[habitId] ?? false;
              final Color habitColor = Color(
                habit['color'] ?? AppColors.primary.toARGB32(),
              );

              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: habitColor.withValues(alpha: 0.1),
                    child: Icon(
                      isON
                          ? Icons.notifications_active
                          : Icons.notifications_none,
                      color: habitColor,
                    ),
                  ),
                  title: Text(
                    habit['title'] ?? context.l10n.unnamedHabit,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    isON
                        ? context.l10n.reminderActive
                        : context.l10n.reminderOff,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  trailing: Switch.adaptive(
                    value: isON,
                    activeThumbColor: habitColor,
                    onChanged: (value) => _handleToggle(value, habit, habitId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleToggle(bool value, dynamic habit, int habitId) async {
    if (value) {
      final enableMsg = context.l10n.enableNotificationsMsg;
      final remindMeMsg = context.l10n.remindMeOf(habit['title'] ?? '');
      final notifTitle = context.l10n.notificationTitle(habit['title'] ?? '');
      final notifBody = context.l10n.notificationBody;
      final buildReminderMsg = context.l10n.reminderSetFor;

      bool isAllowed = await requestNotificationPermissions();
      if (!mounted) return;

      if (!isAllowed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(enableMsg), backgroundColor: Colors.red),
        );
        return;
      }

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: remindMeMsg,
      );

      if (picked != null) {
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        final reminderMsg = buildReminderMsg('$hour:$minute');

        try {
          await scheduleDailyNotification(
            id: habitId,
            title: notifTitle,
            body: notifBody,
            hour: picked.hour,
            minute: picked.minute,
          );
          if (mounted) setState(() => scheduledHabits[habitId] = true);
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(reminderMsg)));
          }
        } catch (e) {
          // scheduling failed silently
        }
      }
    } else {
      await cancelNotification(habitId);
      if (mounted) setState(() => scheduledHabits[habitId] = false);
    }
  }
}
