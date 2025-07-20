import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// Widget for chat input with send button
class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;
  final bool isDark;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
    required this.isDark,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(widget.isDark),
        border: Border(
          top: BorderSide(
            color: AppColors.getBorderColor(widget.isDark),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Text input field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppConstants.inputHeight,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getBackgroundColor(widget.isDark),
                  borderRadius: AppConstants.borderRadiusLg,
                  border: Border.all(
                    color: AppColors.getBorderColor(widget.isDark),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  enabled: !widget.isLoading,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.getTextPrimaryColor(widget.isDark),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.getTextSecondaryColor(widget.isDark),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingSm,
                    ),
                    suffixIcon: widget.isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(AppConstants.spacingMd),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  onSubmitted: _hasText && !widget.isLoading ? _sendMessage : null,
                ),
              ),
            ),
            
            const SizedBox(width: AppConstants.spacingSm),
            
            // Send button
            Container(
              width: AppConstants.inputHeight,
              height: AppConstants.inputHeight,
              decoration: BoxDecoration(
                gradient: _hasText && !widget.isLoading
                    ? AppColors.primaryGradient
                    : null,
                color: _hasText && !widget.isLoading
                    ? null
                    : AppColors.getBorderColor(widget.isDark),
                borderRadius: AppConstants.borderRadiusLg,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _hasText && !widget.isLoading ? _sendMessage : null,
                  borderRadius: AppConstants.borderRadiusLg,
                  child: Icon(
                    Icons.send_rounded,
                    color: _hasText && !widget.isLoading
                        ? Colors.white
                        : AppColors.getTextSecondaryColor(widget.isDark),
                    size: AppConstants.iconSizeMd,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage([String? text]) {
    final content = text ?? widget.controller.text.trim();
    if (content.isNotEmpty && !widget.isLoading) {
      widget.onSend(content);
    }
  }
}

/// Alternative chat input with more features
class AdvancedChatInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;
  final bool isDark;
  final VoidCallback? onAttachment;
  final VoidCallback? onVoice;

  const AdvancedChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
    required this.isDark,
    this.onAttachment,
    this.onVoice,
  });

  @override
  State<AdvancedChatInput> createState() => _AdvancedChatInputState();
}

class _AdvancedChatInputState extends State<AdvancedChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppConstants.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(widget.isDark),
        border: Border(
          top: BorderSide(
            color: AppColors.getBorderColor(widget.isDark),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            if (widget.onAttachment != null) ...[
              _buildActionButton(
                icon: Icons.attach_file,
                onPressed: widget.onAttachment!,
                tooltip: 'Attach file',
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],
            
            // Voice button
            if (widget.onVoice != null) ...[
              _buildActionButton(
                icon: Icons.mic,
                onPressed: widget.onVoice!,
                tooltip: 'Voice message',
              ),
              const SizedBox(width: AppConstants.spacingSm),
            ],
            
            // Text input field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppConstants.inputHeight,
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getBackgroundColor(widget.isDark),
                  borderRadius: AppConstants.borderRadiusLg,
                  border: Border.all(
                    color: AppColors.getBorderColor(widget.isDark),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  enabled: !widget.isLoading,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.getTextPrimaryColor(widget.isDark),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.getTextSecondaryColor(widget.isDark),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMd,
                      vertical: AppConstants.spacingSm,
                    ),
                  ),
                  onSubmitted: _hasText && !widget.isLoading ? _sendMessage : null,
                ),
              ),
            ),
            
            const SizedBox(width: AppConstants.spacingSm),
            
            // Send button
            Container(
              width: AppConstants.inputHeight,
              height: AppConstants.inputHeight,
              decoration: BoxDecoration(
                gradient: _hasText && !widget.isLoading
                    ? AppColors.primaryGradient
                    : null,
                color: _hasText && !widget.isLoading
                    ? null
                    : AppColors.getBorderColor(widget.isDark),
                borderRadius: AppConstants.borderRadiusLg,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _hasText && !widget.isLoading ? _sendMessage : null,
                  borderRadius: AppConstants.borderRadiusLg,
                  child: Icon(
                    Icons.send_rounded,
                    color: _hasText && !widget.isLoading
                        ? Colors.white
                        : AppColors.getTextSecondaryColor(widget.isDark),
                    size: AppConstants.iconSizeMd,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: AppConstants.inputHeight,
        height: AppConstants.inputHeight,
        decoration: BoxDecoration(
          color: AppColors.getBorderColor(widget.isDark),
          borderRadius: AppConstants.borderRadiusLg,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppConstants.borderRadiusLg,
            child: Icon(
              icon,
              color: AppColors.getTextSecondaryColor(widget.isDark),
              size: AppConstants.iconSizeMd,
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage([String? text]) {
    final content = text ?? widget.controller.text.trim();
    if (content.isNotEmpty && !widget.isLoading) {
      widget.onSend(content);
    }
  }
} 