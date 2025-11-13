import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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

  @override
  void dispose() {
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

  Future<void> _openMcpRegistry() async {
    // Placeholder - update with actual MCP registry URL when available
    final url = Uri.parse('https://github.com/IstiN/dmtools-flutter');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWhatsNew() async {
    final url = Uri.parse('https://github.com/IstiN/dmtools-flutter/releases');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the total width - use screen width on mobile, fixed width on desktop
    final totalWidth = screenWidth < 1200 ? screenWidth - 48.0 : 1200.0;

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
                    return const Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(16),
                      elevation: 0,
                      child: AuthLoginWidget(),
                    );
                  },
                );
              },
            ),
          ),

          // Main Content
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SelectionArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 64),

                            // Hero Section
                            SizedBox(
                              width: totalWidth,
                              child: _HeroSection(onInstall: _openReleasesPage, onOpenSource: _openOpenSource),
                            ),

                            const SizedBox(height: 128),

                            // Pillars Section
                            SizedBox(width: totalWidth, child: const _PillarsSection()),

                            const SizedBox(height: 128),

                            // Rivers Section
                            SizedBox(width: totalWidth, child: const _RiversSection()),

                            const SizedBox(height: 128),

                            // CTA Banner Section
                            SizedBox(
                              width: totalWidth,
                              child: _CtaBannerSection(onInstall: _openReleasesPage, onViewDocs: _openDocumentation),
                            ),

                            const SizedBox(height: 128),

                            // Resources Section
                            SizedBox(
                              width: totalWidth,
                              child: _ResourcesSection(
                                onDocs: _openDocumentation,
                                onMcpRegistry: _openMcpRegistry,
                                onWhatsNew: _openWhatsNew,
                              ),
                            ),

                            const SizedBox(height: 128),

                            // FAQ Section
                            SizedBox(width: totalWidth, child: const _FaqSection()),

                            const SizedBox(height: 96),
                          ],
                        ),
                      ),
                    ),
                  ),
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
    final colors = context.colors;
    final isDarkMode = context.isDarkMode;

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
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to placeholder if image fails to load
              return const _ScreenshotPlaceholder();
            },
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
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = context.isDarkMode;

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

  const _HeroSection({required this.onInstall, required this.onOpenSource});

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
    final colors = context.colors;
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
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5, // 50% of screen width (50% smaller than full width)
        ),
        child: SelectionContainer.disabled(
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
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context, ThemeColorSet colors, TextTheme textTheme) {
    final baseFontSize = (textTheme.displayLarge?.fontSize ?? 57) * 1.2;
    final blueFontSize = baseFontSize * 1.4; // 40% bigger for blue blocks

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Text.rich(
        TextSpan(
          style: textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w300, // Lighter weight
            color: colors.textColor,
            height: 1.2,
            fontFamily: 'Inter',
            fontSize: baseFontSize,
          ),
          children: [
            const TextSpan(text: 'Is it easier to train '),
            TextSpan(
              text: 'thousands employees',
              style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w400, fontSize: blueFontSize),
            ),
            const TextSpan(text: '\n'),
            const TextSpan(text: 'to write perfect prompts,\n'),
            const TextSpan(text: 'or '),
            TextSpan(
              text: 'to',
              style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w400, fontSize: blueFontSize),
            ),
            const TextSpan(text: ' build a '),
            TextSpan(
              text: 'system of expert agents',
              style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w400, fontSize: blueFontSize),
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
    final blueFontSize = baseFontSize * 1.4; // 40% bigger for blue blocks

    return Text.rich(
      TextSpan(
        style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary, height: 1.6, fontSize: baseFontSize),
        children: [
          const TextSpan(
            text:
                'DMTools provides a comprehensive AI agent orchestration platform that connects all your project tools through a unified ',
          ),
          TextSpan(
            text: 'CLI',
            style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w600, fontSize: blueFontSize),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Desktop',
            style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w600, fontSize: blueFontSize),
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
            child: Semantics(
              label: generateSemanticLabel('button', 'View installation instructions'),
              button: true,
              child: IntrinsicWidth(
                child: SecondaryButton(
                  text: 'Instructions',
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
              Semantics(
                label: generateSemanticLabel('button', 'Install DMTools now'),
                button: true,
                child: PrimaryButton(text: 'Install now', onPressed: widget.onInstall, size: ButtonSize.small),
              ),
              const SizedBox(width: 12),
              Semantics(
                label: generateSemanticLabel('button', 'View open source repository'),
                button: true,
                child: SecondaryButton(text: 'OpenSource', onPressed: widget.onOpenSource, size: ButtonSize.small),
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
class _PillarsSection extends StatelessWidget {
  const _PillarsSection();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context, constraints) => _buildMobileLayout(context),
      desktop: (context, constraints) => _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return const Column(
      children: [
        _PillarCard(
          icon: Icons.rocket_launch,
          heading: 'Less setup, more shipping',
          description:
              'Included with Desktop, CLI, and Server deployments—keeping setup simple and costs predictable so you can focus on shipping.',
        ),
        SizedBox(height: 24),
        _PillarCard(
          icon: Icons.psychology,
          heading: 'Agent-powered, tool-native',
          description:
              'Execute coding tasks with agents that know your repositories, issues, and pull requests—all natively integrated with your tools.',
        ),
        SizedBox(height: 24),
        _PillarCard(
          icon: Icons.code,
          heading: 'Open source, full control',
          description:
              'Open source platform with explicit approvals—so you stay in control with full transparency and customization.',
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _PillarCard(
            icon: Icons.rocket_launch,
            heading: 'Less setup, more shipping',
            description:
                'Included with Desktop, CLI, and Server deployments—keeping setup simple and costs predictable so you can focus on shipping.',
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: _PillarCard(
            icon: Icons.psychology,
            heading: 'Agent-powered, tool-native',
            description:
                'Execute coding tasks with agents that know your repositories, issues, and pull requests—all natively integrated with your tools.',
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: _PillarCard(
            icon: Icons.code,
            heading: 'Open source, full control',
            description:
                'Open source platform with explicit approvals—so you stay in control with full transparency and customization.',
          ),
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String description;

  const _PillarCard({required this.icon, required this.heading, required this.description});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: colors.accentColor),
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

// Rivers Section
class _RiversSection extends StatelessWidget {
  const _RiversSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MediumDisplayText('Built for every development workflow', textAlign: TextAlign.center),
        SizedBox(height: 16),
        LargeBodyText(
          'From rapid prototyping to legacy code navigation, DMTools adapts to your unique development needs with autonomous task execution.',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 64),
        _RiverItem(
          heading: 'Get started in any codebase instantly',
          text:
              'Ask DMTools to explore the project structure, install dependencies, and explain how everything works—all through simple conversation.',
          imageOnLeft: false,
          imagePath: 'assets/img/dmtools-cli.png',
        ),
        SizedBox(height: 96),
        _RiverItem(
          heading: 'Leverage MCP context and extend with your own tools',
          text:
              'Bring context from your issues and pull requests directly to your environment, eliminating context switching. Plus, extend DMTools capabilities through custom MCP servers.',
          imageOnLeft: true,
          imagePath: 'assets/img/dm-ai-app.png',
        ),
        SizedBox(height: 96),
        _RiverItem(
          heading: 'Build, edit, debug, and refactor code locally',
          text:
              'DMTools edits files, runs commands, and helps you iterate fast without ever leaving your local environment.',
          imageOnLeft: false,
          imagePath: 'assets/img/dm-ai-app.png',
        ),
      ],
    );
  }
}

class _RiverItem extends StatelessWidget {
  final String heading;
  final String text;
  final bool imageOnLeft;
  final String? imagePath;

  const _RiverItem({required this.heading, required this.text, required this.imageOnLeft, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [MediumHeadlineText(heading), const SizedBox(height: 16), LargeBodyText(text)],
          ),
          const SizedBox(height: 24),
          imagePath != null ? _ScreenshotImage(imagePath: imagePath!) : const _ScreenshotPlaceholder(),
        ],
      ),
      desktop: (context, constraints) {
        final textWidget = Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [MediumHeadlineText(heading), const SizedBox(height: 16), LargeBodyText(text)],
          ),
        );

        final imageWidget = Expanded(
          child: imagePath != null ? _ScreenshotImage(imagePath: imagePath!) : const _ScreenshotPlaceholder(),
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: imageOnLeft
              ? [imageWidget, const SizedBox(width: 48), textWidget]
              : [textWidget, const SizedBox(width: 48), imageWidget],
        );
      },
    );
  }
}

// CTA Banner Section
class _CtaBannerSection extends StatelessWidget {
  final VoidCallback onInstall;
  final VoidCallback onViewDocs;

  const _CtaBannerSection({required this.onInstall, required this.onViewDocs});

  @override
  Widget build(BuildContext context) {
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
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              Semantics(
                label: generateSemanticLabel('button', 'Install DMTools now'),
                button: true,
                child: PrimaryButton(text: 'Install now', onPressed: onInstall),
              ),
              Semantics(
                label: generateSemanticLabel('button', 'View documentation'),
                button: true,
                child: SecondaryButton(text: 'View documentation', onPressed: onViewDocs),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Resources Section
class _ResourcesSection extends StatelessWidget {
  final VoidCallback onDocs;
  final VoidCallback onMcpRegistry;
  final VoidCallback onWhatsNew;

  const _ResourcesSection({required this.onDocs, required this.onMcpRegistry, required this.onWhatsNew});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MediumDisplayText('Resources on DMTools', textAlign: TextAlign.center),
        const SizedBox(height: 48),
        ResponsiveBuilder(
          mobile: (context, constraints) => Column(
            children: [
              _ResourceCard(
                icon: Icons.book,
                heading: 'DMTools Documentation',
                description: 'Learn how to set up and use DMTools for your agentic workflows.',
                ctaText: 'Read the docs',
                onPressed: onDocs,
              ),
              const SizedBox(height: 24),
              _ResourceCard(
                icon: Icons.extension,
                heading: 'MCP Registry',
                description: 'Discover an ecosystem of partner and community-driven MCP servers to connect to DMTools.',
                ctaText: 'Discover the MCP Registry',
                onPressed: onMcpRegistry,
              ),
              const SizedBox(height: 24),
              _ResourceCard(
                icon: Icons.new_releases,
                heading: 'What\'s New',
                description:
                    'Discover AI-powered updates designed to supercharge your productivity and streamline your workflow.',
                ctaText: 'See what\'s new',
                onPressed: onWhatsNew,
              ),
            ],
          ),
          desktop: (context, constraints) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ResourceCard(
                  icon: Icons.book,
                  heading: 'DMTools Documentation',
                  description: 'Learn how to set up and use DMTools for your agentic workflows.',
                  ctaText: 'Read the docs',
                  onPressed: onDocs,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _ResourceCard(
                  icon: Icons.extension,
                  heading: 'MCP Registry',
                  description:
                      'Discover an ecosystem of partner and community-driven MCP servers to connect to DMTools.',
                  ctaText: 'Discover the MCP Registry',
                  onPressed: onMcpRegistry,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _ResourceCard(
                  icon: Icons.new_releases,
                  heading: 'What\'s New',
                  description:
                      'Discover AI-powered updates designed to supercharge your productivity and streamline your workflow.',
                  ctaText: 'See what\'s new',
                  onPressed: onWhatsNew,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final IconData icon;
  final String heading;
  final String description;
  final String ctaText;
  final VoidCallback onPressed;

  const _ResourceCard({
    required this.icon,
    required this.heading,
    required this.description,
    required this.ctaText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colors.accentColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            heading,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 8),
          Text(description, style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary, height: 1.5)),
          const SizedBox(height: 16),
          Semantics(
            label: generateSemanticLabel('button', ctaText),
            button: true,
            child: AppTextButton(text: '$ctaText →', onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}

// FAQ Section
class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        MediumDisplayText('Frequently asked questions', textAlign: TextAlign.center),
        SizedBox(height: 48),
        _FaqGroup(
          heading: 'Getting Started, Installation & Access',
          questions: [
            _FaqItem(
              question: 'Who can access DMTools?',
              answer:
                  'DMTools is open source and available to all developers. No subscription or API keys required. Simply install Desktop, CLI, or Server version and start using it.',
            ),
            _FaqItem(
              question: 'How much does it cost to use DMTools?',
              answer:
                  'DMTools is completely free and open source. There are no costs, subscriptions, or usage limits. You can use it for personal projects, commercial applications, or enterprise deployments.',
            ),
            _FaqItem(
              question: 'How do I install and set up DMTools?',
              answer:
                  'Install Desktop app from releases page, or use CLI version with: curl -fsSL https://github.com/IstiN/dmtools/releases/download/v1.7.82/install.sh | bash. For server deployment, download the Java server bundle.',
            ),
            _FaqItem(
              question: 'What operating systems are supported?',
              answer:
                  'Desktop: Android, iOS, Windows, Web, macOS. CLI: macOS, Linux, Windows (via WSL). Server: Any platform with Java runtime.',
            ),
          ],
        ),
        SizedBox(height: 48),
        _FaqGroup(
          heading: 'Capabilities & Functionality',
          questions: [
            _FaqItem(
              question: 'Can I use DMTools with any code editor?',
              answer:
                  'Yes. DMTools operates independently and can modify files that any editor can display. It works with VS Code, IntelliJ, Vim, or any other editor of your choice.',
            ),
            _FaqItem(
              question: 'Can I extend DMTools with custom tools?',
              answer:
                  'Yes. DMTools supports Model Context Protocol (MCP) server integrations, allowing you to add custom capabilities and contextual richness tailored to your unique development environment.',
            ),
            _FaqItem(
              question: 'What types of development tasks work best with DMTools?',
              answer:
                  'DMTools excels at legacy codebase navigation, cross-platform development setup, multi-step implementations, project management integration, and any scenario requiring autonomous task execution with terminal-native workflows.',
            ),
            _FaqItem(
              question: 'Does DMTools support multiple AI providers?',
              answer:
                  'Yes. DMTools supports Ollama, Anthropic, OpenAI, Dial, Gemini, and custom JavaScript models. You can configure different providers for different agents.',
            ),
            _FaqItem(
              question: 'How does MCP integration work?',
              answer:
                  'DMTools provides a unified MCP wrapper that allows you to access all MCP connectors through a single URL. This simplifies integrations and reduces complexity in your workflows.',
            ),
          ],
        ),
        SizedBox(height: 48),
        _FaqGroup(
          heading: 'Security & Governance',
          questions: [
            _FaqItem(
              question: 'How does DMTools handle security and compliance?',
              answer:
                  'DMTools is open source, giving you full visibility into the codebase. All file changes and command executions require explicit approval. You maintain complete control over all autonomous actions.',
            ),
            _FaqItem(
              question: 'How does file modification and command execution work?',
              answer:
                  'Every file change and command execution requires your explicit approval before being applied. You maintain complete visibility and control over all autonomous actions through the approval workflow.',
            ),
            _FaqItem(
              question: 'Can I run DMTools in a headless CI/CD environment?',
              answer:
                  'Yes. DMTools is designed for headless environments and is perfect for GitHub Actions, GitLab runners, Bitbucket pipelines, and Jenkins jobs. The CLI and Server versions are ideal for automation.',
            ),
          ],
        ),
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
