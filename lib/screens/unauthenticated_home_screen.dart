import 'dart:async';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:dmtools_styleguide/widgets/molecules/custom_card.dart';
import 'package:dmtools_styleguide/utils/syntax_highlighter.dart';
import '../widgets/auth_login_widget.dart';
import '../core/services/release_service.dart';

class UnauthenticatedHomeScreen extends StatefulWidget {
  const UnauthenticatedHomeScreen({super.key});

  @override
  State<UnauthenticatedHomeScreen> createState() => _UnauthenticatedHomeScreenState();
}

class _UnauthenticatedHomeScreenState extends State<UnauthenticatedHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;
  Timer? _scrollEndTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Mark as scrolling immediately for better Safari performance
    if (!_isScrolling) {
      setState(() {
        _isScrolling = true;
      });
    }

    // Cancel previous timer
    _scrollEndTimer?.cancel();

    // Use shorter debounce for Safari (100ms instead of 150ms) for faster resume
    _scrollEndTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isScrolling = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollEndTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openReleasesPage() async {
    final urlString = await ReleaseService.getReleasesPageUrl();
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openOpenSource() async {
    final url = Uri.parse('https://github.com/IstiN/dmtools-flutter');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openDocumentation() async {
    // Placeholder - update with actual docs URL when available
    final url = Uri.parse('https://github.com/IstiN/dmtools-flutter');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes (Scaffold must rebuild on theme change!)
    final colors = context.colorsListening;
    return Scaffold(
      backgroundColor: colors.bgColor,
      body: Column(
        children: [
          // macOS titlebar spacer (only for native macOS, not web)
          if (!kIsWeb && Platform.isMacOS) const SizedBox(height: 12),

          // App Header from styleguide
          AppHeader(
            showTitle: false, // Hide header text
            showSearch: false, // Hide search as requested
            onThemeToggle: () async => await Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            actions: const [], // Remove actions as we'll use profileButton
            profileButton: UserProfileButton(
              loginState: LoginState.loggedOut,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return PopScope(
                      onPopInvokedWithResult: (didPop, result) {
                        if (!didPop) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(16),
                        elevation: 0,
                        child: FocusScope(autofocus: true, child: AuthLoginWidget()),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.isWideScreen(context) ? 64 : 24),
                child: Column(
                  children: [
                    _HeroSection(
                      onInstall: _openReleasesPage,
                      onOpenSource: _openOpenSource,
                      isScrolling: _isScrolling,
                    ),
                    const SizedBox(height: 64),
                    const _PillarsSection(),
                    const SizedBox(height: 64),
                    _RiversSection(
                      onInstall: _openReleasesPage,
                      onViewDocs: _openDocumentation,
                      onOpenSource: _openOpenSource,
                    ),
                    const SizedBox(height: 64),
                    const _FaqSection(),
                    const SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Screenshot Image Widget
class _ScreenshotImage extends StatelessWidget {
  final String imagePath;

  const _ScreenshotImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colorsListening;
    final isDarkMode = context.isDarkModeListening;

    // Use theme-based image for dm-ai-app
    final String finalImagePath = imagePath == 'assets/img/dm-ai-app.png'
        ? (isDarkMode ? 'assets/img/dm-ai-app-dark.png' : 'assets/img/dm-ai-app-light.png')
        : imagePath;

    return CustomCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: kIsWeb
              ? [
                  // Simplified shadow for web/Safari performance
                  BoxShadow(
                    color: colors.accentColor.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  // Outer glow effect
                  BoxShadow(color: colors.accentColor.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2),
                  // Inner shadow for depth
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDarkMode ? 0.5 : 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: RepaintBoundary(
            key: ValueKey('screenshot-$finalImagePath-$isDarkMode'),
            child: Image.asset(
              finalImagePath,
              key: ValueKey('image-$finalImagePath-$isDarkMode'),
              fit: BoxFit.contain,
              // Optimize image loading for web performance
              cacheWidth: kIsWeb ? 1200 : null,
              cacheHeight: kIsWeb ? 800 : null,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to placeholder if image fails to load
                return const _ScreenshotPlaceholder();
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Screenshot Placeholder styled as a presentation slide with glow effect
class _ScreenshotPlaceholder extends StatelessWidget {
  const _ScreenshotPlaceholder();

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colorsListening;
    final textTheme = Theme.of(context).textTheme;
    // Use isDarkModeListening to react to theme changes
    final isDarkMode = context.isDarkModeListening;

    return CustomCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            // Outer glow effect
            BoxShadow(color: colors.accentColor.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2),
            // Inner shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.5 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: colors.cardBg,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.cardBg, colors.cardBg.withValues(alpha: 0.95)],
                ),
              ),
              child: Stack(
                children: [
                  // Subtle background pattern
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.05,
                      child: CustomPaint(painter: _GridPatternPainter(colors: colors)),
                    ),
                  ),
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Glow effect around icon
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.accentColor.withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(Icons.screenshot_monitor, size: 64, color: colors.accentColor),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Screenshot Coming Soon',
                          style: textTheme.titleLarge?.copyWith(color: colors.textColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Visual demonstration of this feature',
                          style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Grid pattern painter for subtle background
class _GridPatternPainter extends CustomPainter {
  final ThemeColorSet colors;

  _GridPatternPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.borderColor
      ..strokeWidth = 1;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Simple Code Block without collapse functionality
class _SimpleCodeBlock extends StatelessWidget {
  final String code;
  final String? language;
  final bool showLanguageBadge;
  final bool inlineCopyButton;

  const _SimpleCodeBlock({
    required this.code,
    this.language,
    this.showLanguageBadge = true,
    this.inlineCopyButton = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.codeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!inlineCopyButton) ...[
            // Header with language badge and copy button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.codeBgColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  if (language != null && showLanguageBadge) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF6A737D), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        language!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ] else
                    const Spacer(),
                  CopyButton(textToCopy: code),
                ],
              ),
            ),
          ],
          // Code content
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.codeBgColor,
              borderRadius: inlineCopyButton
                  ? BorderRadius.circular(8)
                  : const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: _buildCodeContent(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeContent(ThemeColorSet colors) {
    // Determine if we're using light theme
    final isLightTheme = colors.codeBgColor.computeLuminance() > 0.5;
    final highlightedSpans = SyntaxHighlighter.highlight(code, language, isLightTheme: isLightTheme);

    // Check if highlighting worked
    final nonEmptySpans = highlightedSpans.where((span) => span.text != null && span.text!.isNotEmpty).toList();
    final hasHighlighting =
        nonEmptySpans.any(
          (span) =>
              span.style?.color != null &&
              span.style!.color != SyntaxHighlighter.defaultTextColor &&
              span.style!.color != SyntaxHighlighter.defaultColorLight,
        ) ||
        nonEmptySpans.length > 1;

    final codeWidget = hasHighlighting && nonEmptySpans.isNotEmpty
        ? SelectableText.rich(
            TextSpan(
              children: nonEmptySpans,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace', height: 1.5),
            ),
          )
        : SelectableText(
            code,
            style: const TextStyle(fontSize: 14, fontFamily: 'monospace', color: Color(0xFFE1E4E8), height: 1.5),
          );

    if (inlineCopyButton) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: codeWidget),
          const SizedBox(width: 12),
          CopyButton(textToCopy: code),
        ],
      );
    } else {
      return codeWidget;
    }
  }
}

// Hero Section
class _HeroSection extends StatefulWidget {
  final VoidCallback onInstall;
  final VoidCallback onOpenSource;
  final bool isScrolling;

  const _HeroSection({required this.onInstall, required this.onOpenSource, required this.isScrolling});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  String _cliInstallCommand = 'curl -fsSL https://github.com/IstiN/dmtools/releases/download/v1.7.91/install.sh | bash';

  @override
  void initState() {
    super.initState();
    _loadCliInstallCommand();
  }

  Future<void> _loadCliInstallCommand() async {
    try {
      final command = await ReleaseService.getCliInstallCommand();
      if (mounted) {
        setState(() {
          _cliInstallCommand = command;
        });
      }
    } catch (e) {
      // Keep default command if loading fails
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colorsListening;
    final textTheme = Theme.of(context).textTheme;

    return ResponsiveBuilder(
      mobile: (context, constraints) => _buildMobileLayout(context, colors, textTheme),
      desktop: (context, constraints) => _buildDesktopLayout(context, colors, textTheme),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    return Column(
      children: [
        _buildHeading(context, colors, textTheme),
        const SizedBox(height: 48),
        _buildTerminal(context, colors),
        const SizedBox(height: 48),
        _buildDescription(context, colors, textTheme),
        const SizedBox(height: 48),
        _buildTwoColumns(context, colors, textTheme),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    return Column(
      children: [
        _buildHeading(context, colors, textTheme),
        const SizedBox(height: 64),
        _buildTerminal(context, colors),
        const SizedBox(height: 64),
        _buildDescription(context, colors, textTheme),
        const SizedBox(height: 64),
        _buildTwoColumns(context, colors, textTheme),
      ],
    );
  }

  Widget _buildTerminal(BuildContext context, ThemeColorSet colors) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = (screenWidth * 0.5).clamp(400.0, 800.0); // Responsive: 50% of screen, but between 400-800px
    // Use isDarkModeListening to react to theme changes
    final isDarkMode = context.isDarkModeListening;

    return RepaintBoundary(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SelectionContainer.disabled(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                boxShadow: kIsWeb
                    ? [
                        // Simplified shadow for web/Safari performance
                        BoxShadow(
                          color: colors.accentColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        // Multiple shadow layers for depth
                        BoxShadow(
                          color: colors.accentColor.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDarkMode ? 0.5 : 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.1),
                          blurRadius: 10,
                          spreadRadius: -2,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Visibility(
                maintainState: true,
                child: IgnorePointer(
                  // Disable pointer events during scroll for better Safari performance
                  ignoring: widget.isScrolling && kIsWeb,
                  child: TerminalSimulation(
                    commands: const [
                      'dmtools run business_analysis_agent',
                      'dmtools run refinement_agent',
                      'dmtools run solution_architecture_agent',
                      'dmtools run test_cases_generation_agent',
                      'dmtools run developer_agent',
                    ],
                    commandDuration: const Duration(seconds: 3),
                    typingSpeed: const Duration(milliseconds: 50),
                    prompt: 'dm.ai>',
                    promptColor: const Color(0xFF8B5CF6),
                    paused: widget.isScrolling, // Pause during scroll
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    final baseFontSize = (textTheme.displayLarge?.fontSize ?? 57) * 1.2;
    final blueFontSize = baseFontSize * 1.35; // 35% bigger for blue blocks

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Text.rich(
        TextSpan(
          style: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w300, // Lighter weight
            color: colors.textColor,
            height: 1.5, // Increased line height
            fontFamily: 'Inter',
            fontSize: baseFontSize,
          ),
          children: [
            const TextSpan(text: 'Is it easier to train '),
            TextSpan(
              text: 'thousands employees',
              style: TextStyle(
                color: colors.accentColor,
                fontWeight: FontWeight.w300, // Lighter weight for blue text
                fontSize: blueFontSize,
              ),
            ),
            const TextSpan(text: '\n'),
            const TextSpan(text: 'to write perfect prompts,\n'),
            const TextSpan(text: '\nor '),
            TextSpan(
              text: 'to',
              style: TextStyle(
                color: colors.accentColor,
                fontWeight: FontWeight.w300, // Lighter weight for blue text
                fontSize: blueFontSize,
              ),
            ),
            const TextSpan(text: ' build a '),
            TextSpan(
              text: 'system of expert agents',
              style: TextStyle(
                color: colors.accentColor,
                fontWeight: FontWeight.w300, // Lighter weight for blue text
                fontSize: blueFontSize,
              ),
            ),
            const TextSpan(text: ' for them to use?'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    final baseFontSize = (textTheme.bodyMedium?.fontSize ?? 16) * 1.25;
    final blueFontSize = baseFontSize * 1.35; // 35% bigger for blue blocks

    return Text.rich(
      TextSpan(
        style: textTheme.bodyMedium?.copyWith(
          color: colors.textSecondary,
          height: 1.5, // Increased line height
          fontSize: baseFontSize,
        ),
        children: [
          const TextSpan(
            text:
                'DMTools provides a comprehensive AI agent orchestration platform that connects all your project tools through ',
          ),
          const TextSpan(text: '\n'),
          const TextSpan(text: 'a unified '),
          TextSpan(
            text: 'CLI',
            style: TextStyle(
              color: colors.accentColor,
              fontWeight: FontWeight.w300, // Lighter weight for blue text
              fontSize: blueFontSize,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Desktop',
            style: TextStyle(
              color: colors.accentColor,
              fontWeight: FontWeight.w300, // Lighter weight for blue text
              fontSize: blueFontSize,
            ),
          ),
          const TextSpan(text: ' interface. Build expert agents, automate workflows, deliver faster.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTwoColumns(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    return ResponsiveBuilder(
      mobile: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLeftColumn(context, colors, textTheme),
          const SizedBox(height: 32),
          _buildRightColumn(context, colors, textTheme),
        ],
      ),
      desktop: (context, constraints) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildLeftColumn(context, colors, textTheme)),
          const SizedBox(width: 48),
          Expanded(child: _buildRightColumn(context, colors, textTheme)),
        ],
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description text
        Text(
          'Built to help you ship, right from your terminal',
          style: textTheme.titleLarge?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        // Instructions button
        Align(
          alignment: Alignment.centerLeft,
          child: SelectionContainer.disabled(
            child: IntrinsicWidth(
              child: SecondaryButton(
                text: 'Instructions',
                testId: generateTestId('button', {'action': 'view-installation-instructions', 'context': 'hero'}),
                semanticLabel: generateSemanticLabel('button', 'View installation instructions'),
                onPressed: () async {
                  final url = Uri.parse('https://github.com/IstiN/dmtools/releases/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                size: ButtonSize.small,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // CLI Install Code Block (simple version without collapse)
        _SimpleCodeBlock(code: _cliInstallCommand, language: 'bash', showLanguageBadge: false, inlineCopyButton: true),
        const SizedBox(height: 24),
        // CLI image
        const _ScreenshotImage(imagePath: 'assets/img/dmtools-cli.png'),
      ],
    );
  }

  Widget _buildRightColumn(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description text
        Text(
          'Run Desktop with your local models',
          style: textTheme.titleLarge?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        // Buttons in one line
        SelectionContainer.disabled(
          child: Row(
            children: [
              PrimaryButton(
                text: 'Install Desktop',
                testId: generateTestId('button', {'action': 'install-desktop', 'context': 'hero'}),
                semanticLabel: generateSemanticLabel('button', 'Install DMTools Desktop now'),
                onPressed: widget.onInstall,
                size: ButtonSize.small,
              ),
              const SizedBox(width: 12),
              SecondaryButton(
                text: 'OpenSource',
                testId: generateTestId('button', {'action': 'view-opensource', 'context': 'hero'}),
                semanticLabel: generateSemanticLabel('button', 'View open source repository'),
                onPressed: widget.onOpenSource,
                size: ButtonSize.small,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Desktop app image
        const _ScreenshotImage(imagePath: 'assets/img/dm-ai-app.png'),
      ],
    );
  }
}

// Pillars Section
class _PillarsSection extends StatefulWidget {
  const _PillarsSection();

  @override
  State<_PillarsSection> createState() => _PillarsSectionState();
}

class _PillarsSectionState extends State<_PillarsSection> with AutomaticKeepAliveClientMixin {
  static const List<_PillarData> _pillars = [
    _PillarData(
      heading: 'Unified MCP access across all platforms',
      description:
          'Configure MCP tools once and use them with Cursor, Copilot, Claude Code, Gemini, or CLI commands. Combine different MCP tools via JS code execution and save tokens.',
      svgIconPath: 'packages/dmtools_styleguide/assets/img/nav-icon-mcp.svg',
    ),
    _PillarData(
      heading: 'Agent-powered, CLI-first architecture',
      description:
          'Configure tools and agents together, then execute them via CLI or locally to maximize your AI workflow efficiency.',
      svgIconPath: 'packages/dmtools_styleguide/assets/img/nav-icon-ai-jobs.svg',
    ),
    _PillarData(
      heading: 'Open source, full control',
      description: 'Open source AI-native tools built by AI, with humans in control.',
      icon: Icons.code, // GitHub icon for open source
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return ResponsiveBuilder(
      mobile: (context, constraints) => _buildMobileLayout(context),
      desktop: (context, constraints) => _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _pillars.length; i++) ...[
          _PillarCard(
            icon: _pillars[i].icon,
            svgIconPath: _pillars[i].svgIconPath,
            heading: _pillars[i].heading,
            description: _pillars[i].description,
          ),
          if (i < _pillars.length - 1) const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _pillars.length; i++) ...[
          Expanded(
            child: _PillarCard(
              icon: _pillars[i].icon,
              svgIconPath: _pillars[i].svgIconPath,
              heading: _pillars[i].heading,
              description: _pillars[i].description,
            ),
          ),
          if (i < _pillars.length - 1) const SizedBox(width: 24),
        ],
      ],
    );
  }
}

class _PillarData {
  final IconData? icon;
  final String? svgIconPath;
  final String heading;
  final String description;

  const _PillarData({required this.heading, required this.description, this.icon, this.svgIconPath})
    : assert(icon != null || svgIconPath != null, 'Either icon or svgIconPath must be provided');
}

class _PillarCard extends StatelessWidget {
  final IconData? icon;
  final String? svgIconPath;
  final String heading;
  final String description;

  const _PillarCard({required this.heading, required this.description, this.icon, this.svgIconPath})
    : assert(icon != null || svgIconPath != null, 'Either icon or svgIconPath must be provided');

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        svgIconPath != null
            ? RepaintBoundary(
                child: SvgPicture.asset(
                  svgIconPath!,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(colors.accentColor, BlendMode.srcIn),
                ),
              )
            : Icon(icon!, size: 32, color: colors.accentColor),
        const SizedBox(height: 16),
        Text(
          heading,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.textColor),
        ),
        const SizedBox(height: 12),
        Text(description, style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary, height: 1.6)),
      ],
    );
  }
}

// Glow Wrapper Widget for adding glow effect to any widget
class _GlowWrapper extends StatelessWidget {
  final Widget child;

  const _GlowWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: kIsWeb
            ? [
                // Simplified shadow for web/Safari performance
                BoxShadow(
                  color: colors.accentColor.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: colors.accentColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: colors.accentColor.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: child,
    );
  }
}

// Code Example Item (Text on left, Code on right)
class _CodeExampleItem extends StatelessWidget {
  final VoidCallback? onInstall;
  final VoidCallback? onViewDocs;
  final VoidCallback? onOpenSource;

  const _CodeExampleItem({this.onInstall, this.onViewDocs, this.onOpenSource});

  static const String _codeExample = r'''/**
 * Simple Workflow: Ticket → Figma → AI → Cursor
 * MCP tools orchestration via JavaScript
 */
function action(params) {
    try {
        const ticketKey = params.ticket.key;
        
        // Step 1: Read ticket details
        const ticket = jira_get_ticket({
            key: ticketKey,
            fields: ["summary", "description"]
        });
        
        // Step 2: Extract Figma link
        const text = (ticket.description || "").toLowerCase();
        const figmaUrl = text.match(/(https?:\/\/[^\s]*figma\.com\/[^\s]*)/i)?.[1];
      
        // Step 3: Get Figma design elements
        const figmaIcons = figma_get_icons({ href: figmaUrl });
        
        // Step 4: Generate prompt with AI
        const prompt = `Implement: ${ticketKey} - ${ticket.summary}
          Design: ${figmaUrl}
          Elements: ${figmaIcons?.length || 0} found`;
        
        const devPrompt = gemini_ai_chat({ message: prompt });
        
        // Step 5: Execute Cursor CLI
        const result = cli_execute_command({ 
            command: `cursor --prompt "${devPrompt}"` 
        });
        
        // Post completion
        jira_post_comment({
            key: ticketKey,
            comment: `✅ Development Done`
        });
        
        return { success: true, ticketKey, result };
    } catch (error) {
        return { success: false, error: error.toString() };
    }
}''';

  @override
  Widget build(BuildContext context) {
    // Use isDarkModeListening to react to theme changes
    final isDarkMode = context.isDarkModeListening;
    return ResponsiveBuilder(
      mobile: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MediumHeadlineText('MCP tools orchestration via JavaScript interface'),
              const SizedBox(height: 16),
              const LargeBodyText(
                'Code execution with MCP enables agents to use context more efficiently by loading tools on demand.',
              ),
              const SizedBox(height: 32),
              const _FlowDiagram(),
              const SizedBox(height: 24),
              const MediumHeadlineText('Leverage MCP context and extend with your own tools'),
              const SizedBox(height: 16),
              const LargeBodyText(
                'Bring context from your issues and pull requests directly to your environment, eliminating context switching. Plus, extend DMTools capabilities through custom MCP servers.',
              ),
              if (onInstall != null && onViewDocs != null) ...[
                const SizedBox(height: 32),
                _IntegrationsList(onInstall: onInstall, onViewDocs: onViewDocs),
              ],
            ],
          ),
          const SizedBox(height: 24),
          RepaintBoundary(
            child: _GlowWrapper(
              child: CodeDisplayBlock(
                key: ValueKey('js-code-$isDarkMode'),
                code: _codeExample,
                language: 'javascript',
                maxHeight: kIsWeb ? null : 600, // No maxHeight on web to avoid nested scrolling
                theme: CodeDisplayTheme.auto,
              ),
            ),
          ),
          if (onInstall != null && onViewDocs != null) ...[
            const SizedBox(height: 32),
            _CtaBannerSection(
              onInstall: onInstall!,
              onViewDocs: onViewDocs!,
              onOpenSource: onOpenSource,
              showInstructionsAndCli: true,
            ),
          ],
        ],
      ),
      desktop: (context, constraints) {
        final textWidget = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MediumHeadlineText('MCP tools orchestration via JavaScript interface'),
              const SizedBox(height: 16),
              const LargeBodyText(
                'Code execution with MCP enables agents to use context more efficiently by loading tools on demand.',
              ),
              const SizedBox(height: 32),
              const _FlowDiagram(),
              const SizedBox(height: 24),
              const MediumHeadlineText('Leverage MCP context and extend with your own tools'),
              const SizedBox(height: 16),
              const LargeBodyText(
                'Bring context from your issues and pull requests directly to your environment, eliminating context switching. Plus, extend DMTools capabilities through custom MCP servers.',
              ),
              if (onInstall != null && onViewDocs != null) ...[
                const SizedBox(height: 32),
                _IntegrationsList(onInstall: onInstall, onViewDocs: onViewDocs),
              ],
            ],
          ),
        );

        final codeWidget = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RepaintBoundary(
                child: _GlowWrapper(
                  child: CodeDisplayBlock(
                    key: ValueKey('js-code-$isDarkMode'),
                    code: _codeExample,
                    language: 'javascript',
                    maxHeight: kIsWeb ? null : 600, // No maxHeight on web to avoid nested scrolling
                    theme: CodeDisplayTheme.auto,
                  ),
                ),
              ),
              if (onInstall != null && onViewDocs != null) ...[
                const SizedBox(height: 32),
                _CtaBannerSection(
                  onInstall: onInstall!,
                  onViewDocs: onViewDocs!,
                  onOpenSource: onOpenSource,
                  showInstructionsAndCli: true,
                ),
              ],
            ],
          ),
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [textWidget, const SizedBox(width: 48), codeWidget],
        );
      },
    );
  }
}

// Flow Diagram Widget
class _FlowDiagram extends StatelessWidget {
  const _FlowDiagram();

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
        boxShadow: kIsWeb
            ? [
                // Simplified shadow for web/Safari performance
                BoxShadow(
                  color: colors.accentColor.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: colors.accentColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: colors.accentColor.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: -2,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Workflow',
            style: textTheme.titleMedium?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          _buildFlowRow(colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildFlowRow(ThemeColorSet colors, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _FlowStep(label: 'Ticket', icon: Icons.assignment, colors: colors, textTheme: textTheme),
        _FlowArrow(colors: colors),
        _FlowStep(label: 'Figma', icon: Icons.design_services, colors: colors, textTheme: textTheme),
        _FlowArrow(colors: colors),
        _FlowStep(label: 'AI', icon: Icons.auto_awesome, colors: colors, textTheme: textTheme),
        _FlowArrow(colors: colors),
        _FlowStep(label: 'Cursor CLI', icon: Icons.code, colors: colors, textTheme: textTheme),
      ],
    );
  }
}

class _FlowStep extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeColorSet colors;
  final TextTheme textTheme;

  const _FlowStep({required this.label, required this.icon, required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: colors.accentColor.withValues(alpha: 0.3), width: 2),
          ),
          child: Icon(icon, color: colors.accentColor, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: colors.textColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _FlowArrow extends StatelessWidget {
  final ThemeColorSet colors;

  const _FlowArrow({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Icon(Icons.arrow_forward, color: colors.accentColor.withValues(alpha: 0.6), size: 24),
    );
  }
}

// Rivers Section
class _RiversSection extends StatefulWidget {
  final VoidCallback? onInstall;
  final VoidCallback? onViewDocs;
  final VoidCallback? onOpenSource;

  const _RiversSection({this.onInstall, this.onViewDocs, this.onOpenSource});

  @override
  State<_RiversSection> createState() => _RiversSectionState();
}

class _RiversSectionState extends State<_RiversSection> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Column(
      children: [
        const MediumDisplayText('Built for every enterprise SDLC', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        const LargeBodyText(
          'From rapid prototyping to legacy code navigation, DMTools adapts to your unique development needs with autonomous task execution.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 64),
        _CodeExampleItem(onInstall: widget.onInstall, onViewDocs: widget.onViewDocs, onOpenSource: widget.onOpenSource),
      ],
    );
  }
}

// CTA Banner Section
class _CtaBannerSection extends StatefulWidget {
  final VoidCallback onInstall;
  final VoidCallback onViewDocs;
  final VoidCallback? onOpenSource;
  final bool showInstructionsAndCli;

  const _CtaBannerSection({
    required this.onInstall,
    required this.onViewDocs,
    this.onOpenSource,
    this.showInstructionsAndCli = false,
  });

  @override
  State<_CtaBannerSection> createState() => _CtaBannerSectionState();
}

class _CtaBannerSectionState extends State<_CtaBannerSection> {
  String _cliInstallCommand = 'curl -fsSL https://github.com/IstiN/dmtools/releases/download/v1.7.91/install.sh | bash';

  @override
  void initState() {
    super.initState();
    if (widget.showInstructionsAndCli) {
      _loadCliInstallCommand();
    }
  }

  Future<void> _loadCliInstallCommand() async {
    try {
      final command = await ReleaseService.getCliInstallCommand();
      if (mounted) {
        setState(() {
          _cliInstallCommand = command;
        });
      }
    } catch (e) {
      // Keep default command if loading fails
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(64),
      decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
      child: Column(
        children: [
          Text(
            'Get started in seconds',
            style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: colors.textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Setup is a breeze. Install DMTools Desktop or CLI and run your first command.',
            style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (widget.showInstructionsAndCli) ...[
            // Instructions button and Install/OpenSource buttons in one row
            SelectionContainer.disabled(
              child: Row(
                children: [
                  IntrinsicWidth(
                    child: SecondaryButton(
                      text: 'Instructions',
                      testId: generateTestId('button', {
                        'action': 'view-installation-instructions',
                        'context': 'cta-banner',
                      }),
                      semanticLabel: generateSemanticLabel('button', 'View installation instructions'),
                      onPressed: () async {
                        final url = Uri.parse('https://github.com/IstiN/dmtools/releases/');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      size: ButtonSize.small,
                    ),
                  ),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    text: 'Install Desktop',
                    testId: generateTestId('button', {'action': 'install-desktop', 'context': 'cta-banner'}),
                    semanticLabel: generateSemanticLabel('button', 'Install DMTools Desktop now'),
                    onPressed: widget.onInstall,
                    size: ButtonSize.small,
                  ),
                  const SizedBox(width: 12),
                  if (widget.onOpenSource != null)
                    SecondaryButton(
                      text: 'OpenSource',
                      testId: generateTestId('button', {'action': 'view-opensource', 'context': 'cta-banner'}),
                      semanticLabel: generateSemanticLabel('button', 'View open source repository'),
                      onPressed: widget.onOpenSource!,
                      size: ButtonSize.small,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // CLI Install Code Block
            _SimpleCodeBlock(
              code: _cliInstallCommand,
              language: 'bash',
              showLanguageBadge: false,
              inlineCopyButton: true,
            ),
          ] else ...[
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                PrimaryButton(
                  text: 'Install now',
                  testId: generateTestId('button', {'action': 'install-now', 'context': 'cta-banner'}),
                  semanticLabel: generateSemanticLabel('button', 'Install DMTools now'),
                  onPressed: widget.onInstall,
                ),
                SecondaryButton(
                  text: 'View documentation',
                  testId: generateTestId('button', {'action': 'view-documentation', 'context': 'cta-banner'}),
                  semanticLabel: generateSemanticLabel('button', 'View documentation'),
                  onPressed: widget.onViewDocs,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Integrations List Widget (compact version for left column)
class _IntegrationsList extends StatelessWidget {
  final VoidCallback? onInstall;
  final VoidCallback? onViewDocs;

  const _IntegrationsList({this.onInstall, this.onViewDocs});

  static const List<_IntegrationCategory> _categories = [
    _IntegrationCategory(
      title: 'Project Management',
      integrations: [
        _Integration(name: 'Jira', toolCount: '40+', icon: Icons.bug_report),
        _Integration(name: 'Confluence', toolCount: '16', icon: Icons.article),
        _Integration(name: 'Rally', toolCount: '22', icon: Icons.track_changes),
        _Integration(name: 'Azure DevOps', toolCount: '24', icon: Icons.cloud_queue),
      ],
    ),
    _IntegrationCategory(
      title: 'Code Base',
      integrations: [
        _Integration(name: 'GitHub', toolCount: '20+', icon: Icons.code),
        _Integration(name: 'GitLab', toolCount: '20+', icon: Icons.merge),
        _Integration(name: 'Bitbucket', toolCount: '20+', icon: Icons.source),
      ],
    ),
    _IntegrationCategory(
      title: 'Design',
      integrations: [_Integration(name: 'Figma', toolCount: '6+', icon: Icons.design_services)],
    ),
    _IntegrationCategory(
      title: 'Collaboration & Communication',
      integrations: [
        _Integration(name: 'Microsoft Teams', toolCount: '20+', icon: Icons.groups),
        _Integration(name: 'Teams Auth', toolCount: '3', icon: Icons.lock),
        _Integration(name: 'SharePoint', toolCount: '2', icon: Icons.folder),
      ],
    ),
    _IntegrationCategory(
      title: 'AI Services',
      integrations: [
        _Integration(name: 'Gemini AI', toolCount: '', icon: Icons.auto_awesome),
        _Integration(name: 'Dial AI', toolCount: '', icon: Icons.chat_bubble),
        _Integration(name: 'Ollama AI', toolCount: '', icon: Icons.dns),
        _Integration(name: 'Anthropic AI', toolCount: '', icon: Icons.psychology),
        _Integration(name: 'OpenAI', toolCount: '', icon: Icons.smart_toy),
      ],
    ),
    _IntegrationCategory(
      title: 'Utilities',
      integrations: [
        _Integration(name: 'CLI', toolCount: '1', icon: Icons.terminal),
        _Integration(name: 'File', toolCount: '4', icon: Icons.insert_drive_file),
        _Integration(name: 'KB', toolCount: '5', icon: Icons.library_books),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MediumHeadlineText('Available Integrations'),
        const SizedBox(height: 24),
        ..._categories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _CompactCategorySection(category: category),
          ),
        ),
      ],
    );
  }
}

class _IntegrationCategory {
  final String title;
  final List<_Integration> integrations;

  const _IntegrationCategory({required this.title, required this.integrations});
}

class _Integration {
  final String name;
  final String toolCount;
  final IconData icon;

  const _Integration({required this.name, required this.toolCount, required this.icon});
}

class _CompactCategorySection extends StatelessWidget {
  final _IntegrationCategory category;

  const _CompactCategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final integration in category.integrations) _CompactIntegrationCard(integration: integration),
          ],
        ),
      ],
    );
  }
}

class _CompactIntegrationCard extends StatelessWidget {
  final _Integration integration;

  const _CompactIntegrationCard({required this.integration});

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(integration.icon, color: colors.accentColor, size: 18),
          const SizedBox(width: 8),
          Text(
            integration.name,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: colors.textColor),
          ),
          if (integration.toolCount.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text('(${integration.toolCount})', style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
          ],
        ],
      ),
    );
  }
}

// FAQ Section
class _FaqSection extends StatefulWidget {
  const _FaqSection();

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  List<Map<String, dynamic>> _faqGroups = [];

  @override
  void initState() {
    super.initState();
    _loadFaqData();
  }

  Future<void> _loadFaqData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/faq_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      if (mounted) {
        setState(() {
          _faqGroups = List<Map<String, dynamic>>.from(jsonData['faqGroups'] ?? []);
        });
      }
    } catch (e) {
      debugPrint('Error loading FAQ data: $e');
      // Fallback to empty list
      if (mounted) {
        setState(() {
          _faqGroups = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_faqGroups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const MediumDisplayText('Frequently asked questions', textAlign: TextAlign.center),
        const SizedBox(height: 48),
        ..._faqGroups.asMap().entries.map((entry) {
          final group = entry.value;
          final isLast = entry.key == _faqGroups.length - 1;
          return Column(
            children: [
              _FaqGroup(
                heading: group['heading'] as String,
                questions: (group['questions'] as List<dynamic>)
                    .map((q) => _FaqItem(question: q['question'] as String, answer: q['answer'] as String))
                    .toList(),
              ),
              if (!isLast) const SizedBox(height: 48),
            ],
          );
        }),
      ],
    );
  }
}

class _FaqGroup extends StatelessWidget {
  final String heading;
  final List<_FaqItem> questions;

  const _FaqGroup({required this.heading, required this.questions});

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.textColor),
        ),
        const SizedBox(height: 24),
        ...questions.map((item) => Padding(padding: const EdgeInsets.only(bottom: 16), child: item)),
      ],
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Use colorsListening to react to theme changes
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.textColor),
                    ),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: colors.textSecondary),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.answer,
                  style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary, height: 1.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Download Button styled like the example
class _DownloadButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ThemeColorSet colors;
  final TextTheme textTheme;

  const _DownloadButton({required this.onPressed, required this.colors, required this.textTheme});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // Light background color (almost white/light grey)
    final bgColor = widget.colors.cardBg.computeLuminance() > 0.5 ? widget.colors.cardBg : const Color(0xFFF5F5F5);

    // Dark text color
    final textColor = widget.colors.textColor.computeLuminance() < 0.5
        ? widget.colors.textColor
        : const Color(0xFF212529);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovering ? bgColor.withValues(alpha: 0.95) : bgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovering
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Download Desktop App',
                style: widget.textTheme.labelLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.download, color: textColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
