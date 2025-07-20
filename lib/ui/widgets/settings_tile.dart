import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// A tile widget for settings screen
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.isDark,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: AppConstants.borderRadiusLg,
        border: Border.all(
          color: AppColors.getBorderColor(isDark),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppConstants.borderRadiusLg,
          child: Padding(
            padding: AppConstants.paddingMd,
            child: Row(
              children: [
                // Leading icon
                if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    color: leadingIconColor ?? AppColors.primary,
                    size: AppConstants.iconSizeMd,
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                ],
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextPrimaryColor(isDark),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppConstants.spacingXs),
                        Text(
                          subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.getTextSecondaryColor(isDark),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Trailing widget
                if (trailing != null) ...[
                  const SizedBox(width: AppConstants.spacingSm),
                  trailing!,
                ],
                
                // Arrow indicator for tappable tiles
                if (onTap != null) ...[
                  const SizedBox(width: AppConstants.spacingSm),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.getTextSecondaryColor(isDark),
                    size: AppConstants.iconSizeSm,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A settings tile with switch
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDark;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      isDark: isDark,
      leadingIcon: leadingIcon,
      leadingIconColor: leadingIconColor,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}

/// A settings tile with radio button
class SettingsRadioTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final bool isDark;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  const SettingsRadioTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.isDark,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      isDark: isDark,
      leadingIcon: leadingIcon,
      leadingIconColor: leadingIconColor,
      trailing: Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        activeColor: AppColors.primary,
      ),
      onTap: () => onChanged(value),
    );
  }
}

/// A settings tile with checkbox
class SettingsCheckboxTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDark;
  final IconData? leadingIcon;
  final Color? leadingIconColor;

  const SettingsCheckboxTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    required this.isDark,
    this.leadingIcon,
    this.leadingIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      isDark: isDark,
      leadingIcon: leadingIcon,
      leadingIconColor: leadingIconColor,
      trailing: Checkbox(
        value: value,
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        activeColor: AppColors.primary,
      ),
      onTap: () => onChanged(!value),
    );
  }
} 