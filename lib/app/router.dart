import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/app/di.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/cubits/affirmation_cubit.dart';
import 'package:affirmup/presentation/cubits/custom_affirmation_cubit.dart';
import 'package:affirmup/presentation/cubits/favorites_cubit.dart';
import 'package:affirmup/presentation/cubits/history_cubit.dart';
import 'package:affirmup/presentation/cubits/home_cubit.dart';
import 'package:affirmup/presentation/cubits/onboarding_cubit.dart';
import 'package:affirmup/presentation/cubits/settings_cubit.dart';
import 'package:affirmup/presentation/screens/affirmation_screen.dart';
import 'package:affirmup/presentation/screens/category_screen.dart';
import 'package:affirmup/presentation/screens/custom_affirmation_screen.dart';
import 'package:affirmup/presentation/screens/favorites_screen.dart';
import 'package:affirmup/presentation/screens/history_screen.dart';
import 'package:affirmup/presentation/screens/home_screen.dart';
import 'package:affirmup/presentation/screens/mirror_mode_screen.dart';
import 'package:affirmup/presentation/screens/onboarding_screen.dart';
import 'package:affirmup/presentation/screens/paywall_screen.dart';
import 'package:affirmup/presentation/screens/settings_screen.dart';
import 'package:affirmup/presentation/screens/splash_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => BlocProvider(
        create: (_) => OnboardingCubit(storage: getIt<StorageService>()),
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => BlocProvider(
        create: (_) => HomeCubit(
          affirmationService: getIt<AffirmationService>(),
          dailyRoutineService: getIt<DailyRoutineService>(),
          premiumService: getIt<PremiumService>(),
        )..load(),
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoryScreen(),
    ),
    GoRoute(
      path: '/affirmation/:category',
      builder: (context, state) {
        final categoryName = state.pathParameters['category']!;
        final category = AffirmationCategory.values.firstWhere(
          (c) => c.name == categoryName,
          orElse: () => AffirmationCategory.selfLove,
        );
        return BlocProvider(
          create: (_) => AffirmationCubit(
            affirmationService: getIt<AffirmationService>(),
            premiumService: getIt<PremiumService>(),
          )..loadCategory(category),
          child: AffirmationScreen(category: category),
        );
      },
    ),
    GoRoute(
      path: '/mirror',
      builder: (context, state) => const MirrorModeScreen(),
    ),
    GoRoute(
      path: '/custom',
      builder: (context, state) => BlocProvider(
        create: (_) => CustomAffirmationCubit(
          customService: getIt<CustomAffirmationService>(),
        )..load(),
        child: const CustomAffirmationScreen(),
      ),
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => BlocProvider(
        create: (_) => FavoritesCubit(
          affirmationService: getIt<AffirmationService>(),
        )..load(),
        child: const FavoritesScreen(),
      ),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => BlocProvider(
        create: (_) => HistoryCubit(
          dailyRoutineService: getIt<DailyRoutineService>(),
        )..load(),
        child: const HistoryScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => BlocProvider(
        create: (_) => SettingsCubit(
          premiumService: getIt<PremiumService>(),
          notificationService: getIt<NotificationService>(),
        )..load(),
        child: const SettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
  ],
);
