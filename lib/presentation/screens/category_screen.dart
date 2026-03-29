import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/app/di.dart';
import 'package:affirmup/data/models/affirmation_category.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final affirmationService = getIt<AffirmationService>();
    final premiumService = getIt<PremiumService>();

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
                      'Categories',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: AffirmationCategory.values.length,
                  itemBuilder: (context, index) {
                    final category = AffirmationCategory.values[index];
                    final count =
                        affirmationService.getCategoryCount(category);
                    final isAvailable =
                        premiumService.isCategoryAvailable(category);
                    final color = Color(category.colorValue);

                    return GestureDetector(
                      onTap: () {
                        if (isAvailable) {
                          context.push('/affirmation/${category.name}');
                        } else {
                          context.push('/paywall');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.categoryGradient(color),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: color.withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category.icon,
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.displayName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '$count affirmations',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (!isAvailable)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Icon(
                                  Icons.lock,
                                  color:
                                      Colors.white.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
