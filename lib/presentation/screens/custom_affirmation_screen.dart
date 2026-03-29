import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/presentation/cubits/custom_affirmation_cubit.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class CustomAffirmationScreen extends StatefulWidget {
  const CustomAffirmationScreen({super.key});

  @override
  State<CustomAffirmationScreen> createState() =>
      _CustomAffirmationScreenState();
}

class _CustomAffirmationScreenState extends State<CustomAffirmationScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomAffirmationCubit, CustomAffirmationState>(
      listener: (context, state) {
        if (state.saved) {
          _controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Affirmation saved! ✨'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<CustomAffirmationCubit>();

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
                          'I Am... Builder',
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
                          // Input
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Your Affirmation',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _controller,
                                  onChanged: (text) => cubit.updateText(text),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'I am...',
                                    hintStyle: TextStyle(
                                      color: AppColors.textHint,
                                    ),
                                    border: InputBorder.none,
                                    prefixText: 'I am ',
                                    prefixStyle: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: state.currentText.trim().isEmpty
                                        ? null
                                        : () => cubit.save(),
                                    child: const Text('Save Affirmation'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // AI Suggestions
                          Text(
                            'AI Suggestions ✨',
                            style:
                                Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 12),
                          ...state.aiSuggestions.map((suggestion) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GestureDetector(
                                onTap: () {
                                  _controller.text = suggestion;
                                  cubit.updateText(suggestion);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                    ),
                                  ),
                                  child: Text(
                                    suggestion,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 24),

                          // Saved custom affirmations
                          if (state.customAffirmations.isNotEmpty) ...[
                            Text(
                              'My Affirmations',
                              style:
                                  Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 12),
                            ...state.customAffirmations.map((affirmation) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          affirmation.text,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            cubit.delete(affirmation.id),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
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
