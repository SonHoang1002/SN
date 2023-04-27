import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/skeleton_widget.dart';

class SkeletonCustom {
  postSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return modeTheme == 'dark' ? const DarkCardSkeleton() : const CardSkeleton();
  }
}
