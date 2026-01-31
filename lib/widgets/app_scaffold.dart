import 'package:flutter/material.dart';
import '../core/constants/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/app_state.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    this.showThemeToggle = true,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;
  final bool showThemeToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: textTheme.displayLarge),
                        const SizedBox(height: 12),
                        Text(
                          subtitle.toUpperCase(),
                          style: AppTextStyles.title(
                            textTheme.bodySmall?.color ?? Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                  if (showThemeToggle)
                    IconButton(
                      tooltip: 'Toggle theme',
                      icon: Icon(
                        AppStateScope.of(context).isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      onPressed: () => AppStateScope.of(context).toggleTheme(),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
