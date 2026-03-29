import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/app/di.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final storage = getIt<StorageService>();
    final onboardingDone =
        storage.getBool(StorageService.onboardingCompleted) ?? false;

    if (onboardingDone) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.3),
              AppColors.backgroundDark,
              AppColors.backgroundLight,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'I Am',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 56,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 1200.ms,
                  ),
              const SizedBox(height: 8),
              Text(
                'AffirmUp',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 4,
                    ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
