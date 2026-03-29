import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/presentation/cubits/history_cubit.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App bar
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        Text(
                          'History',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats cards
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  label: 'Current Streak',
                                  value: '${state.stats.currentStreak}',
                                  icon: Icons.local_fire_department,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  label: 'Longest Streak',
                                  value: '${state.stats.longestStreak}',
                                  icon: Icons.emoji_events,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _StatCard(
                            label: 'Total Days',
                            value: '${state.stats.totalDays}',
                            icon: Icons.calendar_today,
                            color: AppColors.accent,
                            fullWidth: true,
                          ),
                          const SizedBox(height: 24),

                          // Calendar heatmap
                          Text(
                            'Activity',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          _CalendarHeatmap(
                            completionMap: state.completionMap,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool fullWidth;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarHeatmap extends StatelessWidget {
  final Map<String, bool> completionMap;

  const _CalendarHeatmap({required this.completionMap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weeks = 12;
    final startDate = now.subtract(Duration(days: weeks * 7));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Column(
        children: [
          // Day labels
          Row(
            children: ['Mon', '', 'Wed', '', 'Fri', '', '']
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          // Heatmap grid
          SizedBox(
            height: 100,
            child: Row(
              children: List.generate(weeks, (weekIndex) {
                return Expanded(
                  child: Column(
                    children: List.generate(7, (dayIndex) {
                      final date = startDate.add(
                        Duration(days: weekIndex * 7 + dayIndex),
                      );
                      final key =
                          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                      final completed = completionMap[key] ?? false;
                      final isToday = date.year == now.year &&
                          date.month == now.month &&
                          date.day == now.day;

                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: completed
                                ? AppColors.success
                                : isToday
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : AppColors.cardBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
