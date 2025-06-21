import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get for navigation
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

// Remove the duplicated and incomplete import below:
// import '../../../../utils/constan
import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/sizes.dart'; // This line was duplicated and incomplete
import '../../controllers/category_controller.dart';

import '../brand/all_brands.dart';
import '../brand/brand_products.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// --- Get featured categories from the controller
    final brandController = Get.put(BrandController());
    final categories = CategoryController.instance.featuredCategories;
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        /// --- Appbar
        appBar: TAppBar(
          title: Text(
            'Store',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [TCartCounterIcon( iconColor: null)],
        ),
        body: NestedScrollView(
          /// -- Header
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor:
                    THelperFunctions.isDarkMode(context)
                        ? TColors.black
                        : TColors.white,
                expandedHeight: 440,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(
                    TSizes.defaultSpace,
                  ), // Added const
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// --- Search bar
                      const SizedBox(height: TSizes.spaceBtwItems),
                      const TSearchContainer(
                        text: 'Search in Store',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      /// --- Featured Brands
                      // Fix: Missing closing parenthesis for onPressed callback and closing parenthesis for TSectionHeading
                      TSectionHeading(
                        title: 'Featured Brands',
                        onPressed: () => Get.to(() => const AllBrandsScreen()),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems / 1.5),

                      /// -- Brands GRID
                     Obx(
                        () {
                          if (brandController.isLoading.value)  return TBrandsShimmer();

                          if(brandController.featuredBrands.isEmpty){
                            return Center(
                              child: Text('No Data Found',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
                          }
                      return TGridLayout(
                        itemCount: brandController.featuredBrands.length,
                        mainAxisExtent: 80,
                        itemBuilder: (_, index) {
                          final brand = brandController.featuredBrands[index];
                          // In the Backend Tutorial we will pass the Each Brand & onPress Event also.
                          return  TBrandCard(showBorder: true, brand: brand, onTap: () => Get.to(() =>  BrandProducts(brand: brand,)));
                        },
                      ); // TGridLayout
                    },
                      ), // Obx
                    ],
                  ),
                ),

                /// Tabs ---
                bottom: TTabBar(
                  tabs:
                      categories
                          .map((category) => Tab(child: Text(category.name)))
                          .toList(),
                ),
              ),
            ];
          },

          /// --- Body
          body: TabBarView(children: categories.map((category) => TCategoryTab(category: category)).toList()),
        ),
      ),
    );
  }
}
