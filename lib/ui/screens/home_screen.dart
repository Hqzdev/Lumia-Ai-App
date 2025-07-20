import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../services/providers.dart';
import '../widgets/gradient_button.dart';
import 'chat_screen.dart';

/// Main home screen of the Yumi AI app
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark 
            ? AppColors.backgroundGradientDark 
            : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: AppConstants.paddingHorizontalLg,
            child: Column(
              children: [
                // Header section
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: AppConstants.borderRadiusXl,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
                          size: 60,
                          color: Colors.white,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: AppConstants.animationSlow)
                      .scale(begin: const Offset(0.8, 0.8)),
                      
                      const SizedBox(height: AppConstants.spacingXl),
                      
                      // Title
                      Text(
                        'Yumi AI',
                        style: GoogleFonts.inter(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimaryColor(isDark),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .slideY(begin: 0.3),
                      
                      const SizedBox(height: AppConstants.spacingMd),
                      
                      // Subtitle
                      Text(
                        'Your Intelligent AI Assistant',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextSecondaryColor(isDark),
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 400))
                      .slideY(begin: 0.3),
                    ],
                  ),
                ),
                
                // Features section
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Feature cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureCard(
                              context,
                              isDark,
                              Icons.chat_bubble_outline,
                              'Smart Chat',
                              'Intelligent conversations with AI',
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),
                          Expanded(
                            child: _buildFeatureCard(
                              context,
                              isDark,
                              Icons.code,
                              'Code Generation',
                              'Generate code in any language',
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 600))
                      .slideY(begin: 0.3),
                      
                      const SizedBox(height: AppConstants.spacingMd),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureCard(
                              context,
                              isDark,
                              Icons.lightbulb_outline,
                              'Creative Writing',
                              'Help with writing and content',
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),
                          Expanded(
                            child: _buildFeatureCard(
                              context,
                              isDark,
                              Icons.school_outlined,
                              'Learning',
                              'Learn new concepts and skills',
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 800))
                      .slideY(begin: 0.3),
                    ],
                  ),
                ),
                
                // CTA section
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GradientButton(
                        onPressed: () => _navigateToChat(context),
                        text: 'Start Conversation',
                        icon: Icons.chat_bubble_outline,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 1000))
                      .scale(begin: const Offset(0.9, 0.9)),
                      
                      const SizedBox(height: AppConstants.spacingLg),
                      
                      Text(
                        'Powered by OpenAI GPT',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.getTextSecondaryColor(isDark),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 1200)),
                      
                      const SizedBox(height: AppConstants.spacingXl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Builds a feature card widget
  Widget _buildFeatureCard(
    BuildContext context,
    bool isDark,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: AppConstants.paddingMd,
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(isDark),
        borderRadius: AppConstants.borderRadiusLg,
        border: Border.all(
          color: AppColors.getBorderColor(isDark),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppConstants.iconSizeLg,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextPrimaryColor(isDark),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXs),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondaryColor(isDark),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  /// Navigates to chat screen
  void _navigateToChat(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ChatScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: AppConstants.animationNormal,
      ),
    );
  }
} 