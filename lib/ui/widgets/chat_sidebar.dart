import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/chat.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../services/providers.dart';

/// Chat sidebar widget in ChatGPT style
class ChatSidebar extends ConsumerWidget {
  final String? currentChatId;
  final Function(Chat) onChatSelected;
  final VoidCallback onNewChat;

  const ChatSidebar({
    super.key,
    this.currentChatId,
    required this.onChatSelected,
    required this.onNewChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Container(
      width: 280,
      color: AppColors.getSidebarBackgroundColor(isDark),
      child: Column(
        children: [
          // Header
          _buildHeader(isDark),
          
          // New chat button
          _buildNewChatButton(isDark),
          
          // Divider
          Divider(
            color: AppColors.getDividerColor(isDark),
            height: 1,
          ),
          
          // Chats list
          Expanded(
            child: chats.isEmpty
                ? _buildEmptyState(isDark)
                : _buildChatsList(chats, isDark),
          ),
          
          // Footer
          _buildFooter(isDark),
        ],
      ),
    );
  }

  /// Builds the sidebar header
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the new chat button
  Widget _buildNewChatButton(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.spacingMd),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onNewChat,
          icon: const Icon(Icons.add),
          label: const Text('Новый чат'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.getTextPrimaryColor(isDark),
            side: BorderSide(
              color: AppColors.getBorderColor(isDark),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingMd,
              vertical: AppConstants.spacingSm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppConstants.borderRadiusMd,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the empty state
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: AppColors.getTextSecondaryColor(isDark),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Нет чатов',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Создайте новый чат,\nчтобы начать общение',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the chats list
  Widget _buildChatsList(List<Chat> chats, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSm),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final isSelected = chat.id == currentChatId;
        
        return _buildChatTile(chat, isSelected, isDark);
      },
    );
  }

  /// Builds a chat tile
  Widget _buildChatTile(Chat chat, bool isSelected, bool isDark) {
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingSm,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: AppConstants.borderRadiusMd,
          ),
          child: ListTile(
            dense: true,
            leading: chat.isPinned
                ? Icon(
                    Icons.push_pin,
                    size: 16,
                    color: AppColors.primary,
                  )
                : null,
            title: Text(
              chat.title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected 
                    ? AppColors.primary
                    : AppColors.getTextPrimaryColor(isDark),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              _formatDate(chat.updatedAt),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.getTextSecondaryColor(isDark),
              ),
            ),
            trailing: _buildChatActions(chat, isDark, ref),
            onTap: () => onChatSelected(chat),
            onLongPress: () => _showChatOptions(chat, isDark, ref),
          ),
        );
      },
    );
  }

  /// Builds chat actions
  Widget _buildChatActions(Chat chat, bool isDark, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chat.messageIds.isNotEmpty)
          Text(
            '${chat.messageIds.length}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
          ),
        const SizedBox(width: AppConstants.spacingXs),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 16,
            color: AppColors.getTextSecondaryColor(isDark),
          ),
          onSelected: (value) => _handleChatAction(value, chat, ref),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'pin',
              child: Row(
                children: [
                  Icon(
                    chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 16,
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Text(chat.isPinned ? 'Открепить' : 'Закрепить'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 16),
                  const SizedBox(width: AppConstants.spacingSm),
                  const Text('Переименовать'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                  const SizedBox(width: AppConstants.spacingSm),
                  const Text('Удалить', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the footer
  Widget _buildFooter(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.getDividerColor(isDark),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(settingsProvider);
              return Row(
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 16,
                    color: AppColors.getTextSecondaryColor(isDark),
                  ),
                  const SizedBox(width: AppConstants.spacingSm),
                  Expanded(
                    child: Text(
                      'Модель: ${settings.selectedModel}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.getTextSecondaryColor(isDark),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Работает на OpenAI GPT-4',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
          ),
        ],
      ),
    );
  }

  /// Formats date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}д назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'Только что';
    }
  }

  /// Shows chat options
  void _showChatOptions(Chat chat, bool isDark, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.getSurfaceColor(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLg),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.getTextSecondaryColor(isDark),
                borderRadius: AppConstants.borderRadiusFull,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            ListTile(
              leading: Icon(
                chat.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: AppColors.primary,
              ),
              title: Text(
                chat.isPinned ? 'Открепить чат' : 'Закрепить чат',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.getTextPrimaryColor(isDark),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ref.read(chatsProvider.notifier).togglePinChat(chat.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(
                'Переименовать',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.getTextPrimaryColor(isDark),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(chat, isDark, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                'Удалить чат',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(chat, isDark, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Shows rename dialog
  void _showRenameDialog(Chat chat, bool isDark, WidgetRef ref) {
    final controller = TextEditingController(text: chat.title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getSurfaceColor(isDark),
        title: Text(
          'Переименовать чат',
          style: GoogleFonts.inter(
            color: AppColors.getTextPrimaryColor(isDark),
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.inter(
            color: AppColors.getTextPrimaryColor(isDark),
          ),
          decoration: InputDecoration(
            hintText: 'Название чата',
            hintStyle: GoogleFonts.inter(
              color: AppColors.getTextSecondaryColor(isDark),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                ref.read(chatsProvider.notifier).updateChatTitle(chat.id, newTitle);
              }
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  /// Shows delete confirmation
  void _showDeleteConfirmation(Chat chat, bool isDark, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getSurfaceColor(isDark),
        title: Text(
          'Удалить чат?',
          style: GoogleFonts.inter(
            color: AppColors.getTextPrimaryColor(isDark),
          ),
        ),
        content: Text(
          'Это действие нельзя отменить. Все сообщения в чате будут удалены.',
          style: GoogleFonts.inter(
            color: AppColors.getTextSecondaryColor(isDark),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(chatsProvider.notifier).removeChat(chat.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  /// Handles chat action
  void _handleChatAction(String action, Chat chat, WidgetRef ref) {
    switch (action) {
      case 'pin':
        ref.read(chatsProvider.notifier).togglePinChat(chat.id);
        break;
      case 'rename':
        _showRenameDialog(chat, true, ref);
        break;
      case 'delete':
        _showDeleteConfirmation(chat, true, ref);
        break;
    }
  }
} 