import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:t_store/common/widgets/products.cart/product_cart_horizontal.dart';
import 'package:t_store/common/widgets/shimmers/horizontal_product_shimmer.dart';
import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/features/shop/screens/all_products/all_products.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/category_controller.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = CategoryController.instance;
    return Scaffold(
      appBar:  TAppBar(title: Text(category.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Banner
              TRoundedImage(width: double.infinity, imageUrl: TImages.promoBanner1, applyImageRadius: true),
              SizedBox(height: TSizes.spaceBtwSections),

              // Sub-Categories
              FutureBuilder(
                future: controller.getSubCategories(category.id),
                builder: (context, snapshot) {
                  /// Handle loader No Record or Error Message
                  const loader = THorizontalProductShimmer(itemCount: 4,);
                  final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                  if(widget != null) return widget;

                  final subCategories = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: subCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_,index){
                      final subCategory = subCategories[index];
                      return FutureBuilder(
                        future: controller.getCategoryProducts(categoryId: subCategory.id,),
                        builder: (context, snapshot) {
                          /// Handle loader No Record or Error Message
                          final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                          if(widget != null) return widget;

                          /// Record found
                          final products = snapshot.data!;

                          return Column(
                            children: [
                              /// Heading
                              TSectionHeading(
                                title: subCategory.name,
                                onPressed: () => Get.to(
                                 () => AllProducts(
                                   title: subCategory.name,
                                   futureMethod: controller.getCategoryProducts(categoryId: subCategory.id,limit: -1)
                                 ),
                                ),
                              ),
                              SizedBox(height: TSizes.spaceBtwItems /2),
                          
                              SizedBox(
                                height: 120,
                                child: ListView.separated(
                                  itemCount: products.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context,index) => const SizedBox(width: TSizes.spaceBtwItems),
                                  itemBuilder: (context,index)=>  TProductCardHorizontal(product: products[index]),
                                ),
                              ),
                              const SizedBox(height: TSizes.spaceBtwSections),
                            ],
                          );
                        }
                      );
                    },
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}