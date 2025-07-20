import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// Chat input widget in ChatGPT style
class ChatInputNew extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;
  final bool isDark;
  final VoidCallback? onVoiceInput;

  const ChatInputNew({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
    required this.isDark,
    this.onVoiceInput,
  });

  @override
  State<ChatInputNew> createState() => _ChatInputNewState();
}

class _ChatInputNewState extends State<ChatInputNew> {
  bool _hasText = false;
  bool _isShiftPressed = false;

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
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.getInputBackgroundColor(widget.isDark),
        border: Border(
          top: BorderSide(
            color: AppColors.getBorderColor(widget.isDark),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input field container
            Container(
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Text input
                  Expanded(
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
                        hintText: 'Сообщение Yumi AI...',
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
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\n')),
                      ],
                    ),
                  ),
                  
                  // Voice button
                  if (widget.onVoiceInput != null) ...[
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.getBorderColor(widget.isDark),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: AppColors.getTextSecondaryColor(widget.isDark),
                        size: AppConstants.iconSizeMd,
                      ),
                      onPressed: widget.onVoiceInput,
                    ),
                  ],
                  
                  // Send button
                  Container(
                    width: 1,
                    height: 24,
                    color: AppColors.getBorderColor(widget.isDark),
                  ),
                  Container(
                    width: AppConstants.inputHeight,
                    height: AppConstants.inputHeight,
                    decoration: BoxDecoration(
                      color: _hasText && !widget.isLoading
                          ? AppColors.sendButton
                          : AppColors.sendButtonDisabled,
                      borderRadius: BorderRadius.only(
                        topRight: AppConstants.borderRadiusLg,
                        bottomRight: AppConstants.borderRadiusLg,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _hasText && !widget.isLoading ? _sendMessage : null,
                        borderRadius: BorderRadius.only(
                          topRight: AppConstants.borderRadiusLg,
                          bottomRight: AppConstants.borderRadiusLg,
                        ),
                        child: widget.isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              )
                            : Icon(
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
            
            // Help text
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.spacingSm),
              child: Text(
                'Enter для отправки, Shift+Enter для новой строки',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.getTextSecondaryColor(widget.isDark),
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
class AdvancedChatInputNew extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;
  final bool isDark;
  final VoidCallback? onVoiceInput;
  final VoidCallback? onAttachment;
  final VoidCallback? onStopGeneration;

  const AdvancedChatInputNew({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
    required this.isDark,
    this.onVoiceInput,
    this.onAttachment,
    this.onStopGeneration,
  });

  @override
  State<AdvancedChatInputNew> createState() => _AdvancedChatInputNewState();
}

class _AdvancedChatInputNewState extends State<AdvancedChatInputNew> {
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
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.getInputBackgroundColor(widget.isDark),
        border: Border(
          top: BorderSide(
            color: AppColors.getBorderColor(widget.isDark),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stop generation button (when streaming)
            if (widget.isLoading && widget.onStopGeneration != null) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: widget.onStopGeneration,
                  icon: const Icon(Icons.stop),
                  label: const Text('Остановить генерацию'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
            ],
            
            // Input field container
            Container(
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Attachment button
                  if (widget.onAttachment != null) ...[
                    IconButton(
                      icon: Icon(
                        Icons.attach_file,
                        color: AppColors.getTextSecondaryColor(widget.isDark),
                        size: AppConstants.iconSizeMd,
                      ),
                      onPressed: widget.onAttachment,
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.getBorderColor(widget.isDark),
                    ),
                  ],
                  
                  // Text input
                  Expanded(
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
                        hintText: 'Сообщение Yumi AI...',
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
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  
                  // Voice button
                  if (widget.onVoiceInput != null) ...[
                    Container(
                      width: 1,
                      height: 24,
                      color: AppColors.getBorderColor(widget.isDark),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.mic,
                        color: AppColors.getTextSecondaryColor(widget.isDark),
                        size: AppConstants.iconSizeMd,
                      ),
                      onPressed: widget.onVoiceInput,
                    ),
                  ],
                  
                  // Send button
                  Container(
                    width: 1,
                    height: 24,
                    color: AppColors.getBorderColor(widget.isDark),
                  ),
                  Container(
                    width: AppConstants.inputHeight,
                    height: AppConstants.inputHeight,
                    decoration: BoxDecoration(
                      color: _hasText && !widget.isLoading
                          ? AppColors.sendButton
                          : AppColors.sendButtonDisabled,
                      borderRadius: BorderRadius.only(
                        topRight: AppConstants.borderRadiusLg,
                        bottomRight: AppConstants.borderRadiusLg,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _hasText && !widget.isLoading ? _sendMessage : null,
                        borderRadius: BorderRadius.only(
                          topRight: AppConstants.borderRadiusLg,
                          bottomRight: AppConstants.borderRadiusLg,
                        ),
                        child: widget.isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                              )
                            : Icon(
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