import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';
import '../models/app_settings.dart';
import '../models/chat.dart';
import 'openai_service.dart';
import 'storage_service.dart';

// Services providers
final openAIServiceProvider = Provider<OpenAIService>((ref) {
  return OpenAIService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Settings providers
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.read(storageServiceProvider));
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isDarkMode;
});

final selectedModelProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).selectedModel;
});

final apiKeyProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).apiKey;
});

// Chat providers
final chatsProvider = StateNotifierProvider<ChatsNotifier, List<Chat>>((ref) {
  return ChatsNotifier(ref.read(storageServiceProvider));
});

final currentChatProvider = StateNotifierProvider<CurrentChatNotifier, Chat?>((ref) {
  return CurrentChatNotifier(ref.read(storageServiceProvider));
});

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<Message>>((ref) {
  return ChatMessagesNotifier(ref.read(storageServiceProvider));
});

final isStreamingProvider = StateNotifierProvider<StreamingNotifier, bool>((ref) {
  return StreamingNotifier();
});

// UI providers
final isLoadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

final sidebarOpenProvider = StateNotifierProvider<SidebarNotifier, bool>((ref) {
  return SidebarNotifier();
});

/// Notifier for managing app settings
class SettingsNotifier extends StateNotifier<AppSettings> {
  final StorageService _storageService;
  
  SettingsNotifier(this._storageService) : super(const AppSettings()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final settings = await _storageService.loadSettings();
    state = settings;
  }
  
  Future<void> updateApiKey(String apiKey) async {
    await _storageService.updateSetting('apiKey', apiKey);
    state = state.copyWith(apiKey: apiKey);
  }
  
  Future<void> updateSelectedModel(String model) async {
    await _storageService.updateSetting('selectedModel', model);
    state = state.copyWith(selectedModel: model);
  }
  
  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    await _storageService.updateSetting('isDarkMode', newValue);
    state = state.copyWith(isDarkMode: newValue);
  }
  
  Future<void> updateAutoScroll(bool value) async {
    await _storageService.updateSetting('autoScroll', value);
    state = state.copyWith(autoScroll: value);
  }
  
  Future<void> updateSaveHistory(bool value) async {
    await _storageService.updateSetting('saveHistory', value);
    state = state.copyWith(saveHistory: value);
  }
  
  Future<void> updateSystemPrompt(String prompt) async {
    await _storageService.updateSetting('systemPrompt', prompt);
    state = state.copyWith(systemPrompt: prompt);
  }
  
  Future<void> updateMaxHistoryLength(int length) async {
    await _storageService.updateSetting('maxHistoryLength', length);
    state = state.copyWith(maxHistoryLength: length);
  }
  
  Future<void> resetToDefaults() async {
    const defaultSettings = AppSettings();
    await _storageService.saveSettings(defaultSettings);
    state = defaultSettings;
  }
}

/// Notifier for managing chats
class ChatsNotifier extends StateNotifier<List<Chat>> {
  final StorageService _storageService;
  
  ChatsNotifier(this._storageService) : super([]) {
    _loadChats();
  }
  
  Future<void> _loadChats() async {
    final chats = await _storageService.loadChats();
    state = chats;
  }
  
  Future<void> addChat(Chat chat) async {
    state = [chat, ...state];
    await _storageService.saveChats(state);
  }
  
  Future<void> updateChat(Chat chat) async {
    final index = state.indexWhere((c) => c.id == chat.id);
    if (index != -1) {
      final newState = List<Chat>.from(state);
      newState[index] = chat;
      state = newState;
      await _storageService.saveChats(state);
    }
  }
  
  Future<void> removeChat(String chatId) async {
    state = state.where((chat) => chat.id != chatId).toList();
    await _storageService.saveChats(state);
  }
  
  Future<void> togglePinChat(String chatId) async {
    final index = state.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      final chat = state[index];
      final updatedChat = chat.togglePinned();
      final newState = List<Chat>.from(state);
      newState[index] = updatedChat;
      
      // Sort: pinned first, then by updatedAt
      newState.sort((a, b) {
        if (a.isPinned != b.isPinned) {
          return b.isPinned ? 1 : -1;
        }
        return b.updatedAt.compareTo(a.updatedAt);
      });
      
      state = newState;
      await _storageService.saveChats(state);
    }
  }
  
  Future<void> updateChatTitle(String chatId, String newTitle) async {
    final index = state.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      final chat = state[index];
      final updatedChat = chat.updateTitle(newTitle);
      final newState = List<Chat>.from(state);
      newState[index] = updatedChat;
      state = newState;
      await _storageService.saveChats(state);
    }
  }
}

/// Notifier for managing current chat
class CurrentChatNotifier extends StateNotifier<Chat?> {
  final StorageService _storageService;
  
  CurrentChatNotifier(this._storageService) : super(null);
  
  void setCurrentChat(Chat chat) {
    state = chat;
  }
  
  void clearCurrentChat() {
    state = null;
  }
}

/// Notifier for managing chat messages
class ChatMessagesNotifier extends StateNotifier<List<Message>> {
  final StorageService _storageService;
  
  ChatMessagesNotifier(this._storageService) : super([]);
  
  Future<void> loadMessagesForChat(String chatId) async {
    final messages = await _storageService.loadMessagesForChat(chatId);
    state = messages;
  }
  
  Future<void> addMessage(Message message, String chatId) async {
    state = [...state, message];
    
    if (message.role.isUser) {
      await _storageService.addMessageToChat(message, chatId);
    }
  }
  
  Future<void> updateLastMessage(String content) async {
    if (state.isNotEmpty) {
      final lastMessage = state.last;
      final updatedMessage = lastMessage.copyWith(content: content);
      state = [...state.sublist(0, state.length - 1), updatedMessage];
    }
  }
  
  Future<void> clearMessages() async {
    state = [];
  }
  
  Future<void> removeMessage(String messageId, String chatId) async {
    state = state.where((msg) => msg.id != messageId).toList();
    await _storageService.saveMessagesForChat(state, chatId);
  }
  
  List<Message> getMessagesForAPI() {
    // Filter out system messages and add system prompt if needed
    final messages = state.where((msg) => msg.role != MessageRole.system).toList();
    
    // Add system message at the beginning if not present
    if (messages.isNotEmpty && messages.first.role != MessageRole.system) {
      messages.insert(0, Message(
        id: 'system',
        content: 'You are Yumi AI, a helpful and intelligent assistant.',
        role: MessageRole.system,
        timestamp: DateTime.now(),
      ));
    }
    
    return messages;
  }
}

/// Notifier for managing sidebar state
class SidebarNotifier extends StateNotifier<bool> {
  SidebarNotifier() : super(false);
  
  void toggle() {
    state = !state;
  }
  
  void open() {
    state = true;
  }
  
  void close() {
    state = false;
  }
}

/// Notifier for managing streaming state
class StreamingNotifier extends StateNotifier<bool> {
  StreamingNotifier() : super(false);
  
  void startStreaming() {
    state = true;
  }
  
  void stopStreaming() {
    state = false;
  }
}

/// Notifier for managing loading state
class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);
  
  void startLoading() {
    state = true;
  }
  
  void stopLoading() {
    state = false;
  }
} 