import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Only if TLoginForm or TLoginHeader internally use Get for navigation on tap, otherwise not strictly needed for animation here
import 'package:t_store/common/styles/spacing_styles.dart';
import 'package:t_store/utils/constants/text_strings.dart';

import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

// Convert LoginScreen to a StatefulWidget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  late Animation<Offset> _formSlideAnimation;
  late Animation<double> _formFadeAnimation;

  late Animation<double> _dividerFadeAnimation;

  late Animation<Offset> _socialButtonsSlideAnimation;
  late Animation<double> _socialButtonsFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // Total duration for all staggered animations
    );

    // Header Animation (Slides from top, fades in)
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5), // Start off-screen above
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic), // 0% to 40% of total duration
    ));
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Form Animation (Slides from bottom, fades in)
    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start off-screen below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic), // 20% to 60%
    ));
    _formFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
    ));

    // Divider Animation (Fades in)
    _dividerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn), // 50% to 80%
    ));

    // Social Buttons Animation (Slides from bottom, fades in)
    _socialButtonsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start off-screen below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic), // 70% to 100%
    ));
    _socialButtonsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // logo, title & Sub-title
              FadeTransition(
                opacity: _headerFadeAnimation,
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: const TLoginHeader(),
                ),
              ),

              /// form
              FadeTransition(
                opacity: _formFadeAnimation,
                child: SlideTransition(
                  position: _formSlideAnimation,
                  child: const TLoginForm(),
                ),
              ),

              /// Divider
              FadeTransition(
                opacity: _dividerFadeAnimation,
                child: TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Footer
              FadeTransition(
                opacity: _socialButtonsFadeAnimation,
                child: SlideTransition(
                  position: _socialButtonsSlideAnimation,
                  child: const TSocialButtons(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}