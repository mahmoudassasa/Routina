import 'package:flutter/material.dart';
import 'package:routina/features/habit_tracker_screen/ui/widgets/feature_preview_card.dart';

class HabitTrackerScreenComingSoonContent extends StatefulWidget {
  const HabitTrackerScreenComingSoonContent({super.key});

  @override
  State<HabitTrackerScreenComingSoonContent> createState() => _HabitTrackerScreenComingSoonContentState();
}

class _HabitTrackerScreenComingSoonContentState extends State<HabitTrackerScreenComingSoonContent> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🚧', style: TextStyle(fontSize: 48)),
                ),
              ),
            
              const SizedBox(height: 24),
            
              const Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            
              const SizedBox(height: 16),
            
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Advanced habit tracking features including charts, statistics, and detailed analytics will be available here.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
              const SizedBox(height: 32),
            
              // Feature Preview Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    FeaturePreviewCard(
                      icon: '📈',
                      title: 'Progress Charts',
                      description: 'Visual progress tracking over time',
                    ),
            
                    const SizedBox(height: 12),
            
                    FeaturePreviewCard(
                      icon: '🎯',
                      title: 'Goal Setting',
                      description: 'Set and track specific habit goals',
                    ),
            
                    const SizedBox(height: 12),
            
                    FeaturePreviewCard(
                      icon: '🏆',
                      title: 'Achievements',
                      description: 'Unlock badges and milestones',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
