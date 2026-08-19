import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/data/chat/model/chat_message.dart';
import 'package:swiss_ai/data/chat/repository/chat_repository.dart';
import 'package:swiss_ai/data/personas/repository/personas_repository.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_bloc.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_event.dart';
import 'package:swiss_ai/presentation/chat/bloc/chat_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final ChatBloc? bloc;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(Bloc<ChatEvent, ChatState> bloc) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    bloc.add(ChatEvent.sendMessage(content: text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ??
        ChatBloc(getIt<ChatRepository>(), getIt<PersonalitiesRepository>());
    return BlocProvider<ChatBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<ChatBloc>();
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.marginMedium, vertical: 8),
                child: FilledButton.tonal(
                  key: const ValueKey('chat_open_research'),
                  onPressed: () => GoRouter.of(context).go('/chat/research'),
                  child: const Text('Deep research'),
                ),
              ),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    final content = state.data;
                    return switch (content) {
                      Idle() => const SizedBox.shrink(),
                      Loading() => const Center(
                          child: CircularProgressIndicator()),
                      Failure() => Center(
                          child: Text('Failed to load chat')),
                      Success(:final data) => ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, position) =>
                            _MessageBubble(data[position]),
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
                        key: const ValueKey('chat_input'),
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Message the model...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('chat_send'),
                      onPressed: () => _sendMessage(bloc),
                      icon: const Icon(Icons.send),
                    ),
                    IconButton(
                      key: const ValueKey('chat_clear'),
                      onPressed: () => bloc.add(const ChatEvent.clear()),
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

class _MessageBubble extends StatelessWidget {
  final ChatMessage _message;

  const _MessageBubble(this._message);

  @override
  Widget build(BuildContext context) {
    final isUser = _message.isUser;
    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(_message.content),
      ),
    );
  }
}
