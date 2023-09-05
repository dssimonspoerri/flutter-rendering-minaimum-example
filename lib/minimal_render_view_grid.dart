import 'package:pixel_snapping/minimal_render_view.dart';
import 'package:flutter/material.dart';

/// [MinimalRenderViewGrid] lays out render views in a grid.
/// As a ValueNotifier+Button to toggle all views between video and image.
class MinimalRenderViewGrid extends StatelessWidget {
  /// Creates an instance of [MinimalRenderViewGrid].
  MinimalRenderViewGrid({
    Key? key,
  }) : super(key: key);

  final _showImageToogle = ValueNotifier(false);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: ValueListenableBuilder(
                    valueListenable: _showImageToogle,
                    builder: (context, value, child) => Text(
                      _showImageToogle.value
                          ? 'Showing Image'
                          : 'Showing Video',
                      style: const TextStyle(inherit: false),
                    ),
                  )),
              Container(
                  padding: const EdgeInsets.all(8),
                  child: FilledButton(
                    onPressed: () =>
                        _showImageToogle.value = !_showImageToogle.value,
                    child: const Text('Toggle Image/Video'),
                  ))
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: MinimalRenderView(
                        showImageValueNotifier: _showImageToogle)),
                Expanded(
                    child: MinimalRenderView(
                        showImageValueNotifier: _showImageToogle))
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: MinimalRenderView(
                        showImageValueNotifier: _showImageToogle)),
                Expanded(
                    child: MinimalRenderView(
                        showImageValueNotifier: _showImageToogle))
              ],
            ),
          ),
        ],
      );
}
