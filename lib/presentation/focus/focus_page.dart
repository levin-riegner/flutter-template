import 'package:swiss_ai/data/focus/model/focus_session.dart';
import 'package:swiss_ai/data/focus/repository/focus_repository.dart';
import 'package:swiss_ai/presentation/focus/bloc/focus_bloc.dart';
import 'package:swiss_ai/presentation/focus/bloc/focus_event.dart';
import 'package:swiss_ai/presentation/focus/bloc/focus_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// On-device focus/Pomodoro timer. Tracks local focus sessions with elapsed
/// time and progress, all computed on the device via [FocusBloc].
class FocusPage extends StatefulWidget {
  const FocusPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final FocusBloc? bloc;

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  final TextEditingController _controller = TextEditingController();
  late FocusBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? FocusBloc(getIt<FocusRepository>());
    _bloc.add(const FocusEvent.loadSessions());
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
    return BlocProvider<FocusBloc>.value(
      value: _bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<FocusBloc>();
          return Padding(
            padding: const EdgeInsets.all(Dimens.marginMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Focus timer',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Dimens.boxSmall,
                TextField(
                  key: const ValueKey('focus_input'),
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Session label (e.g. Deep work)',
                    border: OutlineInputBorder(),
                  ),
                ),
                Dimens.boxSmall,
                FilledButton(
                  key: const ValueKey('focus_add'),
                  onPressed: () {
                    final label = _controller.text;
                    if (label.trim().isNotEmpty) {
                      bloc.add(FocusEvent.createSession(
                        label: label,
                        durationSeconds: FocusDurations.defaultFocusSeconds,
                      ));
                      _controller.clear();
                    }
                  },
                  child: const Text('Add session'),
                ),
                Dimens.boxMedium,
                Expanded(
                  child: BlocBuilder<FocusBloc, FocusState>(
                    builder: (context, state) {
                      return switch (state.sessions) {
                        Idle() => const SizedBox.shrink(),
                        Loading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        Failure() => Center(
                          child: Text('Could not load focus sessions'),
                        ),
                        Success(:final data) => data.isEmpty
                            ? const Center(
                                child: Text(
                                    'No sessions yet. Add one to start '
                                    'focusing.'),
                              )
                            : ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) => _SessionTile(
                                  session: data[index],
                                  isRunning:
                                      state.activeSessionId == data[index].id,
                                  onStart: () => bloc.add(
                                      FocusEvent.start(
                                          sessionId: data[index].id)),
                                  onPause: () => bloc.add(
                                      const FocusEvent.pause()),
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

class _SessionTile extends StatelessWidget {
  final FocusSession session;
  final bool isRunning;
  final VoidCallback onStart;
  final VoidCallback onPause;

  const _SessionTile({
    required this.session,
    required this.isRunning,
    required this.onStart,
    required this.onPause,
  });

  String get _timeLabel {
    final total = session.remainingSeconds;
    final minutes = total ~/ 60;
    final seconds = total % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.marginSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  session.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                _timeLabel,
                key: ValueKey('focus_time_${session.id}'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Dimens.boxXSmall,
          LinearProgressIndicator(
            key: ValueKey('focus_progress_${session.id}'),
            value: session.progress,
          ),
          Dimens.boxXSmall,
          if (isRunning)
            FilledButton(
              key: ValueKey('focus_pause_${session.id}'),
              onPressed: onPause,
              child: const Text('Pause'),
            )
          else
            FilledButton(
              key: ValueKey('focus_start_${session.id}'),
              onPressed: onStart,
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
}
