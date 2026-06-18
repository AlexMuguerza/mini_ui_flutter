import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:mini_ui_flutter/miniui.dart';

/// Ejemplo de paleta Slate (basada en Tailwind CSS slate).
///
/// Demuestra cómo crear paletas personalizadas usando [MinColors].
class SlatePalette {
  SlatePalette._();

  static const light = MinColors(
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF020817),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF020817),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF020817),
    primary: Color(0xFF020817),
    primaryForeground: Color(0xFFF8FAFC),
    secondary: Color(0xFFF1F5F9),
    secondaryForeground: Color(0xFF020817),
    muted: Color(0xFFF1F5F9),
    mutedForeground: Color(0xFF64748B),
    accent: Color(0xFFF1F5F9),
    accentForeground: Color(0xFF020817),
    destructive: Color(0xFFEF4444),
    destructiveForeground: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0),
    input: Color(0xFFE2E8F0),
    ring: Color(0xFF020817),
  );

  static const dark = MinColors(
    background: Color(0xFF020817),
    foreground: Color(0xFFF8FAFC),
    card: Color(0xFF020817),
    cardForeground: Color(0xFFF8FAFC),
    popover: Color(0xFF020817),
    popoverForeground: Color(0xFFF8FAFC),
    primary: Color(0xFFF8FAFC),
    primaryForeground: Color(0xFF020817),
    secondary: Color(0xFF1E293B),
    secondaryForeground: Color(0xFFF8FAFC),
    muted: Color(0xFF1E293B),
    mutedForeground: Color(0xFF94A3B8),
    accent: Color(0xFF1E293B),
    accentForeground: Color(0xFFF8FAFC),
    destructive: Color(0xFFDC2626),
    destructiveForeground: Color(0xFFF8FAFC),
    border: Color(0xFF1E293B),
    input: Color(0xFF1E293B),
    ring: Color(0xFFCBD5E1),
  );
}

/// Ejemplo de paleta Violeta (púrpura).
///
/// Demuestra una paleta completamente personalizada con acentos violeta.
class VioletPalette {
  VioletPalette._();

  static const light = MinColors(
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF1E1B4B),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF1E1B4B),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF1E1B4B),
    primary: Color(0xFF6D28D9),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFF5F3FF),
    secondaryForeground: Color(0xFF1E1B4B),
    muted: Color(0xFFF5F3FF),
    mutedForeground: Color(0xFF6B7280),
    accent: Color(0xFFF5F3FF),
    accentForeground: Color(0xFF1E1B4B),
    destructive: Color(0xFFEF4444),
    destructiveForeground: Color(0xFFFFFFFF),
    border: Color(0xFFE5E7EB),
    input: Color(0xFFE5E7EB),
    ring: Color(0xFF6D28D9),
  );

  static const dark = MinColors(
    background: Color(0xFF0F0A1A),
    foreground: Color(0xFFF8FAFC),
    card: Color(0xFF0F0A1A),
    cardForeground: Color(0xFFF8FAFC),
    popover: Color(0xFF0F0A1A),
    popoverForeground: Color(0xFFF8FAFC),
    primary: Color(0xFF8B5CF6),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFF1E1B4B),
    secondaryForeground: Color(0xFFF8FAFC),
    muted: Color(0xFF1E1B4B),
    mutedForeground: Color(0xFF94A3B8),
    accent: Color(0xFF1E1B4B),
    accentForeground: Color(0xFFF8FAFC),
    destructive: Color(0xFFDC2626),
    destructiveForeground: Color(0xFFFFFFFF),
    border: Color(0xFF1E1B4B),
    input: Color(0xFF1E1B4B),
    ring: Color(0xFF8B5CF6),
  );
}
