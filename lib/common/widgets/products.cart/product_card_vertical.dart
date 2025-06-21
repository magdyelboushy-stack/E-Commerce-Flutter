import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/images/t_rounded_image.dart';
import 'package:t_store/common/widgets/products.cart/favourite_icon/favourite_icon.dart';
import 'package:t_store/common/widgets/texts/product_title.dart';
import 'package:t_store/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:t_store/features/shop/screens/product_details/product_details.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../features/shop/controllers/product/product_controller.dart';
import '../../../features/shop/models/product_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../styles/shadows.dart';
import '../custom_shapes/containers/rounded_container.dart';
import '../icon/t_circular_icon.dart';
import '../texts/product_price_text.dart';
import 'add_to_cart_button.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);

    // طباعة رابط الصورة لمراقبة أي مشاكل
    print('Product thumbnail URL: ${product.thumbnail}');

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: dark ? TColors.darkGrey : TColors.white,
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          boxShadow: [TShadowStyle.verticalProductShadow],
        ),
        child: Column(
          children: [
            /// Thumbnail
            TRoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  /// --- Product Image
                  Center(
                    child: product.thumbnail != null && product.thumbnail!.isNotEmpty
                        ? TRoundedImage(
                      imageUrl: product.thumbnail!,
                      applyImageRadius: true,
                      isNetworkImage: true,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                        : SizedBox(
                      width: 180,
                      height: 180,
                      child: Center(child: Text('No Image')),
                    ),
                  ),


                  /// --- Sale Tag
                  if(salePercentage != null)
                  Positioned(
                    top: 12,
                    left: 0,
                    child: TRoundedContainer(
                      radius: TSizes.sm,
                      backgroundColor: TColors.secondary.withOpacity(0.9),
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs,),
                      child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),),
                    ),
                  ),

                  /// --- Favorite Button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TFavouriteIcon(productId: product.id,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 1.5),

            /// Product Details
            Padding(
              padding: EdgeInsets.only(left: TSizes.sm, right: TSizes.sm),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TProductTitleText(
                      title: product.title,
                      smallSize: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Row(
                      children: [
                        /// Brand Image
                        if (product.brand?.image != null)
                          TRoundedImage(
                            imageUrl: product.brand!.image!,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            isNetworkImage: true,
                          ),
                        const SizedBox(width: TSizes.xs),

                        /// Brand Name with Verified Icon
                        TBrandTitleWithVerifiedIcon(title: product.brand?.name ?? 'No Brand'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// Price and Add to Cart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Price
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: TSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // السعر بعد الخصم (أو السعر العادي لو مفيش خصم)
                        TProductPriceText(
                          price: product.salePrice > 0 ? product.salePrice : product.price,
                        ),


                        const SizedBox(height: 4),

                        // السعر الأصلي مضروب عليه خط لو فيه خصم
                        if (product.salePrice > 0)
                          Text(
                            '${product.price.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                /// Add to Cart Button
                ProductCardAddToCartButton(product:product),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
