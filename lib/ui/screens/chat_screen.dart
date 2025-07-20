import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../services/providers.dart';
import '../widgets/chat_message.dart';
import '../widgets/chat_input.dart';
import 'settings_screen.dart';

/// Chat screen where users can interact with Yumi AI
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final isLoading = ref.watch(isLoadingProvider);
    final isStreaming = ref.watch(isStreamingProvider);
    final apiKey = ref.watch(apiKeyProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: _buildAppBar(isDark),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(isDark)
                : _buildMessagesList(messages, isDark),
          ),
          
          // Input area
          if (apiKey.isNotEmpty)
            ChatInput(
              controller: _textController,
              onSend: _sendMessage,
              isLoading: isLoading || isStreaming,
              isDark: isDark,
            )
          else
            _buildApiKeyPrompt(isDark),
        ],
      ),
    );
  }

  /// Builds the app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        onPressed: () => Navigator.of(context).pop(),
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
          Text(
            'Yumi AI',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: AppColors.getTextSecondaryColor(isDark),
          ),
          onPressed: _showClearChatDialog,
        ),
        IconButton(
          icon: Icon(
            Icons.settings_outlined,
            color: AppColors.getTextSecondaryColor(isDark),
          ),
          onPressed: () => _navigateToSettings(context),
        ),
      ],
    );
  }

  /// Builds the empty state when no messages exist
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
            'Start a conversation',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Ask me anything! I can help with coding,\nwriting, learning, and more.',
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
      padding: AppConstants.paddingMd,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatMessage(
          message: message,
          isDark: isDark,
          onCopy: () => _copyMessage(message.content),
          onShare: () => _shareMessage(message.content),
        )
        .animate()
        .fadeIn(duration: AppConstants.animationFast)
        .slideX(begin: message.role.isUser ? 0.3 : -0.3);
      },
    );
  }

  /// Builds the API key prompt when no key is set
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
            'API Key Required',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Please set your OpenAI API key in settings to start chatting with Yumi AI.',
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
                'Go to Settings',
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

  /// Sends a message to the AI
  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    final openAIService = ref.read(openAIServiceProvider);
    final settings = ref.read(settingsProvider);
    final loadingNotifier = ref.read(isLoadingProvider.notifier);
    final streamingNotifier = ref.read(isStreamingProvider.notifier);

    // Add user message
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    await chatNotifier.addMessage(userMessage);
    _textController.clear();
    _scrollToBottom();

    // Add assistant message placeholder
    final assistantMessage = Message(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: '',
      role: MessageRole.assistant,
      timestamp: DateTime.now(),
      isStreaming: true,
      model: settings.selectedModel,
    );

    await chatNotifier.addMessage(assistantMessage);
    _scrollToBottom();

    try {
      loadingNotifier.startLoading();
      streamingNotifier.startStreaming();

      // Get messages for API
      final messagesForAPI = chatNotifier.getMessagesForAPI();
      
      // Send streaming request
      final responseStream = openAIService.sendStreamingChatCompletion(
        messages: messagesForAPI,
        model: settings.selectedModel,
      );

      String fullResponse = '';
      await for (final chunk in responseStream) {
        fullResponse += chunk;
        await chatNotifier.updateLastMessage(fullResponse);
        _scrollToBottom();
      }

      // Update final message
      final finalMessage = assistantMessage.copyWith(
        content: fullResponse,
        isStreaming: false,
      );
      
      await chatNotifier.updateLastMessage(fullResponse);
      
    } catch (e) {
      // Show error message
      final errorMessage = Message(
        id: (DateTime.now().millisecondsSinceEpoch + 2).toString(),
        content: 'Sorry, I encountered an error: ${e.toString()}',
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        model: settings.selectedModel,
      );
      
      await chatNotifier.addMessage(errorMessage);
      _scrollToBottom();
    } finally {
      loadingNotifier.stopLoading();
      streamingNotifier.stopStreaming();
    }
  }

  /// Scrolls to the bottom of the messages list
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

  /// Shows the clear chat confirmation dialog
  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatMessagesProvider.notifier).clearChat();
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Copies message content to clipboard
  void _copyMessage(String content) {
    // Implementation for copying to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard')),
    );
  }

  /// Shares message content
  void _shareMessage(String content) {
    // Implementation for sharing message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing message...')),
    );
  }

  /// Navigates to settings screen
  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
} 