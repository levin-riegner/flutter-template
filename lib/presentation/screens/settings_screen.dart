import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/presentation/cubits/settings_cubit.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

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
                          'Settings',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        // Premium
                        _SettingsSection(
                          title: 'Premium',
                          children: [
                            _SettingsTile(
                              icon: Icons.star,
                              iconColor: AppColors.primary,
                              title: state.isPremium
                                  ? 'Premium Active'
                                  : 'Upgrade to Premium',
                              subtitle: state.isPremium
                                  ? 'All features unlocked'
                                  : '€6 one-time purchase',
                              onTap: state.isPremium
                                  ? null
                                  : () => context.push('/paywall'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Notifications
                        _SettingsSection(
                          title: 'Notifications',
                          children: [
                            _SettingsSwitch(
                              icon: Icons.notifications_outlined,
                              title: 'Daily Reminders',
                              subtitle: 'Morning 8:00 • Evening 21:00',
                              value: state.notificationsEnabled,
                              onChanged: (v) => cubit.toggleNotifications(v),
                            ),
                            _SettingsSwitch(
                              icon: Icons.do_not_disturb_on_outlined,
                              title: 'Quiet Hours',
                              subtitle:
                                  '${state.quietHoursStart}:00 - ${state.quietHoursEnd}:00',
                              value: state.quietHoursEnabled,
                              onChanged: (v) => cubit.toggleQuietHours(v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Account
                        _SettingsSection(
                          title: 'Account',
                          children: [
                            _SettingsTile(
                              icon: Icons.person_outline,
                              title: 'Login',
                              subtitle: 'Sign in to sync your data',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login coming soon!'),
                                  ),
                                );
                              },
                            ),
                            _SettingsTile(
                              icon: Icons.restore,
                              title: 'Restore Purchase',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No purchases to restore'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // About
                        _SettingsSection(
                          title: 'About',
                          children: [
                            _SettingsTile(
                              icon: Icons.info_outline,
                              title: 'AffirmUp',
                              subtitle: 'Version 1.0.0',
                            ),
                            _SettingsTile(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              onTap: () {},
                            ),
                            _SettingsTile(
                              icon: Icons.description_outlined,
                              title: 'Terms of Service',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 0.5),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.textSecondary),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: AppColors.textSecondary))
          : null,
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: AppColors.textSecondary)
          : null,
      onTap: onTap,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: AppColors.textSecondary))
          : null,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}
