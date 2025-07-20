import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../services/providers.dart';
import '../widgets/settings_tile.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _systemPromptController = TextEditingController();
  bool _isApiKeyVisible = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  void _loadSettings() {
    final settings = ref.read(settingsProvider);
    _apiKeyController.text = settings.apiKey;
    _systemPromptController.text = settings.systemPrompt;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = ref.watch(isDarkModeProvider);

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(isDark),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimaryColor(isDark),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextPrimaryColor(isDark),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Configuration Section
            _buildSectionHeader('API Configuration', isDark),
            _buildApiKeyTile(isDark),
            const SizedBox(height: AppConstants.spacingLg),

            // AI Model Section
            _buildSectionHeader('AI Model', isDark),
            _buildModelSelector(isDark),
            const SizedBox(height: AppConstants.spacingLg),

            // Chat Settings Section
            _buildSectionHeader('Chat Settings', isDark),
            _buildSystemPromptTile(isDark),
            SettingsTile(
              title: 'Auto-scroll to new messages',
              subtitle: 'Automatically scroll to the latest message',
              trailing: Switch(
                value: settings.autoScroll,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).updateAutoScroll(value);
                },
                activeColor: AppColors.primary,
              ),
              isDark: isDark,
            ),
            SettingsTile(
              title: 'Save chat history',
              subtitle: 'Store conversation history locally',
              trailing: Switch(
                value: settings.saveHistory,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).updateSaveHistory(value);
                },
                activeColor: AppColors.primary,
              ),
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Appearance Section
            _buildSectionHeader('Appearance', isDark),
            SettingsTile(
              title: 'Dark mode',
              subtitle: 'Use dark theme',
              trailing: Switch(
                value: settings.isDarkMode,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleDarkMode();
                },
                activeColor: AppColors.primary,
              ),
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // Data Management Section
            _buildSectionHeader('Data Management', isDark),
            SettingsTile(
              title: 'Clear chat history',
              subtitle: 'Delete all saved conversations',
              trailing: Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: AppConstants.iconSizeMd,
              ),
              onTap: _showClearHistoryDialog,
              isDark: isDark,
            ),
            SettingsTile(
              title: 'Reset to defaults',
              subtitle: 'Restore all settings to default values',
              trailing: Icon(
                Icons.restore_outlined,
                color: AppColors.warning,
                size: AppConstants.iconSizeMd,
              ),
              onTap: _showResetDialog,
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spacingLg),

            // About Section
            _buildSectionHeader('About', isDark),
            SettingsTile(
              title: 'Visit website',
              subtitle: 'yumiai.vercel.app',
              trailing: Icon(
                Icons.open_in_new,
                color: AppColors.primary,
                size: AppConstants.iconSizeMd,
              ),
              onTap: _launchWebsite,
              isDark: isDark,
            ),
            SettingsTile(
              title: 'Version',
              subtitle: '1.0.0',
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }

  /// Builds a section header
  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.getTextPrimaryColor(isDark),
        ),
      ),
    );
  }

  /// Builds the API key input tile
  Widget _buildApiKeyTile(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: AppConstants.borderRadiusLg,
        border: Border.all(
          color: AppColors.getBorderColor(isDark),
          width: 1,
        ),
      ),
      child: Padding(
        padding: AppConstants.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OpenAI API Key',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimaryColor(isDark),
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Enter your OpenAI API key to use Yumi AI',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.getTextSecondaryColor(isDark),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextField(
              controller: _apiKeyController,
              obscureText: !_isApiKeyVisible,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.getTextPrimaryColor(isDark),
              ),
              decoration: InputDecoration(
                hintText: 'sk-...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.getTextSecondaryColor(isDark),
                ),
                border: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.getBorderColor(isDark),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.getBorderColor(isDark),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isApiKeyVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.getTextSecondaryColor(isDark),
                      ),
                      onPressed: () {
                        setState(() {
                          _isApiKeyVisible = !_isApiKeyVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.save,
                        color: AppColors.primary,
                      ),
                      onPressed: _saveApiKey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the model selector
  Widget _buildModelSelector(bool isDark) {
    final settings = ref.watch(settingsProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: AppConstants.borderRadiusLg,
        border: Border.all(
          color: AppColors.getBorderColor(isDark),
          width: 1,
        ),
      ),
      child: Padding(
        padding: AppConstants.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Model',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimaryColor(isDark),
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Choose the AI model for conversations',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.getTextSecondaryColor(isDark),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            DropdownButtonFormField<String>(
              value: settings.selectedModel,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.getBorderColor(isDark),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.getBorderColor(isDark),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              items: AIModels.availableModels.map((model) {
                return DropdownMenuItem(
                  value: model,
                  child: Text(
                    AIModels.getDisplayName(model),
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.getTextPrimaryColor(isDark),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSelectedModel(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the system prompt input tile
  Widget _buildSystemPromptTile(bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: AppConstants.borderRadiusLg,
        border: Border.all(
          color: AppColors.getBorderColor(isDark),
          width: 1,
        ),
      ),
      child: Padding(
        padding: AppConstants.paddingMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Prompt',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimaryColor(isDark),
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Define the AI assistant\'s personality and behavior',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.getTextSecondaryColor(isDark),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            TextField(
              controller: _systemPromptController,
              maxLines: 3,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.getTextPrimaryColor(isDark),
              ),
              decoration: InputDecoration(
                hintText: 'You are Yumi AI, a helpful and intelligent assistant.',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.getTextSecondaryColor(isDark),
                ),
                border: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.getBorderColor(isDark),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.getBorderColor(isDark),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppConstants.borderRadiusMd,
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.save,
                    color: AppColors.primary,
                  ),
                  onPressed: _saveSystemPrompt,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Saves the API key
  void _saveApiKey() {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isNotEmpty) {
      ref.read(settingsProvider.notifier).updateApiKey(apiKey);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key saved successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid API key')),
      );
    }
  }

  /// Saves the system prompt
  void _saveSystemPrompt() {
    final prompt = _systemPromptController.text.trim();
    if (prompt.isNotEmpty) {
      ref.read(settingsProvider.notifier).updateSystemPrompt(prompt);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('System prompt saved successfully')),
      );
    }
  }

  /// Shows the clear history confirmation dialog
  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to delete all chat history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatMessagesProvider.notifier).clearChat();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat history cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// Shows the reset settings confirmation dialog
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).resetToDefaults();
              _loadSettings();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  /// Launches the website
  void _launchWebsite() async {
    final url = Uri.parse(AppConstants.websiteUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open website')),
      );
    }
  }
} 