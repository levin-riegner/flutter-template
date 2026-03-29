import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/presentation/cubits/home_cubit.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';
import 'package:affirmup/presentation/widgets/affirmation_card.dart';
import 'package:affirmup/presentation/widgets/category_chip.dart';
import 'package:affirmup/presentation/widgets/streak_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // App bar
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      'AffirmUp',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.favorite_outline),
                        onPressed: () => context.push('/favorites'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () => context.push('/settings'),
                      ),
                    ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Streak + Status
                        Row(
                          children: [
                            StreakBadge(streak: state.currentStreak),
                            const Spacer(),
                            _StatusIndicator(
                              icon: Icons.wb_sunny_outlined,
                              label: 'Morning',
                              completed: state.morningCompleted,
                              onTap: () =>
                                  context.read<HomeCubit>().completeMorning(),
                            ),
                            const SizedBox(width: 12),
                            _StatusIndicator(
                              icon: Icons.nightlight_outlined,
                              label: 'Evening',
                              completed: state.eveningCompleted,
                              onTap: () =>
                                  context.read<HomeCubit>().completeEvening(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Today's Affirmation
                        if (state.dailyAffirmation != null) ...[
                          Text(
                            "Today's Affirmation",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => context.push(
                              '/affirmation/${state.dailyAffirmation!.category.name}',
                            ),
                            child: AffirmationCard(
                              affirmation: state.dailyAffirmation!,
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),

                        // Categories
                        Text(
                          'Categories',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                      ]),
                    ),
                  ),
                  // Category horizontal scroll
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: AffirmationCategory.values.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final category = AffirmationCategory.values[index];
                          final isLocked =
                              !state.categories.contains(category);
                          return CategoryChip(
                            category: category,
                            isLocked: isLocked,
                            onTap: () {
                              if (isLocked) {
                                context.push('/paywall');
                              } else {
                                context.push('/affirmation/${category.name}');
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 16),
                        // Quick Actions
                        Text(
                          'Explore',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        _QuickAction(
                          icon: Icons.grid_view_rounded,
                          title: 'All Categories',
                          subtitle: '7 categories, 210+ affirmations',
                          onTap: () => context.push('/categories'),
                        ),
                        const SizedBox(height: 8),
                        _QuickAction(
                          icon: Icons.auto_awesome,
                          title: 'Custom Affirmations',
                          subtitle: 'Build your own "I Am..." affirmations',
                          onTap: () => context.push('/custom'),
                          premium: !state.isPremium,
                        ),
                        const SizedBox(height: 8),
                        _QuickAction(
                          icon: Icons.camera_alt_outlined,
                          title: 'Mirror Mode',
                          subtitle: 'Speak your truth to your reflection',
                          onTap: () => context.push('/mirror'),
                          premium: !state.isPremium,
                        ),
                        const SizedBox(height: 8),
                        _QuickAction(
                          icon: Icons.calendar_month_outlined,
                          title: 'History',
                          subtitle: 'Track your journey',
                          onTap: () => context.push('/history'),
                        ),
                        const SizedBox(height: 24),
                        // Ad placeholder
                        if (!state.isPremium)
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Center(
                              child: Text(
                                'AdMob Banner Placeholder',
                                style: TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                      ]),
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

class _StatusIndicator extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool completed;
  final VoidCallback onTap;

  const _StatusIndicator({
    required this.icon,
    required this.label,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: completed ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: completed
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: completed ? AppColors.success : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              completed ? Icons.check_circle : icon,
              size: 18,
              color: completed ? AppColors.success : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: completed ? AppColors.success : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool premium;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.premium = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              )),
                      if (premium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'PRO',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
