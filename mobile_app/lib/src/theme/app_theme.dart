import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface1,
    required this.surface2,
    required this.surface3,
    required this.surface4,
    required this.card,
    required this.border,
    required this.mutedText,
  });

  final Color bg;
  final Color surface1;
  final Color surface2;
  final Color surface3;
  final Color surface4;
  final Color card;
  final Color border;
  final Color mutedText;

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface1,
    Color? surface2,
    Color? surface3,
    Color? surface4,
    Color? card,
    Color? border,
    Color? mutedText,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface1: surface1 ?? this.surface1,
      surface2: surface2 ?? this.surface2,
      surface3: surface3 ?? this.surface3,
      surface4: surface4 ?? this.surface4,
      card: card ?? this.card,
      border: border ?? this.border,
      mutedText: mutedText ?? this.mutedText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface1: Color.lerp(surface1, other.surface1, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surface3: Color.lerp(surface3, other.surface3, t)!,
      surface4: Color.lerp(surface4, other.surface4, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
    );
  }
}

class AppTheme {
  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: primary),
      titleMedium: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: primary),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: primary),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primary),
      bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: primary),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: secondary),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: primary),
    );
  }

  static ThemeData dark() {
    const colors = AppColors(
      bg: Color(0xFF090E1A),
      surface1: Color(0xFF141820),
      surface2: Color(0xFF1A2030),
      surface3: Color(0xFF1D1F24),
      surface4: Color(0xFF0F1420),
      card: Color(0xFF1B1F2A),
      border: Color(0xFF253047),
      mutedText: Color(0xFFB0B8C7),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.surface1,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0A7D7D),
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface1,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      textTheme: _textTheme(Colors.white, colors.mutedText),
      listTileTheme: ListTileThemeData(
        tileColor: colors.surface1,
        minVerticalPadding: 8,
        titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        subtitleTextStyle: TextStyle(fontSize: 13, color: colors.mutedText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        hintStyle: TextStyle(color: colors.mutedText, fontWeight: FontWeight.w600),
      ),
      cardColor: colors.card,
      dividerColor: colors.border,
      extensions: const [colors],
    );
  }

  static ThemeData light() {
    const colors = AppColors(
      bg: Color(0xFFF2F4F7),
      surface1: Color(0xFFFFFFFF),
      surface2: Color(0xFFE7EBF0),
      surface3: Color(0xFFFFFFFF),
      surface4: Color(0xFFF7F8FA),
      card: Color(0xFFFFFFFF),
      border: Color(0xFFD4DAE2),
      mutedText: Color(0xFF667085),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.surface1,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0A7D7D),
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface1,
        foregroundColor: const Color(0xFF101828),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF101828),
        ),
      ),
      textTheme: _textTheme(const Color(0xFF101828), colors.mutedText),
      listTileTheme: ListTileThemeData(
        tileColor: colors.surface1,
        minVerticalPadding: 8,
        titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF101828)),
        subtitleTextStyle: TextStyle(fontSize: 13, color: colors.mutedText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        hintStyle: TextStyle(color: colors.mutedText, fontWeight: FontWeight.w600),
      ),
      cardColor: colors.card,
      dividerColor: colors.border,
      extensions: const [colors],
    );
  }
}
