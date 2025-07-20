import 'package:flutter/material.dart';

/// App constants for spacing, sizes, and other values
class AppConstants {
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // Border radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;
  
  // Button sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightLg = 56.0;
  
  // Input field sizes
  static const double inputHeight = 48.0;
  static const double inputHeightLg = 56.0;
  
  // Chat bubble sizes
  static const double chatBubbleMaxWidth = 280.0;
  static const double chatBubbleMinWidth = 80.0;
  static const double chatBubblePadding = 16.0;
  
  // Avatar sizes
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeLg = 48.0;
  
  // Icon sizes
  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  
  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // API timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration apiRetryDelay = Duration(seconds: 2);
  
  // Storage keys
  static const String settingsKey = 'app_settings';
  static const String chatHistoryKey = 'chat_history';
  static const String apiKeyKey = 'openai_api_key';
  
  // Default values
  static const String defaultSystemPrompt = 'You are Yumi AI, a helpful and intelligent assistant.';
  static const String defaultModel = 'gpt-3.5-turbo';
  static const int maxHistoryLength = 100;
  
  // URLs
  static const String websiteUrl = 'https://yumiai.vercel.app';
  static const String privacyPolicyUrl = '$websiteUrl/privacy';
  static const String termsOfServiceUrl = '$websiteUrl/terms';
  
  /// Returns EdgeInsets with consistent spacing
  static EdgeInsets get paddingSm => const EdgeInsets.all(spacingSm);
  static EdgeInsets get paddingMd => const EdgeInsets.all(spacingMd);
  static EdgeInsets get paddingLg => const EdgeInsets.all(spacingLg);
  static EdgeInsets get paddingXl => const EdgeInsets.all(spacingXl);
  
  /// Returns horizontal padding
  static EdgeInsets get paddingHorizontalSm => const EdgeInsets.symmetric(horizontal: spacingSm);
  static EdgeInsets get paddingHorizontalMd => const EdgeInsets.symmetric(horizontal: spacingMd);
  static EdgeInsets get paddingHorizontalLg => const EdgeInsets.symmetric(horizontal: spacingLg);
  
  /// Returns vertical padding
  static EdgeInsets get paddingVerticalSm => const EdgeInsets.symmetric(vertical: spacingSm);
  static EdgeInsets get paddingVerticalMd => const EdgeInsets.symmetric(vertical: spacingMd);
  static EdgeInsets get paddingVerticalLg => const EdgeInsets.symmetric(vertical: spacingLg);
  
  /// Returns BorderRadius with consistent values
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);
} 