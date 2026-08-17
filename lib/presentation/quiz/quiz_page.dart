import 'package:swiss_ai/data/quiz/repository/quiz_repository.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_bloc.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_event.dart';
import 'package:swiss_ai/presentation/quiz/bloc/quiz_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Generate a quiz from a pasted document with the on-device model,
/// then save it as a spaced-repetition study deck.
class QuizPage extends StatefulWidget {
  const QuizPage({super.key, this.bloc});

  final QuizBloc? bloc;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextEditingController _docController = TextEditingController();
  final TextEditingController _deckController = TextEditingController();
  int _count = 5;

  @override
  void initState() {
    super.initState();
    _deckController.text = 'Quiz';
  }

  @override
  void dispose() {
    _docController.dispose();
    _deckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ?? QuizBloc(getIt<QuizRepository>());
    return BlocProvider<QuizBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<QuizBloc>();
          return Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz from document',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(
                  'Paste a document — the on-device model turns it into '
                  'flashcards you can study.',
                  style: TextStyle(color: Colors.grey),
                ),
                Dimens.boxSmall,
                TextField(
                  key: const ValueKey('quiz_document_input'),
                  controller: _docController,
                  maxLines: 8,
                  minLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Paste document text...',
                    border: OutlineInputBorder(),
                  ),
                ),
                Dimens.boxSmall,
                Row(
                  children: [
                    const Text('Items:'),
                    const SizedBox(width: 8),
                    Slider(
                      key: const ValueKey('quiz_count_slider'),
                      value: _count.toDouble(),
                      min: 2,
                      max: 10,
                      divisions: 8,
                      label: '$_count',
                      onChanged: (v) =>
                          setState(() => _count = v.round()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('quiz_deck_name'),
                        controller: _deckController,
                        decoration: const InputDecoration(
                          labelText: 'Deck name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      key: const ValueKey('quiz_generate'),
                      onPressed: () => bloc.add(
                        QuizEvent.generate(
                          document: _docController.text,
                          count: _count,
                        ),
                      ),
                      child: const Text('Generate'),
                    ),
                  ],
                ),
                Dimens.boxMedium,
                Expanded(
                  child: BlocBuilder<QuizBloc, QuizState>(
                    builder: (context, state) {
                      return switch (state.data) {
                        Idle() => const Center(
                          child: Text('No quiz generated yet.'),
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
                        Success(:final data) =>
                            data.isEmpty
                                ? const Center(
                                    child: Text('No quiz generated yet.'),
                                  )
                                : ListView.builder(
                                    itemCount: data.length + 1,
                                    itemBuilder: (context, i) {
                                      if (i == 0) {
                                        return FilledButton.tonal(
                                          key: const ValueKey(
                                              'quiz_save_deck'),
                                          onPressed: state.isSaving
                                              ? null
                                              : () => bloc.add(
                                                    QuizEvent.saveAsDeck(
                                                      deckName:
                                                          _deckController
                                                              .text,
                                                    ),
                                                  ),
                                          child: state.isSaving
                                              ? const SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2),
                                                )
                                              : Text(
                                                  'Save ${data.length} '
                                                  'cards to Study'),
                                        );
                                      }
                                      final item = data[i - 1];
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              Dimens.marginMedium),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '$i. ${item.front}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight
                                                            .w600),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                item.back,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
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
        },
      ),
    );
  }
}
