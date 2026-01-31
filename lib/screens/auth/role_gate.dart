import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../providers/app_state.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/ai_insight_card.dart';

class RoleGateScreen extends StatelessWidget {
  const RoleGateScreen({super.key});

  void _goToRole(BuildContext context, Role role) {
    final state = AppStateScope.of(context);
    state.setRole(role);
    final route = switch (role) {
      Role.customer => AppRoutes.customer,
      Role.driver => AppRoutes.driver,
      Role.staff => AppRoutes.staff,
      Role.admin => AppRoutes.admin,
      Role.scanner => AppRoutes.scanner,
    };
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'NAVSWAP',
      subtitle: 'Engineering the pulse of urban energy',
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const AiInsightCard(
            title: 'System overview',
            summary:
                'One app. Five modes. AI-driven operations. Tap a role to enter.',
          ),
          const SizedBox(height: AppSpacing.lg),
          ...Role.values.map(
            (role) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GestureDetector(
                onTap: () => _goToRole(context, role),
                child: AiInsightCard(
                  title: role.label,
                  summary: role.tagline,
                  status: role.prefersDarkMode ? 'warning' : 'healthy',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
