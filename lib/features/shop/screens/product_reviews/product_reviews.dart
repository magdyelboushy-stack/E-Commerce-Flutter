import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Keep if used by sub-widgets
import 'package:iconsax/iconsax.dart'; // Keep if used by sub-widgets
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';
import 'package:t_store/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart'; // Assumed to be TRatingBarIndicator or similar
import 'package:t_store/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:t_store/utils/device/device_utility.dart'; // Keep if used by sub-widgets

import '../../../../common/widgets/products.cart/ratings/rating_indicator.dart'; // This is TRatingBarIndicator
import '../../../../utils/constants/colors.dart'; // Keep if used by sub-widgets
import '../../../../utils/constants/sizes.dart';

// Convert ProductReviewsScreen to a StatefulWidget
class ProductReviewsScreen extends StatefulWidget {
  const ProductReviewsScreen({super.key});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen>
    with TickerProviderStateMixin { // Use TickerProviderStateMixin for multiple controllers if needed, or Single for one
  late AnimationController _mainAnimationController;
  late AnimationController _listAnimationController; // For staggered list items

  // Main screen animations
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _infoTextSlideAnimation;
  late Animation<double> _infoTextFadeAnimation;
  late Animation<Offset> _overallRatingSlideAnimation;
  late Animation<double> _overallRatingFadeAnimation;

  // List item animations
  List<Animation<double>> _reviewCardFadeAnimations = [];
  List<Animation<Offset>> _reviewCardSlideAnimations = [];

  // Dummy count for review cards, replace with actual data length
  final int _reviewCardCount = 4; // Assuming 4 UserReviewCard widgets for now

  @override
  void initState() {
    super.initState();

    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _listAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (_reviewCardCount * 100)), // Base + per item
    );

    // AppBar Fade
    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    // Info Text Animations
    _infoTextSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic)),
    );
    _infoTextFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: const Interval(0.1, 0.6, curve: Curves.easeIn)),
    );

    // Overall Rating Section Animations
    _overallRatingSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic)),
    );
    _overallRatingFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: const Interval(0.2, 0.8, curve: Curves.easeIn)),
    );

    // Initialize list item animations
    _initializeReviewCardAnimations(_reviewCardCount);

    _mainAnimationController.forward();
    // Delay list animation slightly or tie it to the end of main animations
    Future.delayed(const Duration(milliseconds: 400), () {
      if(mounted) _listAnimationController.forward();
    });
  }

  void _initializeReviewCardAnimations(int itemCount) {
    _reviewCardFadeAnimations = List.generate(
      itemCount,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _listAnimationController,
          curve: Interval(
            (index * 0.15).clamp(0.0, 1.0), // Stagger start time
            ((index * 0.15) + 0.4).clamp(0.0, 1.0), // Stagger end time
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    _reviewCardSlideAnimations = List.generate(
      itemCount,
          (index) => Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero) // Slide from right
          .animate(
        CurvedAnimation(
          parent: _listAnimationController,
          curve: Interval(
            (index * 0.15).clamp(0.0, 1.0),
            ((index * 0.15) + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedListItem({
    required Widget child,
    required int index,
  }) {
    if (index >= _reviewCardFadeAnimations.length || index >= _reviewCardSlideAnimations.length) {
      return child; // Fallback if animations not ready or index out of bounds
    }
    return SlideTransition(
      position: _reviewCardSlideAnimations[index],
      child: FadeTransition(
        opacity: _reviewCardFadeAnimations[index],
        child: child,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// --- Appbar
      appBar: TAppBar(
        title: FadeTransition(
          opacity: _appBarFadeAnimation,
          child: const Text('Reviews and Ratings'), // Added const
        ),
      ),

      /// -- Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace), // Added const
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SlideTransition(
                position: _infoTextSlideAnimation,
                child: FadeTransition(
                  opacity: _infoTextFadeAnimation,
                  child: const Text( // Added const
                      "Ratings and reviews are verified and are from people who use rhe same type of device thar you see."),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// Ovarall Product Rat
              SlideTransition(
                position: _overallRatingSlideAnimation,
                child: FadeTransition(
                  opacity: _overallRatingFadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TOverallProductRating(),
                      const TRatingBarIndicator(rating: 3.5),
                      Text(
                        '12,611',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// User Reviews List
              // This assumes you know the number of review cards beforehand
              // If UserReviewCard is dynamically generated from a list,
              // you would use ListView.builder and apply animations there.
              _buildAnimatedListItem(
                index: 0,
                child: const UserReviewCard(),
              ),
              _buildAnimatedListItem(
                index: 1,
                child: const UserReviewCard(),
              ),
              _buildAnimatedListItem(
                index: 2,
                child: const UserReviewCard(),
              ),
              _buildAnimatedListItem(
                index: 3,
                child: const UserReviewCard(),
              ),
              // If your UserReviewCard widgets were coming from a list:
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: yourReviewDataList.length, // use actual data length
              //   itemBuilder: (context, index) {
              //     // _initializeReviewCardAnimations(yourReviewDataList.length) should be called in initState
              //     // or whenever yourReviewDataList changes and has a new length.
              //     return _buildAnimatedListItem(
              //       index: index,
              //       child: UserReviewCard(review: yourReviewDataList[index]), // Pass review data
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}