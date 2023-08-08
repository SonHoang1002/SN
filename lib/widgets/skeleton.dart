import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/skeleton_widget.dart';

class SkeletonCustom {
  postSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return modeTheme == 'dark'
        ? const DarkCardSkeleton()
        : const CardSkeleton();
  }

  postSkeletonInList(context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return modeTheme == 'dark'
        ? const DarkCardSkeletonInList(
            isBottomLinesActive: false,
          )
        : const CardSkeletonInList(
            isBottomLinesActive: false,
          );
  }

  postSkeletonDiscovery(context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return modeTheme == 'dark'
        ? const DarkCardSkeleton(
            isBottomLinesActive: false,
            isPaddingActive: false,
          )
        : const CardSkeleton(
            isBottomLinesActive: false,
            isPaddingActive: false,
          );
  }
  
  eventSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return modeTheme == 'dark'
        ? const DarkEventSkeleton()
        : const EventSkeleton();
  }

  growSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return modeTheme == 'dark'
        ? const DarkGrowSkeleton()
        : const GrowSkeleton();
  }
}
