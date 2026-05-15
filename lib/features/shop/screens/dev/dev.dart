import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';

class DevScreen extends StatefulWidget { // Changed to StatefulWidget
  const DevScreen({super.key});

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> with SingleTickerProviderStateMixin { // Added with SingleTickerProviderStateMixin
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this, // vsync prevents offscreen animations from consuming unnecessary resources
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward(); // Start the animation when the widget is initialized
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose of controllers
    super.dispose();
  }

  // --- Your helper functions _launchURL, _sendEmail, _makePhoneCall remain the same ---
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('خطأ', 'لا يمكن فتح الرابط: $url');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('خطأ', 'لا يمكن فتح البريد الإلكتروني: $email');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('خطأ', 'لا يمكن إجراء المكالمة: $phoneNumber');
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: TAppBar(
        title: Text('Developer Info', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Developer Logo - Animated
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: TRoundedContainer(
                    width: 150,
                    height: 150,
                    backgroundColor: isDarkMode ? TColors.darkGrey : TColors.lightGrey,
                    child: Image.asset(TImages.magdy, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Developer Name - Animated
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'Magdy Elboushy',
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Contact Information Section - Could also be animated
              FadeTransition( // You can apply the same animation or a delayed one
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: TRoundedContainer(
                    padding: const EdgeInsets.all(TSizes.md),
                    backgroundColor: isDarkMode ? TColors.darkContainer : TColors.lightContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Contact Details', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        InkWell(
                          onTap: () => _sendEmail('magdymohamed1929@gmail.com'),
                          child: Row(
                            children: [
                              const Icon(Iconsax.sms, color: TColors.grey, size: TSizes.iconMd),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Text('magdymohamed1929@gmail.com', style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        InkWell(
                          onTap: () => _makePhoneCall('+201156820932'),
                          child: Row(
                            children: [
                              const Icon(Iconsax.call, color: TColors.grey, size: TSizes.iconMd),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Text('+20 1156820932', style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),
                        InkWell(
                          onTap: () => _launchURL('https://magdyelboushyme.netlify.app/'),
                          child: Row(
                            children: [
                              const Icon(Iconsax.global, color: TColors.grey, size: TSizes.iconMd),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Expanded(
                                child: Text(
                                  'https://magdyelboushyme.netlify.app/',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}