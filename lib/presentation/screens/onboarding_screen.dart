import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/presentation/cubits/onboarding_cubit.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _pages = [
    _OnboardingPageData(
      emoji: '✨',
      title: 'Welcome to AffirmUp',
      description:
          'Transform your life with the power of daily affirmations. Inspired by Louise Hay and Joe Dispenza.',
    ),
    _OnboardingPageData(
      emoji: '🪞',
      title: 'Mirror Work',
      description:
          'Look into your own eyes and speak words of love. Mirror work is one of the most powerful tools for self-transformation.',
    ),
    _OnboardingPageData(
      emoji: '🔥',
      title: 'Build Your Streak',
      description:
          'Morning and evening rituals to keep you aligned. Track your progress and watch your confidence grow.',
    ),
    _OnboardingPageData(
      emoji: '💫',
      title: 'Ready to Begin?',
      description:
          'Your journey to self-love starts now. Take a deep breath and affirm: I am worthy.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.completed) {
          context.go('/home');
        }
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
            child: SafeArea(
              child: Column(
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: () => cubit.completeOnboarding(),
                        child: Text(
                          'Skip',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ),
                  // Page content
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _OnboardingPage(
                        key: ValueKey(state.currentPage),
                        data: _pages[state.currentPage],
                      ),
                    ),
                  ),
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: state.currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: state.currentPage == index
                              ? AppColors.primary
                              : AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // Navigation button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (state.currentPage < 3) {
                            cubit.nextPage();
                          } else {
                            cubit.completeOnboarding();
                          }
                        },
                        child: Text(
                          state.currentPage < 3 ? 'Next' : 'Get Started',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingPageData {
  final String emoji;
  final String title;
  final String description;

  const _OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.description,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.emoji, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 32),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
