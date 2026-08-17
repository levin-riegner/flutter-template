import 'package:swiss_ai/data/corrector/repository/corrector_repository.dart';
import 'package:swiss_ai/data/corrector/service/local/corrector_service.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_bloc.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_event.dart';
import 'package:swiss_ai/presentation/corrector/bloc/corrector_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// On-device text corrector. Corrects a piece of text locally (no network)
/// using the pure-Dart [CorrectorService] behind [CorrectorBloc].
class CorrectorPage extends StatefulWidget {
  const CorrectorPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final CorrectorBloc? bloc;

  @override
  State<CorrectorPage> createState() => _CorrectorPageState();
}

class _CorrectorPageState extends State<CorrectorPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _correct(Bloc<CorrectorEvent, CorrectorState> bloc) {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    bloc.add(CorrectorEvent.correct(content: text));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ?? CorrectorBloc(getIt<CorrectorRepository>());
    return BlocProvider<CorrectorBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<CorrectorBloc>();
          return Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local text corrector',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Dimens.boxSmall,
                TextField(
                  key: const ValueKey('corrector_input'),
                  controller: _controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Type text to correct...',
                    border: OutlineInputBorder(),
                  ),
                ),
                Dimens.boxSmall,
                FilledButton(
                  key: const ValueKey('corrector_correct'),
                  onPressed: () => _correct(bloc),
                  child: const Text('Correct'),
                ),
                Dimens.boxMedium,
                Expanded(
                  child: BlocBuilder<CorrectorBloc, CorrectorState>(
                    builder: (context, state) {
                      if (state.isCorrecting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return switch (state.data) {
                        Idle() => const SizedBox.shrink(),
                        Loading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        Failure() => Center(
                          child: Text('Failed to correct text'),
                        ),
                        Success(:final data) => data.hasChanges
                            ? ListView(
                                children: [
                                  _ResultBlock(
                                    label: 'Corrected',
                                    text: data.corrected,
                                  ),
                                  Dimens.boxSmall,
                                  _ResultBlock(
                                    label: 'Fixes (${data.fixes.length})',
                                    text: data.fixes
                                        .map((fix) =>
                                            '${fix.index}: '
                                            '${fix.reason} -> ${fix.replacement}')
                                        .join('\n'),
                                  ),
                                ],
                              )
                            : Center(
                                child: Text('No changes needed.'),
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

class _ResultBlock extends StatelessWidget {
  final String label;
  final String text;

  const _ResultBlock({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        Dimens.boxSmall,
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
