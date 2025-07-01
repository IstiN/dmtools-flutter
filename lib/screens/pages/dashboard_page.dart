import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../widgets/workspace_summary.dart';
import '../../widgets/recent_agents.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleResponsiveBuilder(
      mobile: (context, constraints) => const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            WorkspaceSummary(),
            SizedBox(height: 24),
            RecentAgents(),
          ],
        ),
      ),
      desktop: (context, constraints) => const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: WorkspaceSummary(),
            ),
            SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: RecentAgents(),
            ),
          ],
        ),
      ),
    );
  }
}
