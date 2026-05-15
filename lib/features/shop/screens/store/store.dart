import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/appbar/tabbar.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products.cart/cart/cart_menu_icon.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/controllers/brand_controller.dart';
import 'package:t_store/features/shop/screens/store/widgets/category_tab.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import '../../../../common/widgets/brands/brand_card.dart';
import '../../../../common/widgets/shimmers/brands_simmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/category_controller.dart';
import '../brand/all_brands.dart';
import '../brand/brand_products.dart';

// Convert StoreScreen to a StatefulWidget
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _appBarTitleFadeAnimation;
  late Animation<Offset> _searchBarSlideAnimation;
  late Animation<double> _searchBarFadeAnimation;
  late Animation<double> _featuredBrandsHeadingFadeAnimation;
  late Animation<Offset> _brandsGridSlideAnimation;
  late Animation<double> _brandsGridFadeAnimation;
  late Animation<Offset> _tabBarSlideAnimation;
  late Animation<double> _tabBarFadeAnimation;

  // Initialize controllers here
  final BrandController brandController = Get.put(BrandController());
  // Access CategoryController instance. Ensure it's initialized appropriately elsewhere if it's a singleton.
  // If it's always freshly put, then Get.put(CategoryController()) might be needed.
  // For this example, assuming CategoryController.instance is valid.
  final categories = CategoryController.instance.featuredCategories;


  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800), // Total duration
    );

    // AppBar Title Fade Animation
    _appBarTitleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );

    // Search Bar Animation (Slides from top, fades in)
    _searchBarSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic)),
    );
    _searchBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.1, 0.5, curve: Curves.easeIn)),
    );

    // Featured Brands Heading Animation (Fades in)
    _featuredBrandsHeadingFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );

    // Brands Grid Animation (Slides from bottom, fades in)
    _brandsGridSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic)),
    );
    _brandsGridFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.4, 0.8, curve: Curves.easeIn)),
    );

    // TabBar Animation (Slides from bottom of SliverAppBar, fades in)
    _tabBarSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
        CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic))
    );
    _tabBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: const Interval(0.6, 1.0, curve: Curves.easeIn))
    );


    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Access controllers (already initialized in fields or initState)
    // final brandController = this.brandController; // or just use brandController directly
    // final categories = this.categories;       // or just use categories directly

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: TAppBar(
          title: FadeTransition(
            opacity: _appBarTitleFadeAnimation,
            child: Text(
              'Store',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          actions: [
            FadeTransition( // Also fade in the cart icon
              opacity: _appBarTitleFadeAnimation, // Reuse or create a new animation
              child: TCartCounterIcon(iconColor: null),
            )
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 440, // Adjust if animations change perceived height
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: TSizes.spaceBtwItems),
                      FadeTransition(
                        opacity: _searchBarFadeAnimation,
                        child: SlideTransition(
                          position: _searchBarSlideAnimation,
                          child: const TSearchContainer(
                            text: 'Search in Store',
                            showBorder: true,
                            showBackground: false,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),
                      FadeTransition(
                        opacity: _featuredBrandsHeadingFadeAnimation,
                        child: TSectionHeading(
                          title: 'Featured Brands',
                          onPressed: () => Get.to(() => const AllBrandsScreen()),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),
                      FadeTransition(
                        opacity: _brandsGridFadeAnimation,
                        child: SlideTransition(
                          position: _brandsGridSlideAnimation,
                          child: Obx(() {
                            if (brandController.isLoading.value) return const TBrandsShimmer();
                            if (brandController.featuredBrands.isEmpty) {
                              return Center(
                                  child: Text('No Data Found',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .apply(color: Colors.white)));
                            }
                            return TGridLayout(
                              itemCount: brandController.featuredBrands.length,
                              mainAxisExtent: 80,
                              itemBuilder: (_, index) {
                                final brand = brandController.featuredBrands[index];
                                return TBrandCard(
                                    showBorder: true,
                                    brand: brand,
                                    onTap: () => Get.to(() => BrandProducts(brand: brand)));
                              },
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize( // Required for animating SliverAppBar bottom
                  preferredSize: const Size.fromHeight(kToolbarHeight), // Standard TabBar height
                  child: FadeTransition(
                    opacity: _tabBarFadeAnimation,
                    child: SlideTransition(
                      position: _tabBarSlideAnimation,
                      child: TTabBar(
                        tabs: categories
                            .map((category) => Tab(child: Text(category.name)))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
              children: categories
                  .map((category) => TCategoryTab(category: category))
                  .toList()),
        ),
      ),
    );
  }
}