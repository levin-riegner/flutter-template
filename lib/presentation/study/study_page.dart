import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/data/study/model/flashcard.dart';
import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/presentation/study/bloc/study_bloc.dart';
import 'package:swiss_ai/presentation/study/bloc/study_event.dart';
import 'package:swiss_ai/presentation/study/bloc/study_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:swiss_ai/app/navigation/router/app_routes.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key, this.bloc, this.deckName = 'Flutter Basics'});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final StudyBloc? bloc;

  /// The deck to study.
  final String deckName;

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  StudyBloc? _bloc;

  @override
  void initState() {
    super.initState();
    final bloc = widget.bloc ?? StudyBloc(getIt<StudyRepository>());
    _bloc = bloc;
    bloc.add(StudyEvent.openDeck(deckName: widget.deckName));
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _bloc!;
    return BlocProvider<StudyBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<StudyBloc>();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.marginMedium),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        key: const ValueKey('study_open_quiz'),
                        onPressed: () =>
                            GoRouter.of(context).go('/study/quiz'),
                        child: const Text('Quiz from document'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.tonal(
                        key: const ValueKey('study_open_capture'),
                        onPressed: () =>
                            GoRouter.of(context).go('/study/capture'),
                        child: const Text('Camera to text'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<StudyBloc, StudyState>(
            builder: (context, state) {
              final content = state.data;
              return switch (content) {
                Idle() => const SizedBox.shrink(),
                Loading() => const Center(child: CircularProgressIndicator()),
                Failure() => const Center(child: Text('Failed to load deck')),
                Success(:final data) => data.isEmpty
                    ? const Center(child: Text('No cards in this deck.'))
                    : _CardStack(data: data, state: state, bloc: bloc),
              };
            },
          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CardStack extends StatelessWidget {
  final List<Flashcard> _data;
  final StudyState _state;
  final StudyBloc _bloc;

  const _CardStack({
    required List<Flashcard> data,
    required StudyState state,
    required StudyBloc bloc,
  })  : _data = data,
        _state = state,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final clampedIndex =
        _state.index < data.length ? _state.index : data.length - 1;
    final card = data[clampedIndex];
    return Padding(
      padding: const EdgeInsets.all(Dimens.marginMedium),
      child: Column(
        children: [
          Text(
            'Card ${clampedIndex + 1} of ${data.length}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Dimens.boxSmall,
          Expanded(
            child: GestureDetector(
              key: const ValueKey('study_card'),
              onTap: () => _bloc.add(const StudyEvent.flip()),
              child: Card(
                margin: const EdgeInsets.all(Dimens.marginXSmall),
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.marginXLarge),
                  child: Center(
                    child: Text(
                      _state.isFlipped ? card.back : card.front,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Dimens.boxMedium,
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  key: const ValueKey('study_wrong'),
                  onPressed: () =>
                      _bloc.add(const StudyEvent.answer(correct: false)),
                  child: const Text('Wrong'),
                ),
              ),
              Dimens.boxXSmall,
              Expanded(
                child: FilledButton(
                  key: const ValueKey('study_correct'),
                  onPressed: () =>
                      _bloc.add(const StudyEvent.answer(correct: true)),
                  child: const Text('Correct'),
                ),
              ),
            ],
          ),
          Dimens.boxSmall,
          FilledButton(
            key: const ValueKey('study_tutor'),
            onPressed: () => StudyTutorRoute(deckName: 'Flutter Basics')
                .push(context),
            child: const Text('Tutor me with AI'),
          ),
          Dimens.boxXSmall,
          FilledButton(
            key: const ValueKey('study_manage_decks'),
            onPressed: () => const DeckManagerRoute().push(context),
            child: const Text('Manage decks'),
          ),
        ],
      ),
    );
  }
}
