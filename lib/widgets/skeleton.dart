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
        ? modeTheme == 'dark'
            ? const DarkCardSkeleton()
            : modeTheme == 'light'
                ? const CardSkeleton()
                : brightness == Brightness.dark
                    ? const DarkCardSkeleton()
                    : const CardSkeleton()
        : modeTheme == 'dark'
            ? const DarkCardSkeleton()
            : modeTheme == 'light'
                ? const CardSkeleton()
                : brightness == Brightness.dark
                    ? const DarkCardSkeleton()
                    : const CardSkeleton();
  }

  postSkeletonInList(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (modeTheme == 'dark' || brightness == Brightness.dark)
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
        ? modeTheme == 'dark'
            ? const DarkEventSkeleton()
            : modeTheme == 'light'
                ? const EventSkeleton()
                : brightness == Brightness.dark
                    ? const DarkEventSkeleton()
                    : const EventSkeleton()
        : modeTheme == 'dark'
            ? const DarkEventSkeleton()
            : modeTheme == 'light'
                ? const EventSkeleton()
                : brightness == Brightness.dark
                    ? const DarkEventSkeleton()
                    : const EventSkeleton();
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
        ? modeTheme == 'dark'
            ? const DarkGrowSkeleton()
            : modeTheme == 'light'
                ? const GrowSkeleton()
                : brightness == Brightness.dark
                    ? const DarkGrowSkeleton()
                    : const GrowSkeleton()
        : modeTheme == 'dark'
            ? const DarkGrowSkeleton()
            : modeTheme == 'light'
                ? const GrowSkeleton()
                : brightness == Brightness.dark
                    ? const DarkGrowSkeleton()
                    : const GrowSkeleton();
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
        ? modeTheme == 'dark'
            ? const DarkUserInformationSkeleton()
            : modeTheme == 'light'
                ? const UserInformationSkeleton()
                : brightness == Brightness.dark
                    ? const DarkUserInformationSkeleton()
                    : const UserInformationSkeleton()
        : modeTheme == 'dark'
            ? const DarkUserInformationSkeleton()
            : modeTheme == 'light'
                ? const UserInformationSkeleton()
                : brightness == Brightness.dark
                    ? const DarkUserInformationSkeleton()
                    : const UserInformationSkeleton();
  }

  listFriendSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (brightness == Brightness.dark)
        ? modeTheme == 'dark'
            ? const DarkUserFriendSkeleton()
            : modeTheme == 'light'
                ? const UserFriendSkeleton()
                : brightness == Brightness.dark
                    ? const DarkUserFriendSkeleton()
                    : const UserFriendSkeleton()
        : modeTheme == 'dark'
            ? const DarkUserFriendSkeleton()
            : modeTheme == 'light'
                ? const UserFriendSkeleton()
                : brightness == Brightness.dark
                    ? const DarkUserFriendSkeleton()
                    : const UserFriendSkeleton();
  }

  groupSkeleton(context) {
    final theme = Provider.of<ThemeManager>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';

    return (brightness == Brightness.dark)
        ? modeTheme == 'dark'
            ? const DarkGroupSkeleton()
            : modeTheme == 'light'
                ? const GroupSkeleton()
                : brightness == Brightness.dark
                    ? const DarkGroupSkeleton()
                    : const GroupSkeleton()
        : modeTheme == 'dark'
            ? const DarkGroupSkeleton()
            : modeTheme == 'light'
                ? const GroupSkeleton()
                : brightness == Brightness.dark
                    ? const DarkGroupSkeleton()
                    : const GroupSkeleton();
  }
}
