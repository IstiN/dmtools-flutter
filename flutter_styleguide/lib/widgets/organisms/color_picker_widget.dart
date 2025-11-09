import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Visual color picker widget with color spectrum and saturation/brightness selector
class ColorPickerWidget extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWidget({
    required this.initialColor,
    required this.onColorChanged,
    super.key,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  late HSVColor _hsvColor;
  late double _hue;
  late double _saturation;
  late double _value;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.initialColor);
    _hue = _hsvColor.hue;
    _saturation = _hsvColor.saturation;
    _value = _hsvColor.value;
    _hexController = TextEditingController(text: _colorToHex(widget.initialColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _updateColor() {
    final newColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    _hexController.text = _colorToHex(newColor);
    widget.onColorChanged(newColor);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color spectrum (hue selector) - horizontal gradient
        _buildHueSpectrum(colors),

        const SizedBox(height: 16),

        // Saturation/Brightness square with selected color swatch
        Row(
          children: [
            // Saturation/Brightness square
            Expanded(
              child: _buildSaturationBrightnessSquare(colors),
            ),
            const SizedBox(width: 16),
            // Selected color swatch
            _buildColorSwatch(colors),
          ],
        ),

        const SizedBox(height: 16),

        // Hex input field
        _buildHexInput(colors),
      ],
    );
  }

  @override
  void didUpdateWidget(ColorPickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      final hsv = HSVColor.fromColor(widget.initialColor);
      setState(() {
        _hue = hsv.hue;
        _saturation = hsv.saturation;
        _value = hsv.value;
      });
      _hexController.text = _colorToHex(widget.initialColor);
    }
  }

  Widget _buildHueSpectrum(ThemeColorSet colors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            _updateHueFromPosition(details.localPosition.dx, constraints.maxWidth);
          },
          onTapDown: (details) {
            _updateHueFromPosition(details.localPosition.dx, constraints.maxWidth);
          },
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF0000), // Red
                  Color(0xFFFF00FF), // Magenta
                  Color(0xFF0000FF), // Blue
                  Color(0xFF00FFFF), // Cyan
                  Color(0xFF00FF00), // Green
                  Color(0xFFFFFF00), // Yellow
                  Color(0xFFFF0000), // Red (loop back)
                ],
                stops: [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Hue indicator
                Positioned(
                  left: (_hue / 360.0) * constraints.maxWidth - 2,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaturationBrightnessSquare(ThemeColorSet colors) {
    final baseColor = HSVColor.fromAHSV(1.0, _hue, 1.0, 1.0).toColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final squareWidth = constraints.maxWidth;
        final squareHeight = 200.0;

        return GestureDetector(
          onPanUpdate: (details) {
            _updateSaturationBrightnessFromPosition(details.localPosition, squareWidth, squareHeight);
          },
          onTapDown: (details) {
            _updateSaturationBrightnessFromPosition(details.localPosition, squareWidth, squareHeight);
          },
          child: Container(
            height: squareHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white,
                  baseColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Saturation/Brightness indicator
                  Positioned(
                    left: _saturation * squareWidth - 10,
                    top: (1.0 - _value) * squareHeight - 10,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorSwatch(ThemeColorSet colors) {
    final selectedColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectedColor,
            border: Border.all(color: colors.borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _colorToHex(selectedColor),
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHexInput(ThemeColorSet colors) {
    return TextField(
      controller: _hexController,
      decoration: InputDecoration(
        labelText: 'Hex Color',
        labelStyle: TextStyle(color: colors.textSecondary),
        hintText: '#4285F4',
        hintStyle: TextStyle(color: colors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: BorderSide(color: colors.accentColor, width: 2),
        ),
        filled: true,
        fillColor: colors.inputBg,
      ),
      style: TextStyle(color: colors.textColor, fontFamily: 'monospace'),
      onSubmitted: (value) {
        final color = _parseHexColor(value);
        if (color != null) {
          final hsv = HSVColor.fromColor(color);
          setState(() {
            _hue = hsv.hue;
            _saturation = hsv.saturation;
            _value = hsv.value;
          });
          _updateColor();
        }
      },
    );
  }

  void _updateHueFromPosition(double x, double width) {
    final newHue = (x / width * 360.0).clamp(0.0, 360.0);
    setState(() {
      _hue = newHue;
    });
    _updateColor();
  }

  void _updateSaturationBrightnessFromPosition(Offset position, double width, double height) {
    final newSaturation = (position.dx / width).clamp(0.0, 1.0);
    final newValue = (1.0 - (position.dy / height)).clamp(0.0, 1.0);

    setState(() {
      _saturation = newSaturation;
      _value = newValue;
    });
    _updateColor();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color? _parseHexColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

