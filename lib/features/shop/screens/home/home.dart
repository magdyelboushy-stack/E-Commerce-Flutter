import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart'; // This import is often redundant when 'package:get/get.dart' is already present
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
// Remove the duplicated and incomplete import below:
// import '../../../../utils/constants/s
import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/izes.dart'; // This line was also incomplete and duplicated
import '../../controllers/product/product_controller.dart';
import '../all_products/all_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
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
                        const TSectionHeading(title: 'Popular Categories', showActionButton: false, textColor: Colors.white,),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        /// Categories
                        const THomeCategories(), // Added const as THomeCategories is likely a StatelessWidget
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections), // Added const
                ],
              ),
            ),
            /// Body
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  /// ---- Promo Slider
                  const TPromoSlider(),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  /// --- Heading
                  // Fix: Missing closing parenthesis for onPressed callback and closing parenthesis for TSectionHeading
                  TSectionHeading(
                      title: 'Popular Products',
                      onPressed: () => Get.to(
                        ()=>  AllProducts(
                          title: 'Popular Products',
                          futureMethod: controller.fetchAllFeaturedProducts(),
                          )
                      )
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems,),

                  /// ----- Popular ----- ///
                  Obx((){
                    if(controller.isLoading.value) return const TVerticalProductShimmer();

                    if(controller.featuredProducts.isEmpty){
                      return Center(child: Text('No Data Found',style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return TGridLayout(
                        itemCount: controller.featuredProducts.length,
                        itemBuilder: (_,index)=>  TProductCardVertical(product: controller.featuredProducts[index],)
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}