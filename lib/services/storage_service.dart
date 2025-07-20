import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../models/app_settings.dart';
import '../models/chat.dart';
import '../utils/app_constants.dart';

/// Service for local data storage using SharedPreferences
class StorageService {
  static SharedPreferences? _prefs;
  
  /// Initializes the storage service
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Gets SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }
  
  // Settings methods
  
  /// Saves app settings
  static Future<void> saveSettings(AppSettings settings) async {
    await prefs.setString(AppConstants.settingsKey, jsonEncode(settings.toJson()));
  }
  
  /// Loads app settings
  static Future<AppSettings> loadSettings() async {
    final settingsJson = prefs.getString(AppConstants.settingsKey);
    if (settingsJson != null) {
      try {
        return AppSettings.fromJson(jsonDecode(settingsJson));
      } catch (e) {
        // Return default settings if parsing fails
        return const AppSettings();
      }
    }
    return const AppSettings();
  }
  
  /// Updates specific setting
  static Future<void> updateSetting<T>(String key, T value) async {
    final settings = await loadSettings();
    AppSettings updatedSettings;
    
    switch (key) {
      case 'apiKey':
        updatedSettings = settings.copyWith(apiKey: value as String);
        break;
      case 'selectedModel':
        updatedSettings = settings.copyWith(selectedModel: value as String);
        break;
      case 'isDarkMode':
        updatedSettings = settings.copyWith(isDarkMode: value as bool);
        break;
      case 'autoScroll':
        updatedSettings = settings.copyWith(autoScroll: value as bool);
        break;
      case 'saveHistory':
        updatedSettings = settings.copyWith(saveHistory: value as bool);
        break;
      case 'systemPrompt':
        updatedSettings = settings.copyWith(systemPrompt: value as String);
        break;
      case 'maxHistoryLength':
        updatedSettings = settings.copyWith(maxHistoryLength: value as int);
        break;
      default:
        throw Exception('Unknown setting key: $key');
    }
    
    await saveSettings(updatedSettings);
  }
  
  // Chat methods
  
  /// Saves chats
  static Future<void> saveChats(List<Chat> chats) async {
    final chatsJson = chats.map((chat) => chat.toJson()).toList();
    await prefs.setString('chats', jsonEncode(chatsJson));
  }
  
  /// Loads chats
  static Future<List<Chat>> loadChats() async {
    final chatsJson = prefs.getString('chats');
    if (chatsJson != null) {
      try {
        final List<dynamic> chatsList = jsonDecode(chatsJson);
        return chatsList.map((json) => Chat.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
  
  /// Saves messages for a specific chat
  static Future<void> saveMessagesForChat(List<Message> messages, String chatId) async {
    final messagesJson = messages.map((msg) => msg.toJson()).toList();
    await prefs.setString('messages_$chatId', jsonEncode(messagesJson));
  }
  
  /// Loads messages for a specific chat
  static Future<List<Message>> loadMessagesForChat(String chatId) async {
    final messagesJson = prefs.getString('messages_$chatId');
    if (messagesJson != null) {
      try {
        final List<dynamic> messagesList = jsonDecode(messagesJson);
        return messagesList.map((json) => Message.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
  
  /// Adds a message to a specific chat
  static Future<void> addMessageToChat(Message message, String chatId) async {
    final messages = await loadMessagesForChat(chatId);
    messages.add(message);
    
    // Limit messages per chat
    final settings = await loadSettings();
    if (messages.length > settings.maxHistoryLength) {
      messages.removeRange(0, messages.length - settings.maxHistoryLength);
    }
    
    await saveMessagesForChat(messages, chatId);
  }
  
  /// Clears messages for a specific chat
  static Future<void> clearChatMessages(String chatId) async {
    await prefs.remove('messages_$chatId');
  }
  
  // Legacy methods for backward compatibility
  
  /// Saves chat history (legacy)
  static Future<void> saveChatHistory(List<Message> messages) async {
    final messagesJson = messages.map((msg) => msg.toJson()).toList();
    await prefs.setString(AppConstants.chatHistoryKey, jsonEncode(messagesJson));
  }
  
  /// Loads chat history (legacy)
  static Future<List<Message>> loadChatHistory() async {
    final historyJson = prefs.getString(AppConstants.chatHistoryKey);
    if (historyJson != null) {
      try {
        final List<dynamic> messagesList = jsonDecode(historyJson);
        return messagesList.map((json) => Message.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
  
  /// Adds a message to chat history (legacy)
  static Future<void> addMessage(Message message) async {
    final history = await loadChatHistory();
    history.add(message);
    
    final settings = await loadSettings();
    if (history.length > settings.maxHistoryLength) {
      history.removeRange(0, history.length - settings.maxHistoryLength);
    }
    
    await saveChatHistory(history);
  }
  
  /// Clears chat history (legacy)
  static Future<void> clearChatHistory() async {
    await prefs.remove(AppConstants.chatHistoryKey);
  }
  
  // API Key methods
  
  /// Saves API key
  static Future<void> saveApiKey(String apiKey) async {
    await prefs.setString(AppConstants.apiKeyKey, apiKey);
  }
  
  /// Loads API key
  static Future<String?> loadApiKey() async {
    return prefs.getString(AppConstants.apiKeyKey);
  }
  
  /// Removes API key
  static Future<void> removeApiKey() async {
    await prefs.remove(AppConstants.apiKeyKey);
  }
  
  // Utility methods
  
  /// Clears all stored data
  static Future<void> clearAllData() async {
    await prefs.clear();
  }
  
  /// Gets storage size (approximate)
  static Future<int> getStorageSize() async {
    int size = 0;
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      final value = prefs.get(key);
      if (value is String) {
        size += value.length;
      }
    }
    
    return size;
  }
  
  /// Checks if storage is available
  static bool get isAvailable => _prefs != null;
} 