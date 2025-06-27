/// Core Agent model for simplified agent representation
/// Used in widgets that need basic agent information
class CoreAgent {
  final String title;
  final bool isActive;
  final String description;
  final List<String> tags;
  final int runCount;
  final String lastRun;
  final String icon;

  const CoreAgent({
    required this.title,
    required this.isActive,
    required this.description,
    required this.tags,
    required this.runCount,
    required this.lastRun,
    required this.icon,
  });
}
