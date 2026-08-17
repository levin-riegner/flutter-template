import 'package:swiss_ai/data/research/repository/research_repository.dart';
import 'package:swiss_ai/presentation/research/bloc/research_bloc.dart';
import 'package:swiss_ai/presentation/research/bloc/research_event.dart';
import 'package:swiss_ai/presentation/research/bloc/research_error.dart';
import 'package:swiss_ai/presentation/research/bloc/research_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Deep research: web search + on-device synthesis into a sourced data.
class ResearchPage extends StatefulWidget {
  const ResearchPage({super.key, this.bloc});

  final ResearchBloc? bloc;

  @override
  State<ResearchPage> createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ?? ResearchBloc(getIt<ResearchRepository>());
    return BlocProvider<ResearchBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<ResearchBloc>();
          return Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deep research',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(
                  'Searches the web, then the on-device model writes a '
                  'sourced data.',
                  style: TextStyle(color: Colors.grey),
                ),
                Dimens.boxSmall,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('research_question'),
                        controller: _questionController,
                        decoration: const InputDecoration(
                          hintText: 'What should I research?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      key: const ValueKey('research_start'),
                      onPressed: () => bloc.add(
                        ResearchEvent.start(
                          question: _questionController.text,
                        ),
                      ),
                      child: const Text('Research'),
                    ),
                  ],
                ),
                Dimens.boxMedium,
                Expanded(
                  child: BlocBuilder<ResearchBloc, ResearchState>(
                    builder: (context, state) {
                      if (state.isResearching) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 12),
                              Text(state.stage.isEmpty
                                  ? 'Working...'
                                  : state.stage),
                              const SizedBox(height: 12),
                              TextButton(
                                key: const ValueKey('research_cancel'),
                                onPressed: () =>
                                    bloc.add(ResearchEvent.cancel()),
                                child: const Text('Cancel'),
                              ),
                            ],
                          ),
                        );
                      }
                      return switch (state.data) {
                        Idle() => const Center(
                          child: Text('Ask a question to start.'),
                        ),
                        Loading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        Failure(:final reason) => Center(
                          child: Text(
                            reason is Cancelled
                                ? 'Research cancelled.'
                                : reason.toString(),
                            style: TextStyle(
                                color: reason is Cancelled
                                    ? null
                                    : Colors.red[700]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Success(:final data) => SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.question,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontWeight:
                                          FontWeight.bold),
                            ),
                            Dimens.boxSmall,
                            Text('## ${data.subquestions.length} '
                                'sub-questions explored, '
                                '${data.distinctSourceCount} sources'),
                            Dimens.boxSmall,
                            ...data.subquestions
                                .asMap()
                                .entries
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                          '${e.key + 1}. ${e.value}',
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                    )),
                            Dimens.boxMedium,
                            Text('## Report',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall),
                            Dimens.boxSmall,
                            Text(data.summary),
                            Dimens.boxMedium,
                            Text('## Notes',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall),
                            Dimens.boxSmall,
                            ...data.notes
                                .map((n) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(n.fact),
                                          Text(
                                            n.sourceUrl,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.blueGrey,
                                            ),
                                            overflow:
                                                TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    )),
                          ],
                        ),
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
