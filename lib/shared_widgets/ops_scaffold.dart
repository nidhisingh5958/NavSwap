import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_icons.dart';
import '../core/constants/app_spacing.dart';
import '../providers/theme_provider.dart';

class OpsScaffold extends ConsumerWidget {
  const OpsScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.actions,
    this.leading,
    this.alertBanner,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? alertBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.displayMedium),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!.toUpperCase(),
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(themeProvider.notifier).toggleTheme(),
                    icon: Icon(
                      themeState.isDark
                          ? AppIcons.lightMode
                          : AppIcons.darkMode,
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
            const Divider(),

            // Alert banner
            if (alertBanner != null) alertBanner!,

            // Body
            Expanded(child: body),
          ],
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
