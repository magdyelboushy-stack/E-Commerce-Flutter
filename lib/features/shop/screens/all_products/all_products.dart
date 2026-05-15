import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart'; // Redundant
import 'package:iconsax/iconsax.dart'; // Not directly used here, but good practice if sub-widgets might use it
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layouts/grid_layout.dart'; // Used by TSortableProducts
import '../../../../common/widgets/products.cart/product_card_vertical.dart'; // Used by TSortableProducts
import '../../../../common/widgets/products.cart/sortable/sortable_products.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/all_product_controller.dart';
import '../../models/product_model.dart';

// Convert AllProducts to a StatefulWidget
class AllProducts extends StatefulWidget {
  const AllProducts({
    super.key,
    required this.title,
    this.query,
    this.futureMethod,
  });

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> with TickerProviderStateMixin { // Use TickerProviderStateMixin
  late AnimationController _mainScreenAnimationController;
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  // Controller for TSortableProducts item animations
  // This will be passed down to TSortableProducts if it's adapted for animations
  late AnimationController _gridItemsAnimationController;


  final AllProductsController _allProductsController = Get.put(AllProductsController()); // Initialize controller

  @override
  void initState() {
    super.initState();

    _mainScreenAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    _contentSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeIn)),
    );

    // Initialize the grid items controller - its duration might be set dynamically in TSortableProducts
    _gridItemsAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));


    _mainScreenAnimationController.forward();
  }

  @override
  void dispose() {
    _mainScreenAnimationController.dispose();
    _gridItemsAnimationController.dispose(); // Dispose the grid controller as well
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _allProductsController is already a field

    return Scaffold(
      appBar: TAppBar(
        title: FadeTransition(
          opacity: _appBarFadeAnimation,
          child: Text(widget.title), // Access title from widget property
        ),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FadeTransition( // Animate the entire FutureBuilder block
            opacity: _contentFadeAnimation,
            child: SlideTransition(
              position: _contentSlideAnimation,
              child: FutureBuilder<List<ProductModel>>( // Specify type for FutureBuilder
                future: widget.futureMethod ?? _allProductsController.fetchProductsByQuery(widget.query),
                builder: (context, snapshot) {
                  const loader = TVerticalProductShimmer();
                  final responseWidget = TCloudHelperFunctions.checkMultiRecordState(
                    snapshot: snapshot,
                    loader: loader,
                  );

                  if (responseWidget != null) {
                    return responseWidget;
                  }

                  final products = snapshot.data!;
                  // Pass the animation controller to TSortableProducts
                  // TSortableProducts will need to be modified to use this
                  return TSortableProducts(
                    products: products,
                    // Optional: Pass the controller for item animations
                    // itemAnimationController: _gridItemsAnimationController,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}