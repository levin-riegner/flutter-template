import 'package:swiss_ai/data/study/repository/study_repository.dart';
import 'package:swiss_ai/presentation/deck_manager/bloc/deck_manager_bloc.dart';
import 'package:swiss_ai/presentation/deck_manager/bloc/deck_manager_event.dart';
import 'package:swiss_ai/presentation/deck_manager/bloc/deck_manager_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Create and manage study decks and their flashcards.
///
/// Launched from the Study page (no separate nav tab). Lists decks; opening a
/// deck shows its cards with add/remove, and decks can be created or deleted.
class DeckManagerPage extends StatefulWidget {
  const DeckManagerPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final DeckManagerBloc? bloc;

  @override
  State<DeckManagerPage> createState() => _DeckManagerPageState();
}

class _DeckManagerPageState extends State<DeckManagerPage> {
  final TextEditingController _deckController = TextEditingController();
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  late DeckManagerBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? DeckManagerBloc(getIt<StudyRepository>());
    _bloc.add(const DeckManagerEvent.load());
  }

  @override
  void dispose() {
    _deckController.dispose();
    _frontController.dispose();
    _backController.dispose();
    if (widget.bloc == null) {
      _bloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        title: Text('Deck manager'),
      ),
      body: BlocProvider<DeckManagerBloc>.value(
        value: _bloc,
        child: Builder(
          builder: (context) {
            final bloc = context.read<DeckManagerBloc>();
            return BlocBuilder<DeckManagerBloc, DeckManagerState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.marginMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.openDeckName == null)
                        Expanded(
                          child: _DeckList(
                            state: state,
                            onOpen: (name) => bloc.add(
                                DeckManagerEvent.openDeck(name: name)),
                            onDelete: (name) => bloc.add(
                                DeckManagerEvent.deleteDeck(name: name)),
                          ),
                        )
                      else
                        Expanded(
                          child: _DeckDetail(
                            state: state,
                            controllers: (
                              _frontController,
                              _backController,
                            ),
                            onAdd: () {
                              bloc.add(DeckManagerEvent.addCard(
                                front: _frontController.text,
                                back: _backController.text,
                              ));
                              _frontController.clear();
                              _backController.clear();
                            },
                            onRemove: (id) => bloc.add(
                                DeckManagerEvent.removeCard(id: id)),
                          ),
                        ),
                      Dimens.boxSmall,
                      if (state.openDeckName == null)
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const ValueKey('deck_name_input'),
                                controller: _deckController,
                                decoration: const InputDecoration(
                                  hintText: 'New deck name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Dimens.boxXSmall,
                            FilledButton(
                              key: const ValueKey('deck_create'),
                              onPressed: () {
                                bloc.add(DeckManagerEvent.createDeck(
                                    name: _deckController.text));
                                _deckController.clear();
                              },
                              child: const Text('Create'),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DeckList extends StatelessWidget {
  final DeckManagerState state;
  final ValueChanged<String> onOpen;
  final ValueChanged<String> onDelete;

  const _DeckList({
    required this.state,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state.decks) {
      Idle() => const SizedBox.shrink(),
      Loading() => const Center(child: CircularProgressIndicator()),
      Failure() => Center(child: Text('Could not load decks')),
      Success(:final data) => data.isEmpty
          ? const Center(child: Text('No decks yet. Create one below.'))
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final deck = data[index];
                return ListTile(
                  title: Text(
                    deck.name,
                    key: ValueKey('deck_tile_${deck.name}'),
                  ),
                  subtitle: Text(
                    '${deck.newCount} new · ${deck.dueCount} due',
                  ),
                  onTap: () => onOpen(deck.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDelete(deck.name),
                  ),
                );
              },
            ),
    };
  }
}

class _DeckDetail extends StatelessWidget {
  final DeckManagerState state;
  final (TextEditingController, TextEditingController) controllers;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const _DeckDetail({
    required this.state,
    required this.controllers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final (front, back) = controllers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.openDeckName ?? '',
          style: Theme.of(context).textTheme.titleMedium,
          key: const ValueKey('deck_open_title'),
        ),
        Dimens.boxSmall,
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('deck_front_input'),
                controller: front,
                decoration: const InputDecoration(
                  hintText: 'Front',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Dimens.boxXSmall,
            Expanded(
              child: TextField(
                key: const ValueKey('deck_back_input'),
                controller: back,
                decoration: const InputDecoration(
                  hintText: 'Back',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        Dimens.boxSmall,
        FilledButton(
          key: const ValueKey('deck_add_card'),
          onPressed: onAdd,
          child: const Text('Add card'),
        ),
        Dimens.boxMedium,
        Expanded(
          child: switch (state.cards) {
            Idle() => const SizedBox.shrink(),
            Loading() => const Center(child: CircularProgressIndicator()),
            Failure() => Center(child: Text('Could not load cards')),
            Success(:final data) => data.isEmpty
                ? const Center(child: Text('No cards in this deck yet.'))
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final card = data[index];
                      return ListTile(
                        title: Text(card.front),
                        subtitle: Text(card.back),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => onRemove(card.id),
                        ),
                      );
                    },
                  ),
          },
        ),
      ],
    );
  }
}
