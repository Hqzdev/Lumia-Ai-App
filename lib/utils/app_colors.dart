import 'package:flutter/material.dart';

/// App color palette based on ChatGPT design with Yumi AI branding
class AppColors {
  // Primary colors (Yumi AI branding)
  static const Color primary = Color(0xFF6366F1); // Indigo/Lavender from yumiai.vercel.app
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);
  
  // Background colors (ChatGPT style)
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF343541); // ChatGPT dark background
  static const Color surface = Color(0xFFF7F7F8); // ChatGPT light surface
  static const Color surfaceDark = Color(0xFF444654); // ChatGPT dark surface
  
  // Text colors (ChatGPT style)
  static const Color textPrimary = Color(0xFF374151);
  static const Color textPrimaryDark = Color(0xFFECECF1);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  
  // Chat bubble colors (ChatGPT style)
  static const Color userBubble = Color(0xFFF7F7F8); // ChatGPT user message background
  static const Color assistantBubble = Color(0xFFFFFFFF); // ChatGPT assistant message background
  static const Color assistantBubbleDark = Color(0xFF444654); // ChatGPT dark assistant message
  static const Color userBubbleDark = Color(0xFF343541); // ChatGPT dark user message
  
  // Border and divider colors (ChatGPT style)
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF565869);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color dividerDark = Color(0xFF40414F);
  
  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // ChatGPT specific colors
  static const Color chatBackground = Color(0xFFFFFFFF);
  static const Color chatBackgroundDark = Color(0xFF343541);
  static const Color sidebarBackground = Color(0xFF202123);
  static const Color sidebarBackgroundDark = Color(0xFF202123);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBackgroundDark = Color(0xFF40414F);
  static const Color sendButton = Color(0xFF6366F1);
  static const Color sendButtonDisabled = Color(0xFFD1D5DB);
  
  // Gradient colors (Yumi AI branding)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF7F7F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [Color(0xFF343541), Color(0xFF444654)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// Gets the appropriate color based on theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? backgroundDark : background;
  }
  
  static Color getSurfaceColor(bool isDark) {
    return isDark ? surfaceDark : surface;
  }
  
  static Color getTextPrimaryColor(bool isDark) {
    return isDark ? textPrimaryDark : textPrimary;
  }
  
  static Color getTextSecondaryColor(bool isDark) {
    return isDark ? textSecondaryDark : textSecondary;
  }
  
  static Color getBorderColor(bool isDark) {
    return isDark ? borderDark : border;
  }
  
  static Color getDividerColor(bool isDark) {
    return isDark ? dividerDark : divider;
  }
  
  static Color getAssistantBubbleColor(bool isDark) {
    return isDark ? assistantBubbleDark : assistantBubble;
  }
  
  static Color getUserBubbleColor(bool isDark) {
    return isDark ? userBubbleDark : userBubble;
  }
  
  static Color getChatBackgroundColor(bool isDark) {
    return isDark ? chatBackgroundDark : chatBackground;
  }
  
  static Color getSidebarBackgroundColor(bool isDark) {
    return isDark ? sidebarBackgroundDark : sidebarBackground;
  }
  
  static Color getInputBackgroundColor(bool isDark) {
    return isDark ? inputBackgroundDark : inputBackground;
  }
} 