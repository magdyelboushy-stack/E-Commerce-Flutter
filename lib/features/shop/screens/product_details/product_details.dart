import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import 'package:t_store/common/widgets/icon/t_circular_icon.dart';
import 'package:t_store/common/widgets/images/t_rounded_image.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:t_store/features/shop/screens/product_details/widgets/rating_share_widget.dart';
import 'package:t_store/features/shop/screens/product_reviews/product_reviews.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';



import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TBottomAddToCart(product: product), // قم بتمرير الـ product
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 1 Product Image slider
            TProductImageSlider(product: product,),

            /// 2 - Product Details
            Padding(
              padding: EdgeInsets.only(right: TSizes.defaultSpace,left: TSizes.defaultSpace,bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  /// -- Rating Share
                  TRatingAndShare(),
                  /// Price,Title,Stock
                  TProductMetaData(product: product),
                  /// Attributes
                  if(product.productType == ProductType.variable.toString())  TProductAttributes(product: product),
                  if(product.productType == ProductType.variable.toString()) const SizedBox(height: TSizes.spaceBtwSections,),

                  /// Checkout Button
                  SizedBox(width: double.infinity,child: ElevatedButton(onPressed: (){}, child: Text('Checkout'))),
                  const SizedBox(height: TSizes.spaceBtwSections,),

                  /// Description
                  const TSectionHeading(title: 'Description',showActionButton: false,),
                  const SizedBox(height: TSizes.spaceBtwItems,),

                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more',
                    trimExpandedText: ' Less',
                    moreStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w800),
                  ),
                  /// Reviews
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  Column(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    children: [
                      const TSectionHeading(title: 'Reviews(199)',showActionButton: false),
                      IconButton(icon:const Icon(Iconsax.arrow_right_3,size: 18,),onPressed: ()=> Get.to(()=>const ProductReviewsScreen()),)
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


