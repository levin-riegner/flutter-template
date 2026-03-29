import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/app/di.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final premiumService = getIt<PremiumService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.2),
              AppColors.backgroundDark,
              AppColors.backgroundLight,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => context.pop(),
                  ),
                ),
              ),
              // Header
              const Text('✨', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text(
                'Unlock Premium',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'One-time purchase. No subscription.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // Comparison
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Free
                      Expanded(
                        child: _PlanCard(
                          title: 'Free',
                          features: PremiumService.freeFeatures,
                          isHighlighted: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Premium
                      Expanded(
                        child: _PlanCard(
                          title: 'Premium',
                          price: '€${PremiumService.premiumPrice.toInt()}',
                          features: PremiumService.premiumFeatures,
                          isHighlighted: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Purchase button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await premiumService.purchasePremium();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Premium unlocked! 🎉'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            context.pop();
                          }
                        },
                        child: Text(
                          'Get Premium — €${PremiumService.premiumPrice.toInt()}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        final restored =
                            await premiumService.restorePurchase();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                restored
                                    ? 'Purchase restored!'
                                    : 'No purchase to restore',
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Restore Purchase',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
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

class _PlanCard extends StatelessWidget {
  final String title;
  final String? price;
  final List<String> features;
  final bool isHighlighted;

  const _PlanCard({
    required this.title,
    this.price,
    required this.features,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? AppColors.primary : AppColors.cardBorder,
          width: isHighlighted ? 2 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isHighlighted ? AppColors.primary : Colors.white,
            ),
          ),
          if (price != null) ...[
            const SizedBox(height: 4),
            Text(
              price!,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Text(
              'one-time',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isHighlighted ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: isHighlighted
                          ? AppColors.success
                          : AppColors.textHint,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
