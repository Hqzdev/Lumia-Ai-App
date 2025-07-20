import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../services/providers.dart';
import '../widgets/chat_message_new.dart';
import '../widgets/chat_input_new.dart';
import '../widgets/chat_sidebar.dart';
import 'settings_screen.dart';

/// Main chat screen in ChatGPT style
class ChatScreenNew extends ConsumerStatefulWidget {
  const ChatScreenNew({super.key});

  @override
  ConsumerState<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends ConsumerState<ChatScreenNew> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    final currentChat = ref.read(currentChatProvider);
    if (currentChat == null) {
      _createNewChat();
    } else {
      ref.read(chatMessagesProvider.notifier).loadMessagesForChat(currentChat.id);
    }
  }

  void _createNewChat() {
    final newChat = Chat.create(
      title: 'Новый чат',
      model: ref.read(selectedModelProvider),
    );
    ref.read(chatsProvider.notifier).addChat(newChat);
    ref.read(currentChatProvider.notifier).setCurrentChat(newChat);
  }

  @override
  Widget build(BuildContext context) {
    final currentChat = ref.watch(currentChatProvider);
    final messages = ref.watch(chatMessagesProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isStreaming = ref.watch(isStreamingProvider);
    final sidebarOpen = ref.watch(sidebarOpenProvider);
    final apiKey = ref.watch(apiKeyProvider);

    return Scaffold(
      backgroundColor: AppColors.getChatBackgroundColor(isDark),
      body: Row(
        children: [
          // Sidebar
          if (sidebarOpen) ...[
            ChatSidebar(
              currentChatId: currentChat?.id,
              onChatSelected: _selectChat,
              onNewChat: _createNewChat,
            ),
            const VerticalDivider(width: 1),
          ],
          
          // Main chat area
          Expanded(
            child: Column(
              children: [
                // App bar
                _buildAppBar(isDark, currentChat),
                
                // Messages area
                Expanded(
                  child: messages.isEmpty
                      ? _buildEmptyState(isDark)
                      : _buildMessagesList(messages, isDark),
                ),
                
                // Input area
                if (apiKey.isNotEmpty)
                  ChatInputNew(
                    controller: _textController,
                    onSend: _sendMessage,
                    isLoading: isLoading || isStreaming,
                    isDark: isDark,
                  )
                else
                  _buildApiKeyPrompt(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar(bool isDark, Chat? currentChat) {
    return AppBar(
      backgroundColor: AppColors.getChatBackgroundColor(isDark),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        onPressed: () {
          ref.read(sidebarOpenProvider.notifier).toggle();
        },
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppConstants.borderRadiusSm,
            ),
            child: const Icon(
              Icons.psychology,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),
          Expanded(
            child: Text(
              currentChat?.title ?? 'Yumi AI',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimaryColor(isDark),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: AppColors.getTextPrimaryColor(isDark),
          ),
          onPressed: _createNewChat,
        ),
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: AppColors.getTextPrimaryColor(isDark),
          ),
          onPressed: () => _navigateToSettings(context),
        ),
      ],
    );
  }

  /// Builds the empty state
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: AppConstants.borderRadiusLg,
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'Как я могу вам помочь?',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Задайте мне любой вопрос, и я постараюсь\nдать вам полезный ответ.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the messages list
  Widget _buildMessagesList(List<Message> messages, bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatMessageNew(
          message: message,
          isDark: isDark,
          onCopy: () => _copyMessage(message.content),
          onShare: () => _shareMessage(message.content),
          onDelete: () => _deleteMessage(message.id),
        )
        .animate()
        .fadeIn(duration: AppConstants.animationFast)
        .slideX(begin: message.role.isUser ? 0.3 : -0.3);
      },
    );
  }

  /// Builds the API key prompt
  Widget _buildApiKeyPrompt(bool isDark) {
    return Container(
      padding: AppConstants.paddingLg,
      margin: AppConstants.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: AppConstants.borderRadiusLg,
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.key_outlined,
            size: AppConstants.iconSizeLg,
            color: AppColors.warning,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Требуется API ключ',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Пожалуйста, установите ваш OpenAI API ключ в настройках, чтобы начать общение с Yumi AI.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingLg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToSettings(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: AppConstants.paddingMd,
                shape: RoundedRectangleBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                ),
              ),
              child: Text(
                'Перейти в настройки',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Selects a chat
  void _selectChat(Chat chat) {
    ref.read(currentChatProvider.notifier).setCurrentChat(chat);
    ref.read(chatMessagesProvider.notifier).loadMessagesForChat(chat.id);
    ref.read(sidebarOpenProvider.notifier).close();
  }

  /// Sends a message
  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final currentChat = ref.read(currentChatProvider);
    if (currentChat == null) return;

    final chatMessagesNotifier = ref.read(chatMessagesProvider.notifier);
    final openAIService = ref.read(openAIServiceProvider);
    final settings = ref.read(settingsProvider);
    final loadingNotifier = ref.read(isLoadingProvider.notifier);
    const streamingNotifier = ref.read(isStreamingProvider.notifier);

    // Add user message
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    await chatMessagesNotifier.addMessage(userMessage, currentChat.id);
    _textController.clear();
    _scrollToBottom();

    // Update chat title if it's the first message
    if (currentChat.messageIds.isEmpty) {
      final newTitle = content.length > 30 
          ? '${content.substring(0, 30)}...' 
          : content;
      ref.read(chatsProvider.notifier).updateChatTitle(currentChat.id, newTitle);
    }

    // Add assistant message placeholder
    final assistantMessage = Message(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: '',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
      model: settings.selectedModel,
    );

    await chatMessagesNotifier.addMessage(assistantMessage, currentChat.id);
    _scrollToBottom();

    try {
      loadingNotifier.startLoading();
      streamingNotifier.startStreaming();

      // Get messages for API
      final messagesForAPI = chatMessagesNotifier.getMessagesForAPI();
      
      // Send streaming request
      final responseStream = openAIService.sendStreamingChatCompletion(
        messages: messagesForAPI,
        model: settings.selectedModel,
      );

      String fullResponse = '';
      await for (final chunk in responseStream) {
        fullResponse += chunk;
        await chatMessagesNotifier.updateLastMessage(fullResponse);
        _scrollToBottom();
      }

      // Update final message
      final finalMessage = assistantMessage.copyWith(
        content: fullResponse,
        isStreaming: false,
      );
      
      await chatMessagesNotifier.updateLastMessage(fullResponse);
      
    } catch (e) {
      // Show error message
      final errorMessage = Message(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        content: 'Извините, произошла ошибка: ${e.toString()}',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        model: settings.selectedModel,
      );
      
      await chatMessagesNotifier.addMessage(errorMessage, currentChat.id);
      _scrollToBottom();
    } finally {
      loadingNotifier.stopLoading();
      streamingNotifier.stopStreaming();
    }
  }

  /// Scrolls to the bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.animationFast,
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Copies message content
  void _copyMessage(String content) {
    // Implementation for copying to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Сообщение скопировано в буфер обмена')),
    );
  }

  /// Shares message content
  void _shareMessage(String content) {
    // Implementation for sharing message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Поделиться сообщением...')),
    );
  }

  /// Deletes a message
  void _deleteMessage(String messageId) {
    final currentChat = ref.read(currentChatProvider);
    if (currentChat != null) {
      ref.read(chatMessagesProvider.notifier).removeMessage(messageId, currentChat.id);
    }
  }

  /// Navigates to settings
  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
} 