import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// Chat message widget in ChatGPT style
class ChatMessageNew extends StatelessWidget {
  final Message message;
  final bool isDark;
  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const ChatMessageNew({
    super.key,
    required this.message,
    required this.isDark,
    this.onCopy,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      color: message.role.isUser 
          ? AppColors.getUserBubbleColor(isDark)
          : AppColors.getAssistantBubbleColor(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message header
          Row(
            children: [
              // Avatar
              Container(
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
              ),
              
              const SizedBox(width: AppConstants.spacingMd),
              
              // Role name
              Text(
                message.role.displayName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimaryColor(isDark),
                ),
              ),
              
              const Spacer(),
              
              // Actions
              if (message.role.isAssistant && message.content.isNotEmpty)
                _buildMessageActions(),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacingMd),
          
          // Message content
          if (message.isStreaming) ...[
            _buildStreamingIndicator(),
            const SizedBox(height: AppConstants.spacingSm),
          ],
          
          _buildMessageContent(),
          
          if (message.model != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            _buildModelInfo(),
          ],
        ],
      ),
    );
  }

  /// Builds the streaming indicator
  Widget _buildStreamingIndicator() {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(width: AppConstants.spacingSm),
        Text(
          'Yumi печатает...',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.getTextSecondaryColor(isDark),
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
          color: AppColors.getTextPrimaryColor(isDark),
          height: 1.6,
        ),
        code: GoogleFonts.inter(
          fontSize: 14,
          backgroundColor: AppColors.getSurfaceColor(isDark),
          color: AppColors.primary,
        ),
        codeblockDecoration: BoxDecoration(
          color: AppColors.getSurfaceColor(isDark),
          borderRadius: AppConstants.borderRadiusMd,
          border: Border.all(
            color: AppColors.getBorderColor(isDark),
            width: 1,
          ),
        ),
        blockquote: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.getTextSecondaryColor(isDark),
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColors.primary.withOpacity(0.3),
              width: 3,
            ),
          ),
        ),
        listBullet: GoogleFonts.inter(
          fontSize: 16,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        h1: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        h2: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        h3: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        h4: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
        tableBorder: TableBorder.all(
          color: AppColors.getBorderColor(isDark),
          width: 1,
        ),
        tableColumnWidth: const FlexColumnWidth(),
        tableCellsPadding: const EdgeInsets.all(8),
      ),
      shrinkWrap: true,
      softLineBreak: true,
    );
  }

  /// Builds the model info
  Widget _buildModelInfo() {
    return Text(
      'Модель: ${message.model}',
      style: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.getTextSecondaryColor(isDark),
      ),
    );
  }

  /// Builds the message actions
  Widget _buildMessageActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onCopy != null)
          _buildActionButton(
            icon: Icons.copy_outlined,
            onPressed: onCopy!,
            tooltip: 'Копировать',
          ),
        if (onShare != null) ...[
          const SizedBox(width: AppConstants.spacingXs),
          _buildActionButton(
            icon: Icons.share_outlined,
            onPressed: onShare!,
            tooltip: 'Поделиться',
          ),
        ],
        if (onDelete != null) ...[
          const SizedBox(width: AppConstants.spacingXs),
          _buildActionButton(
            icon: Icons.delete_outline,
            onPressed: onDelete!,
            tooltip: 'Удалить',
            color: AppColors.error,
          ),
        ],
      ],
    );
  }

  /// Builds an action button
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    Color? color,
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
            color: color ?? AppColors.getTextSecondaryColor(isDark),
          ),
        ),
      ),
    );
  }
} 