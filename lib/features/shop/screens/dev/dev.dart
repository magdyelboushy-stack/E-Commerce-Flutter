import 'package:flutter/material.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // يمكنك تحديد ما إذا كان الوضع داكنًا لتعديل بعض الألوان
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
              // Developer Logo
              TRoundedContainer(
                width: 150,
                height: 150,
                backgroundColor: isDarkMode ? TColors.darkGrey : TColors.lightGrey,
                child: Image.asset(TImages.magdy, fit: BoxFit.contain), // استخدم اللوجو الخاص بك
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Developer Name
              Text(
                'Magdy Elboushy',
                style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.primary),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Contact Information Section
              TRoundedContainer(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: isDarkMode ? TColors.darkContainer : TColors.lightContainer,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Details', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Email
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

                    // Phone Number
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

                    // Website
                    InkWell(
                      onTap: () => _launchURL('https://magdyelboushyme.netlify.app/'),
                      child: Row(
                        children: [
                          const Icon(Iconsax.global, color: TColors.grey, size: TSizes.iconMd),
                          const SizedBox(width: TSizes.spaceBtwItems),
                          Expanded( // استخدام Expanded لتجنب تجاوز النص للحدود
                            child: Text(
                              'https://magdyelboushyme.netlify.app/',
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis, // لقطع النص إذا كان طويلاً
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
