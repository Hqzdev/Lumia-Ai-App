import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../widgets/gradient_button.dart';
import 'chat_screen.dart';

/// Onboarding screen with simple welcome message
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: AppConstants.paddingHorizontalLg,
            child: Column(
              children: [
                // Top section with logo
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: AppConstants.borderRadiusLg,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: const Duration(milliseconds: 600))
                      .scale(begin: const Offset(0.8, 0.8)),
                      
                      const SizedBox(height: AppConstants.spacingLg),
                      
                      Text(
                        'Добро пожаловать в Yumi AI',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 200))
                      .slideY(begin: 0.3),
                      
                      const SizedBox(height: AppConstants.spacingMd),
                      
                      Text(
                        'Ваш интеллектуальный помощник на базе искусственного интеллекта',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 400))
                      .slideY(begin: 0.3),
                    ],
                  ),
                ),
                
                // Bottom section with CTA
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GradientButton(
                        onPressed: () => _navigateToChat(context),
                        text: 'Начать',
                        icon: Icons.chat_bubble_outline,
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 600))
                      .scale(begin: const Offset(0.9, 0.9)),
                      
                      const SizedBox(height: AppConstants.spacingLg),
                      
                      Text(
                        'Работает на OpenAI GPT-4',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 800)),
                      
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
  
  void _navigateToChat(BuildContext context) {
    Navigator.of(context).pushReplacement(
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
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
} 