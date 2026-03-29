import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/presentation/cubits/affirmation_cubit.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class AffirmationScreen extends StatelessWidget {
  final AffirmationCategory category;

  const AffirmationScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AffirmationCubit, AffirmationState>(
      builder: (context, state) {
        final cubit = context.read<AffirmationCubit>();
        final affirmation = cubit.currentAffirmation;
        final color = Color(category.colorValue);

        return Scaffold(
          body: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null) {
                if (details.primaryVelocity! < 0) {
                  cubit.next();
                } else if (details.primaryVelocity! > 0) {
                  cubit.previous();
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.4),
                    AppColors.backgroundDark,
                    AppColors.backgroundLight,
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => context.pop(),
                          ),
                          Expanded(
                            child: Text(
                              category.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: color),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 48), // balance
                        ],
                      ),
                    ),
                    // Counter
                    if (state.affirmations.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${state.currentIndex + 1} / ${state.affirmations.length}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    // Main affirmation
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: affirmation != null
                              ? AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    affirmation.text,
                                    key: ValueKey(affirmation.id),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          height: 1.4,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    // Swipe hint
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '← Swipe to navigate →',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // Actions
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Favorite
                          _ActionButton(
                            icon: state.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: state.isFavorite
                                ? AppColors.secondary
                                : AppColors.textSecondary,
                            onTap: () => cubit.toggleFavorite(),
                          ),
                          const SizedBox(width: 24),
                          // Share
                          _ActionButton(
                            icon: Icons.share_outlined,
                            color: AppColors.textSecondary,
                            onTap: () {
                              if (affirmation != null) {
                                SharePlus.instance.share(
                                  ShareParams(
                                    text:
                                        '✨ ${affirmation.text}\n\n— AffirmUp',
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
