import 'package:swiss_ai/data/hf_model/model/hf_model.dart';
import 'package:swiss_ai/data/hf_model/repository/hf_model_repository.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_bloc.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_event.dart';
import 'package:swiss_ai/presentation/hf_model/bloc/hf_model_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lets the user pick a downloadable on-device model from a commercial-safe
/// top-3 shortlist fetched from the HuggingFace Hub.
class HfModelPage extends StatefulWidget {
  const HfModelPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final HfModelBloc? bloc;

  @override
  State<HfModelPage> createState() => _HfModelPageState();
}

class _HfModelPageState extends State<HfModelPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ?? HfModelBloc(getIt<HfModelRepository>());
    return BlocProvider<HfModelBloc>.value(
      value: bloc,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose an on-device model',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Dimens.boxSmall,
                Text(
                  'Only downloadable, commercially-safe models are shown '
                  '(top 3 by popularity).',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Dimens.boxSmall,
                FilledButton(
                  onPressed: () => bloc.add(const HfModelEvent.refresh()),
                  child: const Text('Refresh shortlist'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<HfModelBloc, HfModelState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return switch (state.data) {
                  Idle() => const SizedBox.shrink(),
                  Loading() =>
                    const Center(child: CircularProgressIndicator()),
                  Failure() => Center(
                      child: Text('Failed to load models'),
                    ),
                  Success(:final data) => data.isEmpty
                      ? const Center(
                          child: Text('No models yet — refresh to discover.'),
                        )
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, position) {
                            final model = data[position];
                            return _ModelTile(
                              model: model,
                              selected: state.selectedId == model.id,
                              onTap: () => bloc.add(
                                HfModelEvent.select(modelId: model.id),
                              ),
                            );
                          },
                        ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ModelTile extends StatelessWidget {
  final HfModel model;
  final bool selected;
  final VoidCallback onTap;

  const _ModelTile({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.all(Dimens.marginSmall),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.marginSmall),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.displayName,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(model.id,
                        style: Theme.of(context).textTheme.bodySmall),
                    if (model.license != null)
                      Text(model.license!,
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: Dimens.marginXSmall),
                child: Text(
                  _formatDownloads(model.downloads),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDownloads(int downloads) {
    if (downloads >= 1000000) {
      return '${(downloads / 1000000).toStringAsFixed(1)}M';
    }
    if (downloads >= 1000) {
      return '${(downloads / 1000).toStringAsFixed(1)}k';
    }
    return '$downloads';
  }
}
