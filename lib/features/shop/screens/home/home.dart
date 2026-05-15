import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/shop/screens/home/widgets/home_appbar.dart';
import 'package:t_store/features/shop/screens/home/widgets/home_categories.dart';
import 'package:t_store/features/shop/screens/home/widgets/promo_slider.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/containers/search_container.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/products.cart/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/product_controller.dart';
import '../all_products/all_products.dart';

// Convert HomeScreen to a StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _headerFadeAnimation;

  late Animation<Offset> _promoSliderSlideAnimation;
  late Animation<double> _promoSliderFadeAnimation;

  late Animation<double> _popularProductsHeadingFadeAnimation;
  late Animation<Offset> _productsContentSlideAnimation; // For shimmer/grid/no data
  late Animation<double> _productsContentFadeAnimation;

  final controller = Get.put(ProductController()); // Initialize controller

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Total duration for all animations
    );

    // Header Animation (Slides from top, fades in)
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3), // Start slightly off-screen above
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic), // 0% to 40%
    ));
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    ));

    // Promo Slider Animation (Slides from right, fades in)
    _promoSliderSlideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0), // Start off-screen to the right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic), // 20% to 60%
    ));
    _promoSliderFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
    ));

    // Popular Products Heading Animation (Fades in)
    _popularProductsHeadingFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn), // 50% to 80%
    ));

    // Products Content (Shimmer/Grid/No Data) Animation (Slides from bottom, fades in)
    _productsContentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Start slightly off-screen below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic), // 60% to 100%
    ));
    _productsContentFadeAnimation = Tween<double>(
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
    // Controller is already initialized in initState or as a field
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerSlideAnimation,
                child: TPrimaryHeaderContainer(
                  child: Column(
                    children: [
                      /// App bar
                      const THomeAppBar(),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// ---- Searchbar
                      const TSearchContainer(text: 'Search in Store'),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// --- Categories
                      Padding(
                        padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                        child: Column(
                          children: [
                            /// ----- Heading
                            const TSectionHeading(
                              title: 'Popular Categories',
                              showActionButton: false,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),

                            /// Categories
                            const THomeCategories(),
                          ],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
            ),

            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// ---- Promo Slider
                  FadeTransition(
                    opacity: _promoSliderFadeAnimation,
                    child: SlideTransition(
                      position: _promoSliderSlideAnimation,
                      child: const TPromoSlider(),
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// --- Heading
                  FadeTransition(
                    opacity: _popularProductsHeadingFadeAnimation,
                    child: TSectionHeading(
                        title: 'Popular Products',
                        onPressed: () => Get.to(() => AllProducts(
                          title: 'Popular Products',
                          futureMethod: controller.fetchAllFeaturedProducts(),
                        ))),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),

                  /// ----- Popular ----- ///
                  FadeTransition(
                    opacity: _productsContentFadeAnimation,
                    child: SlideTransition(
                      position: _productsContentSlideAnimation,
                      child: Obx(() {
                        if (controller.isLoading.value) return const TVerticalProductShimmer();

                        if (controller.featuredProducts.isEmpty) {
                          return Center(child: Text('No Data Found', style: Theme.of(context).textTheme.bodyMedium));
                        }
                        return TGridLayout(
                            itemCount: controller.featuredProducts.length,
                            itemBuilder: (_, index) => TProductCardVertical(
                              product: controller.featuredProducts[index],
                            ));
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}