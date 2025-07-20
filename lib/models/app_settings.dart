/// Represents application settings and preferences
class AppSettings {
  final String apiKey;
  final String selectedModel;
  final bool isDarkMode;
  final bool autoScroll;
  final bool saveHistory;
  final String systemPrompt;
  final int maxHistoryLength;

  const AppSettings({
    this.apiKey = '',
    this.selectedModel = 'gpt-3.5-turbo',
    this.isDarkMode = false,
    this.autoScroll = true,
    this.saveHistory = true,
    this.systemPrompt = 'You are Yumi AI, a helpful and intelligent assistant.',
    this.maxHistoryLength = 100,
  });

  /// Creates AppSettings from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      apiKey: json['apiKey'] as String? ?? '',
      selectedModel: json['selectedModel'] as String? ?? 'gpt-3.5-turbo',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      autoScroll: json['autoScroll'] as bool? ?? true,
      saveHistory: json['saveHistory'] as bool? ?? true,
      systemPrompt: json['systemPrompt'] as String? ?? 'You are Yumi AI, a helpful and intelligent assistant.',
      maxHistoryLength: json['maxHistoryLength'] as int? ?? 100,
    );
  }

  /// Converts AppSettings to JSON
  Map<String, dynamic> toJson() {
    return {
      'apiKey': apiKey,
      'selectedModel': selectedModel,
      'isDarkMode': isDarkMode,
      'autoScroll': autoScroll,
      'saveHistory': saveHistory,
      'systemPrompt': systemPrompt,
      'maxHistoryLength': maxHistoryLength,
    };
  }

  /// Creates a copy of AppSettings with updated fields
  AppSettings copyWith({
    String? apiKey,
    String? selectedModel,
    bool? isDarkMode,
    bool? autoScroll,
    bool? saveHistory,
    String? systemPrompt,
    int? maxHistoryLength,
  }) {
    return AppSettings(
      apiKey: apiKey ?? this.apiKey,
      selectedModel: selectedModel ?? this.selectedModel,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      autoScroll: autoScroll ?? this.autoScroll,
      saveHistory: saveHistory ?? this.saveHistory,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      maxHistoryLength: maxHistoryLength ?? this.maxHistoryLength,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.apiKey == apiKey &&
        other.selectedModel == selectedModel &&
        other.isDarkMode == isDarkMode &&
        other.autoScroll == autoScroll &&
        other.saveHistory == saveHistory &&
        other.systemPrompt == systemPrompt &&
        other.maxHistoryLength == maxHistoryLength;
  }

  @override
  int get hashCode {
    return Object.hash(
      apiKey,
      selectedModel,
      isDarkMode,
      autoScroll,
      saveHistory,
      systemPrompt,
      maxHistoryLength,
    );
  }
}

/// Available AI models
class AIModels {
  static const List<String> availableModels = [
    'gpt-3.5-turbo',
    'gpt-3.5-turbo-16k',
    'gpt-4',
    'gpt-4-turbo',
    'gpt-4-turbo-preview',
  ];

  /// Gets display name for model
  static String getDisplayName(String model) {
    switch (model) {
      case 'gpt-3.5-turbo':
        return 'GPT-3.5 Turbo';
      case 'gpt-3.5-turbo-16k':
        return 'GPT-3.5 Turbo (16K)';
      case 'gpt-4':
        return 'GPT-4';
      case 'gpt-4-turbo':
        return 'GPT-4 Turbo';
      case 'gpt-4-turbo-preview':
        return 'GPT-4 Turbo Preview';
      default:
        return model;
    }
  }
} 