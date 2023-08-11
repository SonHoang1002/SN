import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/skeleton_widget.dart';

class SkeletonCustom {
  postSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (brightness == Brightness.dark)
        ? modeTheme == 'dark'?const DarkCardSkeleton(): modeTheme == 'light'?const CardSkeleton():brightness == Brightness.dark?const DarkCardSkeleton(): const CardSkeleton()
        : modeTheme == 'dark'?const DarkCardSkeleton(): modeTheme == 'light'?const CardSkeleton():brightness == Brightness.dark?const DarkCardSkeleton(): const CardSkeleton();
  }
  
  

  postSkeletonInList(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return(modeTheme == 'dark' || brightness == Brightness.dark)
        ? const DarkCardSkeletonInList(
            isBottomLinesActive: false,
          )
        : const CardSkeletonInList(
            isBottomLinesActive: false,
          );
  }

  postSkeletonDiscovery(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (modeTheme == 'dark' || brightness == Brightness.dark)
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
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (brightness == Brightness.dark)
        ? modeTheme == 'dark'?const DarkEventSkeleton(): modeTheme == 'light'?const EventSkeleton():brightness == Brightness.dark?const DarkEventSkeleton(): const EventSkeleton()
        : modeTheme == 'dark'?const DarkEventSkeleton(): modeTheme == 'light'?const EventSkeleton():brightness == Brightness.dark?const DarkEventSkeleton(): const EventSkeleton();
  }
  

  growSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (brightness == Brightness.dark)
        ? modeTheme == 'dark'?const DarkGrowSkeleton(): modeTheme == 'light'?const GrowSkeleton():brightness == Brightness.dark?const DarkGrowSkeleton(): const GrowSkeleton()
        : modeTheme == 'dark'?const DarkGrowSkeleton(): modeTheme == 'light'?const GrowSkeleton():brightness == Brightness.dark?const DarkGrowSkeleton(): const GrowSkeleton();
  }

   introduceSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (brightness == Brightness.dark)
        ? modeTheme == 'dark'?const DarkCardPageSkeleton(): modeTheme == 'light'?const CardPageSkeleton():brightness == Brightness.dark?const DarkCardPageSkeleton(): const CardPageSkeleton()
        : modeTheme == 'dark'?const DarkCardPageSkeleton(): modeTheme == 'light'?const CardPageSkeleton():brightness == Brightness.dark?const DarkCardPageSkeleton(): const CardPageSkeleton();
  }
}
