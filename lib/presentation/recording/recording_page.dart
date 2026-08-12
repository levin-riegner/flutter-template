import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:color_picker/data/recording/model/recording.dart';
import 'package:color_picker/data/recording/repository/recording_repository.dart';
import 'package:color_picker/presentation/recording/bloc/recording_bloc.dart';
import 'package:color_picker/presentation/recording/bloc/recording_event.dart';
import 'package:color_picker/presentation/recording/bloc/recording_state.dart';
import 'package:color_picker/presentation/shared/util/data_state.dart';
import 'package:color_picker/util/dependencies.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _capture(Bloc<RecordingEvent, RecordingState> bloc) {
    final text = _controller.text.trim();
    final title = text.isEmpty ? 'Meeting ${DateTime.now()}' : text;
    bloc.add(RecordingEvent.capture(title: title));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecordingBloc>(
      create: (context) => RecordingBloc(getIt<RecordingRepository>()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<RecordingBloc>();
          return Column(
            children: [
              Expanded(
                child: BlocBuilder<RecordingBloc, RecordingState>(
                  builder: (context, state) {
                    final content = state.data;
                    if (state.isCapturing) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    return switch (content) {
                      Idle() => const SizedBox.shrink(),
                      Loading() => const Center(
                          child: CircularProgressIndicator()),
                      Failure() => const Center(
                          child: Text('Failed to capture recording')),
                      Success(:final data) => data.isEmpty
                          ? const Center(
                              child: Text('No recordings yet.'))
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, position) =>
                                  _RecordingTile(data[position]),
                            ),
                    };
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Meeting title (optional)...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _capture(bloc),
                      icon: const Icon(Icons.mic),
                    ),
                    IconButton(
                      onPressed: () => bloc.add(const RecordingEvent.clear()),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RecordingTile extends StatelessWidget {
  final Recording _recording;

  const _RecordingTile(this._recording);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_recording.title),
            if (_recording.transcript != null)
              Text(
                _recording.transcript!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
