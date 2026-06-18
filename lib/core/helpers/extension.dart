import 'package:flutter/material.dart';
import 'package:routina/core/theaming/app_theme/logic/cubit/theme_cubit.dart';
import 'package:routina/core/widgets/preferences_bottom_sheet.dart';
import 'package:routina/features/locale/logic/locale_cubit.dart';
import 'package:routina/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    RoutePredicate? predicate,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (_) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> push(Widget page) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  void pop([Object? result]) => Navigator.of(this).pop(result);
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}

extension ListExtension<T> on List<T>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension MapExtension<K, V> on Map<K, V>? {
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension PreferencesSheetX on BuildContext {
  Future<void> showPreferencesSheet({
    required ThemeCubit themeCubit,
    required LocaleCubit localeCubit,
  }) {
    return showModalBottomSheet(
      context: this,
      backgroundColor: Colors.transparent,
      builder: (_) => PreferencesBottomSheet(
        themeCubit: themeCubit,
        localeCubit: localeCubit,
      ),
    );
  }
}

Future<void> openTermsOfService() async {
  final uri = Uri.parse('https://idyllic-frangollo-bcbcc8.netlify.app');
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch Terms of Service URL');
  }
}

Future<void> openPrivacyPolicy() async {
  final uri = Uri.parse('https://mellow-lokum-05a071.netlify.app');
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch Privacy Policy URL');
  }
}