import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

/// Terminal simulation widget that displays rotating commands
/// with a nice terminal-like appearance and typing animation
class TerminalSimulation extends StatefulWidget {
  /// List of commands to rotate through
  final List<String> commands;

  /// Duration to show each command before rotating
  final Duration commandDuration;

  /// Duration for typing animation per character
  final Duration typingSpeed;

  /// Terminal prompt text (e.g., "$", ">", "dmtools>")
  /// This will be displayed statically on the screen
  final String prompt;

  /// Terminal background color (optional, uses theme if not provided)
  final Color? backgroundColor;

  /// Text color for commands (optional, uses theme if not provided)
  final Color? textColor;

  /// Accent color for prompt and "dmtools" keyword (optional, uses theme if not provided)
  final Color? promptColor;

  /// Whether to pause animations (e.g., during scroll or when off-screen)
  final bool paused;

  /// Whether to enable typing/cursor animations (disabled on web for performance)
  final bool enableAnimation;

  TerminalSimulation({
    required this.commands,
    Duration? commandDuration,
    Duration? typingSpeed,
    this.prompt = '\$',
    this.backgroundColor,
    this.textColor,
    this.promptColor,
    this.paused = false,
    this.enableAnimation = true,
    super.key,
  }) : commandDuration = commandDuration ?? const Duration(seconds: 3),
       typingSpeed = typingSpeed ?? const Duration(milliseconds: 50),
       assert(commands.isNotEmpty, 'Commands list cannot be empty');

  @override
  State<TerminalSimulation> createState() => _TerminalSimulationState();
}

class _TerminalSimulationState extends State<TerminalSimulation> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int _currentCommandIndex = 0;
  int _typedCharacters = 0;
  String _currentCommand = '';
  Timer? _typingTimer;
  Timer? _fadeTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _isDisposed = false;

    if (widget.enableAnimation) {
      _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat();
      if (!widget.paused) {
        _startCommandCycle();
      }
    } else {
      // When animation is disabled, use fade-in/out to cycle through commands
      _currentCommand = widget.commands.first;
      _typedCharacters = _currentCommand.length;
      if (!widget.paused && widget.commands.length > 1) {
        _startFadeCycle();
      }
    }
  }

  void _initializeAnimation() {
    if (widget.enableAnimation) {
      _controller ??= AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat();

      if (!_isDisposed && !widget.paused) {
        _startCommandCycle();
      }
    }
  }

  @override
  void didUpdateWidget(TerminalSimulation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableAnimation != oldWidget.enableAnimation) {
      if (widget.enableAnimation) {
        _fadeTimer?.cancel();
        _fadeTimer = null;
        _initializeAnimation();
      } else {
        _typingTimer?.cancel();
        _typingTimer = null;
        _controller?.stop();
        _controller?.dispose();
        _controller = null;
        setState(() {
          _currentCommand = widget.commands.first;
          _typedCharacters = _currentCommand.length;
        });
        if (!widget.paused && widget.commands.length > 1) {
          _startFadeCycle();
        }
      }
    }
    // Handle pause/unpause state changes
    if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        // Pause animations
        _typingTimer?.cancel();
        _typingTimer = null;
        _fadeTimer?.cancel();
        _fadeTimer = null;
        _controller?.stop();
      } else {
        if (widget.enableAnimation) {
          _controller ??= AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat();
          if (_typingTimer == null) {
            _startCommandCycle();
          }
        } else if (widget.commands.length > 1 && _fadeTimer == null) {
          _startFadeCycle();
        }
      }
    }
  }

  void _startCommandCycle() {
    if (!widget.enableAnimation) return;
    _currentCommandIndex = 0;
    _loadNextCommand();
  }

  void _startFadeCycle() {
    if (widget.enableAnimation || _isDisposed || widget.paused) return;

    // Cycle through commands every 3 seconds
    _fadeTimer = Timer.periodic(widget.commandDuration, (timer) {
      if (_isDisposed || !mounted || widget.paused || widget.enableAnimation) {
        timer.cancel();
        _fadeTimer = null;
        return;
      }

      setState(() {
        _currentCommandIndex = (_currentCommandIndex + 1) % widget.commands.length;
        _currentCommand = widget.commands[_currentCommandIndex];
        _typedCharacters = _currentCommand.length;
      });
    });
  }

  void _loadNextCommand() {
    if (!widget.enableAnimation) return;
    setState(() {
      _currentCommand = widget.commands[_currentCommandIndex];
      _typedCharacters = 0;
    });

    // Start typing animation
    _typeCommand();
  }

  void _typeCommand() {
    if (_isDisposed || widget.paused || !widget.enableAnimation) return;

    final command = widget.commands[_currentCommandIndex];
    int currentIndex = 0;

    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(widget.typingSpeed, (timer) {
      if (_isDisposed || !mounted || widget.paused || !widget.enableAnimation) {
        timer.cancel();
        return;
      }

      if (currentIndex <= command.length) {
        setState(() {
          _typedCharacters = currentIndex;
        });
        currentIndex++;
      } else {
        timer.cancel();
        _typingTimer = null;

        // Show full command for a while, then move to next
        final typingDuration = Duration(milliseconds: command.length * widget.typingSpeed.inMilliseconds);
        final remainingDuration = widget.commandDuration - typingDuration;
        if (remainingDuration.inMilliseconds > 0 &&
            !_isDisposed &&
            mounted &&
            !widget.paused &&
            widget.enableAnimation) {
          _typingTimer = Timer(remainingDuration, () {
            if (_isDisposed || !mounted || widget.paused || !widget.enableAnimation) return;

            // Move to next command
            setState(() {
              _currentCommandIndex = (_currentCommandIndex + 1) % widget.commands.length;
            });
            _loadNextCommand();
          });
        } else if (!_isDisposed && mounted && !widget.paused && widget.enableAnimation) {
          // Move to next command immediately
          setState(() {
            _currentCommandIndex = (_currentCommandIndex + 1) % widget.commands.length;
          });
          _loadNextCommand();
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _typingTimer?.cancel();
    _typingTimer = null;
    _fadeTimer?.cancel();
    _fadeTimer = null;
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colorsListening;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = widget.backgroundColor ?? colors.cardBg;
    final textColor = widget.textColor ?? colors.textColor;
    final promptColor = widget.promptColor ?? colors.accentColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: colors.shadowColor.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal header
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.8), shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.8), shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.8), shape: BoxShape.circle),
              ),
              const Spacer(),
              Text('Terminal', style: textTheme.bodySmall?.copyWith(color: colors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          // Terminal content
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Static prompt (always visible)
              Text(
                '${widget.prompt} ',
                style: textTheme.bodyLarge?.copyWith(
                  color: promptColor,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Command with typing animation and inline cursor, or fade transition for web
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: widget.enableAnimation
                      ? _buildCommandTextWithCursor(textTheme, textColor, colors.accentColor, colors)
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                          child: _buildCommandTextWithCursor(
                            textTheme,
                            textColor,
                            colors.accentColor,
                            colors,
                            key: ValueKey('cmd-$_currentCommandIndex'),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommandTextWithCursor(
    TextTheme textTheme,
    Color textColor,
    Color promptColor,
    ThemeColorSet colors, {
    Key? key,
  }) {
    // When animation is disabled, always show full command without cursor
    if (!widget.enableAnimation) {
      return KeyedSubtree(key: key, child: _buildFullCommandText(textTheme, textColor, promptColor));
    }

    // Hide cursor when no text (during transition between commands in animation mode)
    if (_typedCharacters == 0) {
      return const SizedBox.shrink();
    }

    final command = _currentCommand.isEmpty ? widget.commands.first : _currentCommand;
    final typedPart = command.substring(0, _typedCharacters);

    // Check if "dmtools" starts in the typed part (even if not complete)
    final dmtoolsIndex = typedPart.indexOf('dmtools');
    final List<InlineSpan> children = [];

    if (dmtoolsIndex != -1) {
      // "dmtools" starts at dmtoolsIndex, check how much of it is typed
      final dmtoolsStart = dmtoolsIndex;
      final dmtoolsEnd = (dmtoolsStart + 'dmtools'.length).clamp(0, _typedCharacters);
      final dmtoolsTyped = typedPart.substring(dmtoolsStart, dmtoolsEnd);

      // Split the command into parts: before "dmtools", partial/complete "dmtools", and after
      final beforeDmtools = typedPart.substring(0, dmtoolsStart);
      final afterDmtools = typedPart.substring(dmtoolsEnd);

      if (beforeDmtools.isNotEmpty) {
        children.add(TextSpan(text: beforeDmtools));
      }
      // Always highlight "dmtools" (even if partial) in blue
      children.add(
        TextSpan(
          text: dmtoolsTyped,
          style: TextStyle(color: promptColor, fontWeight: FontWeight.bold),
        ),
      );
      if (afterDmtools.isNotEmpty) {
        children.add(TextSpan(text: afterDmtools));
      }
    } else {
      // Check if we're in the middle of typing "dmtools" (partial match)
      // Look for partial "dmtools" at the end of typed text
      final dmtoolsPrefix = 'dmtools';
      int partialMatchLength = 0;
      for (int i = 1; i <= dmtoolsPrefix.length && i <= typedPart.length; i++) {
        final suffix = typedPart.substring(typedPart.length - i);
        final prefix = dmtoolsPrefix.substring(0, i);
        if (suffix == prefix) {
          partialMatchLength = i;
        }
      }

      if (partialMatchLength > 0) {
        // We're typing "dmtools" - highlight the partial match
        final beforePartial = typedPart.substring(0, typedPart.length - partialMatchLength);
        final partialMatch = typedPart.substring(typedPart.length - partialMatchLength);

        if (beforePartial.isNotEmpty) {
          children.add(TextSpan(text: beforePartial));
        }
        children.add(
          TextSpan(
            text: partialMatch,
            style: TextStyle(color: promptColor, fontWeight: FontWeight.bold),
          ),
        );
      } else {
        // No "dmtools" found yet, just show regular text
        children.add(TextSpan(text: typedPart));
      }
    }

    // Add cursor after the text (only when there's text)
    if (_controller != null && widget.enableAnimation) {
      children.add(
        WidgetSpan(
          child: AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) {
              return Opacity(
                opacity: (_controller!.value * 2) % 2 < 1 ? 1.0 : 0.0,
                child: Container(
                  width: 8,
                  height: 18,
                  margin: const EdgeInsets.only(left: 2),
                  color: colors.accentColor,
                ),
              );
            },
          ),
        ),
      );
    }

    return Text.rich(
      TextSpan(
        style: textTheme.bodyLarge?.copyWith(color: textColor, fontFamily: 'monospace'),
        children: children,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildFullCommandText(TextTheme textTheme, Color textColor, Color promptColor) {
    final command = _currentCommand.isEmpty ? widget.commands.first : _currentCommand;
    final dmtoolsIndex = command.indexOf('dmtools');
    final spans = <InlineSpan>[];

    if (dmtoolsIndex != -1) {
      final before = command.substring(0, dmtoolsIndex);
      final dmtoolsEnd = dmtoolsIndex + 'dmtools'.length;
      final after = command.substring(dmtoolsEnd);

      if (before.isNotEmpty) {
        spans.add(TextSpan(text: before));
      }
      spans.add(
        TextSpan(
          text: 'dmtools',
          style: TextStyle(color: promptColor, fontWeight: FontWeight.bold),
        ),
      );
      if (after.isNotEmpty) {
        spans.add(TextSpan(text: after));
      }
    } else {
      spans.add(TextSpan(text: command));
    }

    return Text.rich(
      TextSpan(
        style: textTheme.bodyLarge?.copyWith(color: textColor, fontFamily: 'monospace'),
        children: spans,
      ),
      textAlign: TextAlign.left,
    );
  }
}
