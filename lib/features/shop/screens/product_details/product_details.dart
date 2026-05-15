import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart'; // Redundant
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
// Common Widgets (ensure all are imported)
import 'package:t_store/common/widgets/appbar/appbar.dart'; // Though not directly used in ProductDetailScreen's AppBar
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import 'package:t_store/common/widgets/icon/t_circular_icon.dart';
import 'package:t_store/common/widgets/images/t_rounded_image.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
// Screen Specific Widgets
import 'package:t_store/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:t_store/features/shop/screens/product_reviews/product_reviews.dart';
// Utils
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';

// Convert ProductDetailScreen to a StatefulWidget
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Animations for different sections
  late Animation<double> _imageSliderScaleAnimation;
  late Animation<Offset> _bottomNavBarSlideAnimation;

  late Animation<double> _ratingShareFadeAnimation;
  late Animation<Offset> _metaDataSlideAnimation;
  late Animation<double> _metaDataFadeAnimation;
  late Animation<Offset> _attributesSlideAnimation;
  late Animation<double> _attributesFadeAnimation;
  late Animation<Offset> _checkoutButtonSlideAnimation;
  late Animation<double> _checkoutButtonFadeAnimation;
  late Animation<Offset> _descriptionSlideAnimation;
  late Animation<double> _descriptionFadeAnimation;
  late Animation<Offset> _reviewsSlideAnimation;
  late Animation<double> _reviewsFadeAnimation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Total duration for all staggered animations
    );

    // Image Slider Animation (e.g., scale)
    _imageSliderScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeInOutBack)), // Early part of animation
    );

    // Bottom Nav Bar Animation (slide up)
    _bottomNavBarSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
          CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
        );


    // --- Animations for sections within Padding ---
    // Stagger these using Interval

    // Rating & Share (simple fade)
    _ratingShareFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.2, 0.5, curve: Curves.easeIn)),
    );

    // MetaData (slide up & fade)
    _metaDataSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic)),
        );
    _metaDataFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.25, 0.6, curve: Curves.easeIn)),
    );

    // Attributes (slide up & fade)
    _attributesSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic)),
        );
    _attributesFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );

    // Checkout Button (slide up & fade)
    _checkoutButtonSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic)),
        );
    _checkoutButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.35, 0.75, curve: Curves.easeIn)),
    );


    // Description (slide up & fade)
    _descriptionSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.4, 0.85, curve: Curves.easeOutCubic)),
        );
    _descriptionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 0.85, curve: Curves.easeIn)),
    );

    // Reviews (slide up & fade)
    _reviewsSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.45, 0.95, curve: Curves.easeOutCubic)),
        );
    _reviewsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.45, 0.95, curve: Curves.easeIn)),
    );


    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper method to wrap a widget with slide and fade transitions
  Widget _buildAnimatedSection({
    required Widget child,
    required Animation<Offset> slideAnimation,
    required Animation<double> fadeAnimation,
  }) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SlideTransition( // Animate bottom nav bar
        position: _bottomNavBarSlideAnimation,
        child: TBottomAddToCart(product: widget.product),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1 Product Image slider
            ScaleTransition( // Animate image slider
              scale: _imageSliderScaleAnimation,
              child: TProductImageSlider(
                product: widget.product,
              ),
            ),

            /// 2 - Product Details
            Padding(
              padding: const EdgeInsets.only( // Added const
                  right: TSizes.defaultSpace,
                  left: TSizes.defaultSpace,
                  bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  /// -- Rating Share
                  FadeTransition( // Simple fade for rating/share
                    opacity: _ratingShareFadeAnimation,
                    child: const TRatingAndShare(), // Added const
                  ),

                  /// Price,Title,Stock
                  _buildAnimatedSection(
                    slideAnimation: _metaDataSlideAnimation,
                    fadeAnimation: _metaDataFadeAnimation,
                    child: TProductMetaData(product: widget.product),
                  ),


                  /// Attributes
                  if (widget.product.productType == ProductType.variable.toString())
                    _buildAnimatedSection(
                      slideAnimation: _attributesSlideAnimation,
                      fadeAnimation: _attributesFadeAnimation,
                      child: TProductAttributes(product: widget.product),
                    ),
                  if (widget.product.productType == ProductType.variable.toString())
                    const SizedBox(
                      height: TSizes.spaceBtwSections,
                    ),

                  /// Checkout Button
                  _buildAnimatedSection(
                    slideAnimation: _checkoutButtonSlideAnimation,
                    fadeAnimation: _checkoutButtonFadeAnimation,
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Checkout'))), // Added const
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),

                  /// Description
                  _buildAnimatedSection(
                    slideAnimation: _descriptionSlideAnimation,
                    fadeAnimation: _descriptionFadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TSectionHeading( // Added const
                          title: 'Description',
                          showActionButton: false,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        ReadMoreText(
                          widget.product.description ?? '',
                          trimLines: 2,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Show more',
                          trimExpandedText: ' Less',
                          moreStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                          lessStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),

                  /// Reviews
                  _buildAnimatedSection(
                    slideAnimation: _reviewsSlideAnimation,
                    fadeAnimation: _reviewsFadeAnimation,
                    child: Column(
                      children: [
                        const Divider(),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Row( // Changed from Column to Row for better alignment
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TSectionHeading( // Added const
                                title: 'Reviews(199)', showActionButton: false),
                            IconButton(
                              icon: const Icon(Iconsax.arrow_right_3, size: 18),
                              onPressed: () =>
                                  Get.to(() => const ProductReviewsScreen()),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}