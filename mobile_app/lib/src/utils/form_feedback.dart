import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class FormFeedback {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String? requiredField(
    BuildContext context, {
    required String value,
    required String fieldName,
  }) {
    if (value.trim().isNotEmpty) return null;
    return AppLocalizations.of(context)!.validationRequired(fieldName);
  }

  static double? parseNumber(String raw) {
    return double.tryParse(raw.trim().replaceAll(',', '.'));
  }
}
