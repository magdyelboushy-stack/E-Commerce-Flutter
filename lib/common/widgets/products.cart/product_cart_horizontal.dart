import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/shop/models/product_model.dart';

import '../../../features/shop/controllers/product/product_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart'; // تأكد من استيراد هذا الملف لاستخدام TImages.productImagePlaceholder
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../styles/shadows.dart';
import '../custom_shapes/containers/rounded_container.dart';

import '../icon/t_circular_icon.dart';
import '../images/t_rounded_image.dart';
import '../texts/product_price_text.dart';
import '../texts/product_title.dart';
import '../texts/t_brand_title_text_with_verified_icon.dart';
import 'add_to_cart_button.dart';
import 'favourite_icon/favourite_icon.dart';


class TProductCardHorizontal extends StatelessWidget {
  const TProductCardHorizontal({super.key, required this.product,});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final controller = ProductController.instance;
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);

    return Container(
      width: 310,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TSizes.productImageRadius),
        color: dark ? TColors.darkerGrey : TColors.softGrey,
      ), // BoxDecoration
      child: Row(
        children: [
          /// Thumbnail
          TRoundedContainer(
            height: 120,
            padding: const EdgeInsets.all(TSizes.sm),
            backgroundColor: dark ? TColors.dark : TColors.light,
            child: Stack(
              /// --- Thumbnail Image
              children: [
                SizedBox(
                    width: 120,
                    height: 120,
                    child: TRoundedImage(
                      imageUrl: product.thumbnail ?? TImages.productImagePlaceholder, // تم تعديل هذا السطر فقط
                      applyImageRadius: true,
                      isNetworkImage: true,
                    )
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
                    child: Text('$salePercentage%', style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black)),
                  ),
                ),

                /// --- Favorite Button
                Positioned(
                  top: 0,
                  right: 0,
                  child: TFavouriteIcon(productId: product.id,),
                ),
              ],
            ), // Closing Stack
          ),

          ///Details
          SizedBox(
            width: 172,
            child:  Padding(
              padding: const EdgeInsets.only(top: TSizes.sm, left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TProductTitleText(title: product.title, smallSize: true, ),
                      SizedBox(height: TSizes.spaceBtwItems / 2),
                      TBrandTitleWithVerifiedIcon(title: product.brand!.name),
                    ],
                  ),
                  const Spacer(),
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
                  ), // Row
                ],
              ),
            ),
          )
        ],
      ), // Closing Row
    ); // Closing Container
  }
}