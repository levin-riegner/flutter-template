import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:color_picker/presentation/color_picker/tabs/rgb_picker_tab.dart';
import 'package:color_picker/presentation/color_picker/tabs/cmyk_picker_tab.dart';
import 'package:color_picker/presentation/color_picker/tabs/palette_tab.dart';

class ColorPickerPage extends StatefulWidget {
  const ColorPickerPage({super.key});

  @override
  State<ColorPickerPage> createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  HSVColor _hsvColor = HSVColor.fromColor(Colors.deepPurple);

  Color get _color => _hsvColor.toColor();

  String get _hexString =>
      '#${_color.value.toRadixString(16).substring(2).toUpperCase()}';

  void _onColorChanged(HSVColor color) {
    setState(() => _hsvColor = color);
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $text'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Color Picker'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.palette), text: 'RGB'),
              Tab(icon: Icon(Icons.print), text: 'CMYK'),
              Tab(icon: Icon(Icons.auto_awesome), text: 'Palette'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RgbPickerTab(
              hsvColor: _hsvColor,
              color: _color,
              hexString: _hexString,
              onColorChanged: _onColorChanged,
              onCopyHex: () => _copyToClipboard(_hexString),
            ),
            CmykPickerTab(
              color: _color,
              hexString: _hexString,
              onColorChanged: (color) =>
                  _onColorChanged(HSVColor.fromColor(color)),
              onCopy: _copyToClipboard,
            ),
            PaletteTab(
              seedColor: _color,
              onColorSelected: (color) =>
                  _onColorChanged(HSVColor.fromColor(color)),
              onCopy: _copyToClipboard,
            ),
          ],
        ),
      ),
    );
  }
}
