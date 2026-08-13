import 'package:color_picker/data/study_tutor/repository/study_tutor_repository.dart';
import 'package:color_picker/presentation/shared/design_system/theme/dimens.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_bloc.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_event.dart';
import 'package:color_picker/presentation/study_tutor/bloc/study_tutor_state.dart';
import 'package:color_picker/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// AI tutoring session over a flashcard deck. Launched from the Study page.
///
/// Sends the deck to the chat model (scoped by the active persona) and lets
/// the learner ask follow-up questions in a dialogue.
class StudyTutorPage extends StatefulWidget {
  const StudyTutorPage({super.key, required this.deckName, this.bloc});

  /// The deck to be tutored on.
  final String deckName;

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final StudyTutorBloc? bloc;

  @override
  State<StudyTutorPage> createState() => _StudyTutorPageState();
}

class _StudyTutorPageState extends State<StudyTutorPage> {
  final TextEditingController _controller = TextEditingController();
  late StudyTutorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? StudyTutorBloc(getIt<StudyTutorRepository>());
    _bloc.add(StudyTutorEvent.startTutoring(deckName: widget.deckName));
  }

  @override
  void dispose() {
    _controller.dispose();
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
        title: Text('AI tutor'),
      ),
      body: BlocProvider<StudyTutorBloc>.value(
        value: _bloc,
        child: Builder(
          builder: (context) {
            final bloc = context.read<StudyTutorBloc>();
            return Column(
              children: [
                Expanded(
                  child: BlocBuilder<StudyTutorBloc, StudyTutorState>(
                    builder: (context, state) {
                      return switch (state.session) {
                        Idle() => const SizedBox.shrink(),
                        Loading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        Failure() => const Center(
                          child: Text('Could not start tutoring.'),
                        ),
                        Success() => ListView.builder(
                            itemCount: state.dialogue.length,
                            itemBuilder: (context, index) => _DialogueBubble(
                              text: state.dialogue[index],
                              isUser: index.isEven,
                            ),
                          ),
                      };
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Dimens.marginSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const ValueKey('study_tutor_input'),
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Ask something about the deck...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Dimens.boxXSmall,
                      FilledButton(
                        key: const ValueKey('study_tutor_send'),
                        onPressed: () {
                          final question = _controller.text;
                          if (question.trim().isNotEmpty) {
                            bloc.add(
                                StudyTutorEvent.ask(question: question));
                            _controller.clear();
                          }
                        },
                        child: const Text('Ask'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DialogueBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _DialogueBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Dimens.marginMedium,
          vertical: Dimens.marginXSmall,
        ),
        padding: const EdgeInsets.all(Dimens.marginSmall),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Dimens.borderMedium),
        ),
        child: Text(text, style: textTheme.bodyMedium),
      ),
    );
  }
}
