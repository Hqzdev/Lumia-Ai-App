import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// Widget for displaying chat messages
class ChatMessage extends StatelessWidget {
  final Message message;
  final bool isDark;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isDark,
    this.onCopy,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.role.isUser) ...[
            _buildAvatar(),
            const SizedBox(width: AppConstants.spacingSm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: message.role.isUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                _buildMessageBubble(),
                if (message.role.isAssistant) _buildMessageActions(),
              ],
            ),
          ),
          if (message.role.isUser) ...[
            const SizedBox(width: AppConstants.spacingSm),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  /// Builds the avatar for the message
  Widget _buildAvatar() {
    return Container(
      width: AppConstants.avatarSizeMd,
      height: AppConstants.avatarSizeMd,
      decoration: BoxDecoration(
        gradient: message.role.isUser 
            ? AppColors.primaryGradient
            : null,
        color: message.role.isUser 
            ? null 
            : AppColors.getAssistantBubbleColor(isDark),
        borderRadius: AppConstants.borderRadiusFull,
        border: message.role.isUser 
            ? null 
            : Border.all(
                color: AppColors.getBorderColor(isDark),
                width: 1,
              ),
      ),
      child: Icon(
        message.role.isUser ? Icons.person : Icons.psychology,
        size: AppConstants.iconSizeSm,
        color: message.role.isUser 
            ? Colors.white 
            : AppColors.primary,
      ),
    );
  }

  /// Builds the message bubble
  Widget _buildMessageBubble() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppConstants.chatBubbleMaxWidth,
        minWidth: AppConstants.chatBubbleMinWidth,
      ),
      padding: const EdgeInsets.all(AppConstants.chatBubblePadding),
      decoration: BoxDecoration(
        color: message.role.isUser 
            ? AppColors.userBubble
            : AppColors.getAssistantBubbleColor(isDark),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppConstants.radiusMd),
          topRight: const Radius.circular(AppConstants.radiusMd),
          bottomLeft: Radius.circular(
            message.role.isUser 
                ? AppConstants.radiusMd 
                : AppConstants.radiusSm,
          ),
          bottomRight: Radius.circular(
            message.role.isUser 
                ? AppConstants.radiusSm 
                : AppConstants.radiusMd,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isStreaming) ...[
            _buildStreamingIndicator(),
            const SizedBox(height: AppConstants.spacingSm),
          ],
          _buildMessageContent(),
          if (message.model != null) ...[
            const SizedBox(height: AppConstants.spacingXs),
            _buildModelInfo(),
          ],
        ],
      ),
    );
  }

  /// Builds the streaming indicator
  Widget _buildStreamingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              message.role.isUser 
                  ? Colors.white 
                  : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingXs),
        Text(
          'Yumi is typing...',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: message.role.isUser 
                ? Colors.white.withOpacity(0.8)
                : AppColors.getTextSecondaryColor(isDark),
          ),
        ),
      ],
    );
  }

  /// Builds the message content
  Widget _buildMessageContent() {
    if (message.content.isEmpty) {
      return const SizedBox.shrink();
    }

    return MarkdownBody(
      data: message.content,
      styleSheet: MarkdownStyleSheet(
        p: GoogleFonts.inter(
          fontSize: 16,
          color: message.role.isUser 
              ? Colors.white 
              : AppColors.getTextPrimaryColor(isDark),
          height: 1.5,
        ),
        code: GoogleFonts.inter(
          fontSize: 14,
          backgroundColor: message.role.isUser 
              ? Colors.white.withOpacity(0.1)
              : AppColors.getSurfaceColor(isDark),
          color: message.role.isUser 
              ? Colors.white 
              : AppColors.primary,
        ),
        codeblockDecoration: BoxDecoration(
          color: message.role.isUser 
              ? Colors.white.withOpacity(0.1)
              : AppColors.getSurfaceColor(isDark),
          borderRadius: AppConstants.borderRadiusSm,
        ),
        blockquote: GoogleFonts.inter(
          fontSize: 16,
          color: message.role.isUser 
              ? Colors.white.withOpacity(0.8)
              : AppColors.getTextSecondaryColor(isDark),
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: message.role.isUser 
                  ? Colors.white.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.3),
              width: 3,
            ),
          ),
        ),
        listBullet: GoogleFonts.inter(
          fontSize: 16,
          color: message.role.isUser 
              ? Colors.white 
              : AppColors.getTextPrimaryColor(isDark),
        ),
        h1: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: message.role.isUser 
              ? Colors.white 
              : AppColors.getTextPrimaryColor(isDark),
        ),
        h2: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: message.role.isUser 
              ? Colors.white 
              : AppColors.getTextPrimaryColor(isDark),
        ),
        h3: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: message.role.isUser 
              ? Colors.white 
              : AppColors.getTextPrimaryColor(isDark),
        ),
      ),
      shrinkWrap: true,
      softLineBreak: true,
    );
  }

  /// Builds the model info
  Widget _buildModelInfo() {
    return Text(
      'Model: ${message.model}',
      style: GoogleFonts.inter(
        fontSize: 10,
        color: message.role.isUser 
            ? Colors.white.withOpacity(0.6)
            : AppColors.getTextSecondaryColor(isDark),
      ),
    );
  }

  /// Builds the message actions
  Widget _buildMessageActions() {
    if (message.role.isUser || message.content.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppConstants.spacingXs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onCopy != null)
            _buildActionButton(
              icon: Icons.copy_outlined,
              onPressed: onCopy!,
              tooltip: 'Copy message',
            ),
          if (onShare != null) ...[
            const SizedBox(width: AppConstants.spacingXs),
            _buildActionButton(
              icon: Icons.share_outlined,
              onPressed: onShare!,
              tooltip: 'Share message',
            ),
          ],
        ],
      ),
    );
  }

  /// Builds an action button
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppConstants.borderRadiusSm,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXs),
          child: Icon(
            icon,
            size: AppConstants.iconSizeSm,
            color: AppColors.getTextSecondaryColor(isDark),
          ),
        ),
      ),
    );
  }
} 