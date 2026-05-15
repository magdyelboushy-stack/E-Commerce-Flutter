import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Only if TSignupForm or TSocialButtons internally use Get for navigation on tap
import 'package:t_store/common/widgets/login_signup/form_divider.dart';
import 'package:t_store/common/widgets/login_signup/social_buttons.dart';
import 'package:t_store/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';

// Convert SignupScreen to a StatefulWidget
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _titleFadeAnimation;

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

    // Title Animation (Slides from left, fades in)
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0), // Start off-screen to the left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic), // 0% to 40%
    ));
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Form Animation (Slides from bottom, fades in)
    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4), // Start off-screen below
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
      begin: const Offset(0, 0.4), // Start off-screen below
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
      appBar: AppBar(), // AppBar can remain un-animated or you can animate it too if desired
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              FadeTransition(
                opacity: _titleFadeAnimation,
                child: SlideTransition(
                  position: _titleSlideAnimation,
                  child: Text(
                    TTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Form
              FadeTransition(
                opacity: _formFadeAnimation,
                child: SlideTransition(
                  position: _formSlideAnimation,
                  child: const TSignupForm(),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Divider
              FadeTransition(
                opacity: _dividerFadeAnimation,
                child: TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Social Buttons
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