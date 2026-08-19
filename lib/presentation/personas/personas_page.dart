import 'package:swiss_ai/data/personas/model/persona.dart';
import 'package:swiss_ai/data/personas/repository/personas_repository.dart';
import 'package:swiss_ai/presentation/personas/bloc/personas_bloc.dart';
import 'package:swiss_ai/presentation/personas/bloc/personas_event.dart';
import 'package:swiss_ai/presentation/personas/bloc/personas_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lets the user pick an AI assistant persona to chat with.
class PersonalitiesPage extends StatefulWidget {
  const PersonalitiesPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final PersonalitiesBloc? bloc;

  @override
  State<PersonalitiesPage> createState() => _PersonalitiesPageState();
}

class _PersonalitiesPageState extends State<PersonalitiesPage> {
  late PersonalitiesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? PersonalitiesBloc(getIt<PersonalitiesRepository>());
    _bloc.add(const PersonalitiesEvent.load());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalitiesBloc>.value(
      value: _bloc,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose an assistant',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Dimens.boxSmall,
                Text(
                  'Pick the AI persona you want to chat with.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PersonalitiesBloc, PersonalitiesState>(
              builder: (context, state) {
                return switch (state.data) {
                  Idle() => const SizedBox.shrink(),
                  Loading() =>
                    const Center(child: CircularProgressIndicator()),
                  Failure() => Center(
                      child: Text('Failed to load personas'),
                    ),
                  Success(:final data) => data.isEmpty
                      ? const Center(child: Text('No personas available.'))
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, position) {
                            final persona = data[position];
                            return _PersonaTile(
                              persona: persona,
                              selected: state.selectedId == persona.id,
                              onTap: () => _bloc.add(
                                PersonalitiesEvent.select(id: persona.id),
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

class _PersonaTile extends StatelessWidget {
  final Persona persona;
  final bool selected;
  final VoidCallback onTap;

  const _PersonaTile({
    required this.persona,
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
              Icon(
                _iconFor(persona.iconName),
                color: scheme.primary,
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: Dimens.marginSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        persona.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        persona.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
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
}

const Map<String, IconData> _personaIcons = {
  'science': Icons.science,
  'bolt': Icons.bolt,
  'mood': Icons.mood,
  'school': Icons.school,
};

IconData _iconFor(String name) => _personaIcons[name] ?? Icons.smart_toy;
