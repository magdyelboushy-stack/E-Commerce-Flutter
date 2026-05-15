import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/icon/t_circular_icon.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products.cart/product_card_vertical.dart';
import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:t_store/features/shop/models/product_model.dart'; // Ensure this is the correct import
import 'package:t_store/features/shop/screens/home/home.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
import 'package:t_store/utils/loaders/animation_loader.dart';

import '../../../../navigation_menu.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/favourite_controller.dart';

// Convert FavouriteScreen to a StatefulWidget
class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with TickerProviderStateMixin {
  late AnimationController _mainScreenAnimationController;
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  // For staggered grid animation
  AnimationController? _gridAnimationController;
  List<Animation<double>> _gridItemFadeAnimations = [];
  List<Animation<Offset>> _gridItemSlideAnimations = [];

  final controller = FavouritesController.instance;
  List<ProductModel> _currentProducts = []; // To hold current products for grid animation

  @override
  void initState() {
    super.initState();

    _mainScreenAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Duration for AppBar and main content area
    );

    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _contentSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic)),
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.4, 1.0, curve: Curves.easeIn)),
    );

    _mainScreenAnimationController.forward();
  }

  void _initializeGridAnimations(int itemCount) {
    if (itemCount == 0) {
      _gridItemFadeAnimations = [];
      _gridItemSlideAnimations = [];
      return;
    }

    _gridAnimationController?.dispose(); // Dispose previous controller if any
    _gridAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + (itemCount * 100)), // Duration based on item count
    );

    _gridItemFadeAnimations = List.generate(
      itemCount,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _gridAnimationController!,
          curve: Interval(
            (index * 0.05).clamp(0.0, 1.0), // Stagger start time
            ((index * 0.05) + 0.4).clamp(0.0, 1.0), // Stagger end time
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    _gridItemSlideAnimations = List.generate(
      itemCount,
          (index) => Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _gridAnimationController!,
          curve: Interval(
            (index * 0.05).clamp(0.0, 1.0),
            ((index * 0.05) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
    _gridAnimationController!.forward();
  }

  @override
  void dispose() {
    _mainScreenAnimationController.dispose();
    _gridAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: FadeTransition(
          opacity: _appBarFadeAnimation,
          child: Text('Wishlist', style: Theme.of(context).textTheme.headlineMedium),
        ),
        actions: [
          FadeTransition(
            opacity: _appBarFadeAnimation,
            child: TCircularIcon(icon: Iconsax.add, onPressed: () => Get.to(() => const HomeScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FadeTransition(
            opacity: _contentFadeAnimation,
            child: SlideTransition(
              position: _contentSlideAnimation,
              child: Obx(
                    () => FutureBuilder<List<ProductModel>>( // Specify the type for FutureBuilder
                  future: controller.favoriteProducts(),
                  builder: (context, snapshot) {
                    final emptyWidget = TAnimationLoaderWidget(
                      text: 'Whoops! Wishlist is empty.',
                      animation: TImages.pencileAnimation,
                      showAction: true,
                      actionText: 'Let\'s add some',
                      onActionPressed: () => Get.off(() => const NavigationMenu()),
                    );

                    const loader = TVerticalProductShimmer(itemCount: 6);
                    final widget = TCloudHelperFunctions.checkMultiRecordState(
                        snapshot: snapshot, loader: loader, nothingFound: emptyWidget);

                    if (widget != null) return widget;

                    final products = snapshot.data!;
                    // If product list changes, re-initialize grid animations
                    if (_currentProducts.length != products.length || !_areListsEqual(_currentProducts, products)) {
                      _currentProducts = List.from(products); // Update current products
                      _initializeGridAnimations(products.length);
                    }


                    if (_gridItemFadeAnimations.isEmpty && products.isNotEmpty) {
                      // Initial load or if animations were cleared
                      _initializeGridAnimations(products.length);
                    }


                    return TGridLayout(
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          if (index < _gridItemFadeAnimations.length && index < _gridItemSlideAnimations.length) {
                            return FadeTransition(
                              opacity: _gridItemFadeAnimations[index],
                              child: SlideTransition(
                                position: _gridItemSlideAnimations[index],
                                child: TProductCardVertical(product: products[index]),
                              ),
                            );
                          } else {
                            // Fallback if animations aren't ready (should be rare)
                            return TProductCardVertical(product: products[index]);
                          }
                        });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to compare lists of products (simplified check)
  bool _areListsEqual(List<ProductModel> list1, List<ProductModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].id != list2[i].id) return false; // Compare by ID or a unique property
    }
    return true;
  }
}