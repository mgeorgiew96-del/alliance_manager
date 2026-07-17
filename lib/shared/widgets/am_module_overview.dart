import 'package:flutter/material.dart';

import '../theme/am_spacing.dart';
import '../theme/am_text_styles.dart';
import 'am_asset_image.dart';
import 'am_page.dart';

class AMModuleOverview extends StatelessWidget {
  const AMModuleOverview({
    super.key,
    required this.title,
    required this.bannerPath,
    required this.bannerTagline,
    required this.description,
    required this.onBack,
    required this.progressContent,
    required this.content,
    this.fallbackIcon = Icons.castle_outlined,
    this.unsavedChangesContent,
    this.bannerAlignment = Alignment.center,
  });

  final String title;
  final String bannerPath;
  final String bannerTagline;
  final String description;

  final VoidCallback onBack;

  /// The module-specific overall progress card.
  final Widget progressContent;

  /// The module-specific content below progress.
  final Widget content;

  /// Optional Save/Cancel area or unsaved-changes banner.
  final Widget? unsavedChangesContent;

  final IconData fallbackIcon;
  final Alignment bannerAlignment;

  @override
  Widget build(BuildContext context) {
    return AMPage(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ModuleBackHeader(title: title, onBack: onBack),
            const SizedBox(height: AMSpacing.md),
            _ModuleBanner(
              path: bannerPath,
              tagline: bannerTagline,
              fallbackIcon: fallbackIcon,
              alignment: bannerAlignment,
            ),
            const SizedBox(height: AMSpacing.lg),
            Text(description, style: AMTextStyles.body),
            const SizedBox(height: AMSpacing.lg),
            progressContent,
            if (unsavedChangesContent != null) ...[
              const SizedBox(height: AMSpacing.md),
              unsavedChangesContent!,
            ],
            const SizedBox(height: AMSpacing.lg),
            content,
            const SizedBox(height: AMSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _ModuleBackHeader extends StatelessWidget {
  const _ModuleBackHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: 'Back to My Castle',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: AMSpacing.sm),
        Expanded(child: Text(title.toUpperCase(), style: AMTextStyles.title)),
      ],
    );
  }
}

class _ModuleBanner extends StatelessWidget {
  const _ModuleBanner({
    required this.path,
    required this.tagline,
    required this.fallbackIcon,
    required this.alignment,
  });

  final String path;
  final String tagline;
  final IconData fallbackIcon;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 6,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AMAssetImage(
              path: path,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              alignment: alignment,
              fallbackIcon: fallbackIcon,
              fallbackIconSize: 72,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.05),
                    Color.fromRGBO(0, 0, 0, 0.38),
                    Color.fromRGBO(0, 0, 0, 0.88),
                  ],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
            Positioned(
              left: AMSpacing.lg,
              right: AMSpacing.lg,
              bottom: AMSpacing.lg,
              child: Text(tagline, style: AMTextStyles.body),
            ),
          ],
        ),
      ),
    );
  }
}
