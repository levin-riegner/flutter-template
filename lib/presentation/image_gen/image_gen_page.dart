import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swiss_ai/data/image_gen/model/generated_image.dart';
import 'package:swiss_ai/data/image_gen/repository/image_gen_repository.dart';
import 'package:swiss_ai/presentation/image_gen/bloc/image_gen_bloc.dart';
import 'package:swiss_ai/presentation/image_gen/bloc/image_gen_event.dart';
import 'package:swiss_ai/presentation/image_gen/bloc/image_gen_state.dart';
import 'package:swiss_ai/presentation/shared/design_system/theme/dimens.dart';
import 'package:swiss_ai/presentation/shared/util/data_state.dart';
import 'package:swiss_ai/util/dependencies.dart';

class ImageGenPage extends StatefulWidget {
  const ImageGenPage({super.key, this.bloc});

  /// Optional injected bloc (used by widget tests); when null, the page
  /// creates one from the DI container.
  final ImageGenBloc? bloc;

  @override
  State<ImageGenPage> createState() => _ImageGenPageState();
}

class _ImageGenPageState extends State<ImageGenPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate(Bloc<ImageGenEvent, ImageGenState> bloc) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    bloc.add(ImageGenEvent.generate(prompt: text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.bloc ?? ImageGenBloc(getIt<ImageGenRepository>());
    return BlocProvider<ImageGenBloc>.value(
      value: bloc,
      child: Builder(
        builder: (context) {
          final bloc = context.read<ImageGenBloc>();
          return Column(
            children: [
              Expanded(
                child: BlocBuilder<ImageGenBloc, ImageGenState>(
                  builder: (context, state) {
                    final content = state.data;
                    if (state.isGenerating) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    return switch (content) {
                      Idle() => const SizedBox.shrink(),
                      Loading() => const Center(
                          child: CircularProgressIndicator()),
                      Failure() => const Center(
                          child: Text('Failed to generate image')),
                      Success(:final data) => data.isEmpty
                          ? const Center(
                              child: Text('No images yet — enter a prompt.'))
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, position) {
                                final image = data[position];
                                return _ImageCard(image);
                              },
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
                        key: const ValueKey('image_gen_input'),
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Describe an image to generate...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      key: const ValueKey('image_gen_generate'),
                      onPressed: () => _generate(bloc),
                      icon: const Icon(Icons.auto_awesome),
                    ),
                    IconButton(
                      key: const ValueKey('image_gen_clear'),
                      onPressed: () => bloc.add(const ImageGenEvent.clear()),
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

class _ImageCard extends StatelessWidget {
  final GeneratedImage _image;

  const _ImageCard(this._image);

  @override
  Widget build(BuildContext context) {
    final image = _image.url != null
        ? CachedNetworkImage(imageUrl: _image.url!)
        : null;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ?image,
            Dimens.boxSmall,
            Text(_image.prompt),
          ],
        ),
      ),
    );
  }
}
