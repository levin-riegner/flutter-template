import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:affirmup/app/di.dart';
import 'package:affirmup/data/services/services.dart';
import 'package:affirmup/presentation/theme/app_colors.dart';

class MirrorModeScreen extends StatefulWidget {
  const MirrorModeScreen({super.key});

  @override
  State<MirrorModeScreen> createState() => _MirrorModeScreenState();
}

class _MirrorModeScreenState extends State<MirrorModeScreen> {
  bool _isRecording = false;
  late final AffirmationService _affirmationService;
  late final String _affirmationText;

  @override
  void initState() {
    super.initState();
    _affirmationService = getIt<AffirmationService>();
    _affirmationText = _affirmationService.getDailyAffirmation().text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              // Mock camera (black background)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Camera Preview',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '(Mock - Front camera would appear here)',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.15),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Affirmation text overlay
              Positioned(
                left: 24,
                right: 24,
                bottom: 160,
                child: Text(
                  _affirmationText,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Top bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                      const Spacer(),
                      Text(
                        'Mirror Mode',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              // Record button
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isRecording = !_isRecording;
                      });
                    },
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _isRecording ? 28 : 56,
                          height: _isRecording ? 28 : 56,
                          decoration: BoxDecoration(
                            color: _isRecording ? Colors.red : AppColors.error,
                            borderRadius: BorderRadius.circular(
                              _isRecording ? 6 : 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Recording indicator
              if (_isRecording)
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Recording',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
