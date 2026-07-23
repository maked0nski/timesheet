import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters({
    required this.locale,
    required this.currencyCode,
  }) {
    Intl.defaultLocale = locale.toLanguageTag();
    _currency = NumberFormat.simpleCurrency(locale: locale.toLanguageTag(), name: currencyCode);
  }

  final Locale locale;
  final String currencyCode;
  late final NumberFormat _currency;

  String money(num amount) => _currency.format(amount);

  String date(DateTime value, String pattern) {
    return DateFormat(pattern, locale.toLanguageTag()).format(value);
  }

  static Locale localeFromSettings(Map<String, String> settings) {
    final raw = settings['app_locale'];
    if (raw == null || raw.isEmpty) return const Locale('uk', 'UA');
    final parts = raw.split('_');
    if (parts.length == 2) return Locale(parts[0], parts[1]);
    return Locale(raw);
  }

  static String currencyFromSettings(Map<String, String> settings) {
    final raw = settings['app_currency'];
    if (raw == null || raw.isEmpty) return 'GBP';
    return raw;
  }
}
