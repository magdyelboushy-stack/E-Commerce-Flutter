import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/personalization/screens/addres/address.dart';
import 'package:t_store/features/personalization/screens/profile/profile.dart';
import 'package:t_store/features/shop/screens/order/order.dart';

import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
// Ensure this import is correct for your project structure
// import '../../../authentication/screens/login/login.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin { // Use TickerProviderStateMixin for multiple controllers
  late AnimationController _screenController;
  late Animation<double> _screenFadeAnimation;
  late Animation<Offset> _screenSlideAnimation;

  late AnimationController _headerController;
  late Animation<Offset> _appBarSlideAnimation;
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _profileTitleSlideAnimation;
  late Animation<double> _profileTitleFadeAnimation;


  late AnimationController _listAnimationController;
  late List<Animation<Offset>> _tileSlideAnimations;
  late List<Animation<double>> _tileFadeAnimations;

  late AnimationController _bottomElementsController;
  late Animation<double> _sectionHeaderFadeAnimation;
  late Animation<double> _logoutButtonFadeAnimation;


  final List<Map<String, dynamic>> _accountSettingsItems = [
    {'icon': Iconsax.safe_home, 'title': 'My Addresses', 'subTitle': 'Set shopping deliver, address', 'onTap': (BuildContext context) => Get.to(() => const UserAddressScreen())},
    {'icon': Iconsax.shopping_cart, 'title': 'My Cart', 'subTitle': 'Add, remove products and move to checkout'},
    {'icon': Iconsax.bag_tick, 'title': 'My Orders', 'subTitle': 'In-progress and Completed Orders', 'onTap': (BuildContext context) => Get.to(() => const OrderScreen())},
    {'icon': Iconsax.bank, 'title': 'Bank Account', 'subTitle': 'Withdraw balance to registered bank account'},
    {'icon': Iconsax.discount_shape, 'title': 'My Coupons', 'subTitle': 'List of all the discounted coupons'},
    {'icon': Iconsax.notification, 'title': 'Notification', 'subTitle': 'Set any kind of notification message'},
    {'icon': Iconsax.security_card, 'title': 'Account Privacy', 'subTitle': 'Manage data usage and connected accounts'},
  ];

  final List<Map<String, dynamic>> _appSettingsItems = [
    {'icon': Iconsax.document_upload, 'title': 'Load Data', 'subTitle': 'Upload Data to your Cloud Firebase'},
    {'icon': Iconsax.location, 'title': 'Geolocation', 'subTitle': 'Set recommendation based on location', 'trailing': Switch(value: true, onChanged: (value) {})},
    {'icon': Iconsax.security_user, 'title': 'Safe Mode', 'subTitle': 'Search result is safe for all ages', 'trailing': Switch(value: false, onChanged: (value) {})},
    {'icon': Iconsax.image, 'title': 'HD Image Quality', 'subTitle': 'Set image quality to be seen', 'trailing': Switch(value: false, onChanged: (value) {})},
  ];

  @override
  void initState() {
    super.initState();

    // 1. Screen Enter Animation
    _screenController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _screenFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _screenController, curve: Curves.easeIn));
    _screenSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _screenController, curve: Curves.easeOut));

    // 2. Header Elements Animation (staggered within header)
    _headerController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _appBarSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(CurvedAnimation(parent: _headerController, curve: Interval(0.0, 0.6, curve: Curves.easeOut)));
    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _headerController, curve: Interval(0.0, 0.6, curve: Curves.easeIn)));
    _profileTitleSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(CurvedAnimation(parent: _headerController, curve: Interval(0.4, 1.0, curve: Curves.easeOut)));
    _profileTitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _headerController, curve: Interval(0.4, 1.0, curve: Curves.easeIn)));

    // 3. List Tiles Animation
    _listAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    final totalTiles = _accountSettingsItems.length + _appSettingsItems.length;
    _tileSlideAnimations = [];
    _tileFadeAnimations = [];
    for (int i = 0; i < totalTiles; i++) {
      final startTime = (i * 100) / _listAnimationController.duration!.inMilliseconds; // Quicker stagger
      final endTime = (startTime + 0.5).clamp(0.0, 1.0);
      _tileSlideAnimations.add(Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero).animate(CurvedAnimation(parent: _listAnimationController, curve: Interval(startTime, endTime, curve: Curves.easeOutCubic))));
      _tileFadeAnimations.add(Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _listAnimationController, curve: Interval(startTime, endTime, curve: Curves.easeIn))));
    }

    // 4. Section Headers & Logout Button Animation
    _bottomElementsController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _sectionHeaderFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _bottomElementsController, curve: Curves.easeIn));
    _logoutButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _bottomElementsController, curve: Interval(0.5, 1.0, curve: Curves.easeIn))); // Logout button fades in a bit later


    // Start animations
    _screenController.forward();
    _screenController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _headerController.forward();
        _listAnimationController.forward(); // Start list animation after screen is visible
        _bottomElementsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _screenController.dispose();
    _headerController.dispose();
    _listAnimationController.dispose();
    _bottomElementsController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedTile(Animation<Offset> slideAnim, Animation<double> fadeAnim, Map<String, dynamic> itemData) {
    return FadeTransition(
      opacity: fadeAnim,
      child: SlideTransition(
        position: slideAnim,
        child: TSettingsMenuTile(
          icon: itemData['icon'],
          title: itemData['title'],
          subTitle: itemData['subTitle'],
          onTap: itemData['onTap'] != null ? () => itemData['onTap']!(context) : null,
          trailing: itemData['trailing'] as Widget?,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int tileAnimationIndex = 0;

    return Scaffold(
      body: FadeTransition(
        opacity: _screenFadeAnimation,
        child: SlideTransition(
          position: _screenSlideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// --- Header
                TPrimaryHeaderContainer(
                  child: Column(
                    children: [
                      /// --- App Bar
                      FadeTransition(
                        opacity: _appBarFadeAnimation,
                        child: SlideTransition(
                          position: _appBarSlideAnimation,
                          child: TAppBar(
                            title: Text('Account', style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white)),
                          ),
                        ),
                      ),

                      /// User Profile Card
                      FadeTransition(
                        opacity: _profileTitleFadeAnimation,
                        child: SlideTransition(
                          position: _profileTitleSlideAnimation,
                          child: TUserProfileTitle(onPressed: () => Get.to(() => const ProfileScreen())),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),

                /// --- Body
                Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// --- Account Settings
                      FadeTransition(
                        opacity: _sectionHeaderFadeAnimation,
                        child: const TSectionHeading(title: 'Account Settings', showActionButton: false),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ..._accountSettingsItems.map((item) {
                        final widget = _buildAnimatedTile(_tileSlideAnimations[tileAnimationIndex], _tileFadeAnimations[tileAnimationIndex], item);
                        tileAnimationIndex++;
                        return widget;
                      }).toList(),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// -- App Settings
                      FadeTransition(
                        opacity: _sectionHeaderFadeAnimation, // Re-use or create a new one if different timing is needed
                        child: const TSectionHeading(title: 'App Settings', showActionButton: false),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      ..._appSettingsItems.map((item) {
                        final widget = _buildAnimatedTile(_tileSlideAnimations[tileAnimationIndex], _tileFadeAnimations[tileAnimationIndex], item);
                        tileAnimationIndex++;
                        return widget;
                      }).toList(),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// زر تسجيل الخروج
                      FadeTransition(
                        opacity: _logoutButtonFadeAnimation,
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => AuthenticationRepository.instance.logout(),
                            child: const Text('Logout'),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections * 2.5),
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
}