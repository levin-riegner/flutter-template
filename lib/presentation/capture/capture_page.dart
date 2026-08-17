import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swiss_ai/data/capture/repository/capture_repository.dart';
import 'package:swiss_ai/presentation/capture/bloc/capture_bloc.dart';
import 'package:swiss_ai/presentation/capture/bloc/capture_event.dart';
import 'package:swiss_ai/presentation/capture/bloc/capture_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';

/// Capture a photo with the camera and read its text on-device (OCR via the
/// local vision model).
class CapturePage extends StatefulWidget {
  const CapturePage({super.key, this.bloc});

  final CaptureBloc? bloc;

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPhoto(Bloc<CaptureEvent, CaptureState> bloc) async {
    try {
      final photo =
          await _picker.pickImage(source: ImageSource.camera);
      if (!mounted) return;
      if (photo == null) return; // user cancelled
      bloc.add(CaptureEvent.pick(path: photo.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera unavailable: $e')),
      );
    }
  }

  Future<void> _pickFromGallery(
      Bloc<CaptureEvent, CaptureState> bloc) async {
    final photo =
        await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (photo == null) return;
    bloc.add(CaptureEvent.pick(path: photo.path));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ?? CaptureBloc(getIt<CaptureRepository>());
    return BlocProvider<CaptureBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<CaptureBloc>();
          return Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Camera to text',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(
                  'Snap a photo of text — the on-device model reads it '
                  '(works offline).',
                  style: TextStyle(color: Colors.grey),
                ),
                Dimens.boxSmall,
                Row(
                  children: [
                    FilledButton.icon(
                      key: const ValueKey('capture_photo'),
                      onPressed: () => _pickPhoto(bloc),
                      icon: const Icon(Icons.photo_camera),
                      label: const Text('Camera'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonalIcon(
                      key: const ValueKey('capture_gallery'),
                      onPressed: () => _pickFromGallery(bloc),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
                Dimens.boxMedium,
                Expanded(
                  child: BlocBuilder<CaptureBloc, CaptureState>(
                    builder: (context, state) {
                      if (state.isTranscribing) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('Reading on-device...'),
                            ],
                          ),
                        );
                      }
                      return switch (state.data) {
                        Idle() => const Center(
                          child: Text('No text yet.'),
                        ),
                        Loading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        Failure(:final reason) => Center(
                          child: Text(
                            reason.toString(),
                            style: TextStyle(color: Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Success(:final data) => data.isEmpty
                            ? const Center(child: Text('No text found.'))
                            : Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FilledButton.tonal(
                                      key: const ValueKey('capture_copy'),
                                      onPressed: () {
                                        Clipboard.setData(
                                            ClipboardData(text: data));
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Copied to clipboard')),
                                        );
                                      },
                                      child: const Text('Copy'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 8),
                                      child: Text(
                                        data,
                                        style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      };
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
