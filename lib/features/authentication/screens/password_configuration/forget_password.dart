import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/authentication/screens/password_configuration/reset_password.dart'; // Keep if used by controller
import 'package:t_store/utils/validators/validation.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/forget_password/forget_password_controller.dart';

// Convert ForgetPassword to a StatefulWidget
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _headingSlideAnimation;
  late Animation<double> _headingFadeAnimation;

  late Animation<Offset> _textFieldSlideAnimation;
  late Animation<double> _textFieldFadeAnimation;

  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _buttonFadeAnimation;

  // It's good practice to also initialize the GetX controller in initState
  // if you are converting to StatefulWidget, though Get.put usually handles it.
  // final controller = Get.put(ForgetPasswordController()); // Can be here or in build

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Total duration for all animations
    );

    // Headings Animation (Slides from left, fades in)
    _headingSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0), // Start off-screen to the left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic), // 0% to 40%
    ));
    _headingFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Text Field Animation (Slides from bottom, fades in)
    _textFieldSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4), // Start off-screen below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic), // 30% to 70%
    ));
    _textFieldFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
    ));

    // Button Animation (Slides from bottom, fades in)
    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4), // Start off-screen below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic), // 60% to 100%
    ));
    _buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
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
    // Initialize controller here if not done in initState or if you prefer it here for GetX
    final controller = Get.put(ForgetPasswordController());

    return Scaffold(
      appBar: AppBar(), // AppBar can be animated similarly if desired
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            FadeTransition(
              opacity: _headingFadeAnimation,
              child: SlideTransition(
                position: _headingSlideAnimation,
                child: Column( // Group headings for a single animation block
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TTexts.forgetPasswordTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(
                      TTexts.forgetPasswordSubTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            /// Text field
            FadeTransition(
              opacity: _textFieldFadeAnimation,
              child: SlideTransition(
                position: _textFieldSlideAnimation,
                child: Form(
                  key: controller.forgetPasswordFormKey,
                  child: TextFormField(
                    controller: controller.email,
                    validator: TValidator.validateEmail,
                    decoration: const InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Iconsax.direct_right)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /// Submit Button
            FadeTransition(
              opacity: _buttonFadeAnimation,
              child: SlideTransition(
                position: _buttonSlideAnimation,
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => controller.sendPasswordResetEmail(),
                        child: const Text(TTexts.submit))),
              ),
            )
          ],
        ),
      ),
    );
  }
}