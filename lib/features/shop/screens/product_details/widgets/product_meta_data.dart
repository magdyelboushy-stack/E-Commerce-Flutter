import 'package:flutter/material.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/icon/t_circular_icon.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';
import 'package:t_store/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/constants/enums.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../common/widgets/texts/product_title.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/product_controller.dart';

import 'package:get/get.dart';

import '../../../controllers/product/variation_controller.dart';

class TProductMetaData extends StatelessWidget {
  final ProductModel product;

  const TProductMetaData({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final controller = ProductController.instance;
    final darkMode = THelperFunctions.isDarkMode(context);

    final variationController = Get.find<VariationController>();

    return Obx(() {
      final isVariable = product.productType == ProductType.variable.toString();
      final selectedVariation = variationController.selectedVariation.value;

      final price = isVariable && selectedVariation.id.isNotEmpty ? selectedVariation.price : product.price;
      final salePrice = isVariable && selectedVariation.id.isNotEmpty ? selectedVariation.salePrice : product.salePrice;
      final stock = isVariable && selectedVariation.id.isNotEmpty ? selectedVariation.stock : product.stock;

      final salePercentageValue = controller.calculateSalePercentage(price, salePrice) ?? 0;

      int salePercentage = 0;
      if (salePercentageValue is String) {
        salePercentage = int.tryParse(salePercentageValue) ?? 0;
      } else if (salePercentageValue is double) {
        salePercentage = salePercentageValue.toInt();
      } else if (salePercentageValue is int) {
        salePercentage = salePercentageValue;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (salePercentage > 0)
                TRoundedContainer(
                  radius: TSizes.sm,
                  backgroundColor: TColors.secondary.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                  child: Text(
                    '$salePercentage%',
                    style: Theme.of(context).textTheme.labelLarge!.apply(color: TColors.black),
                  ),
                ),
              if (salePercentage > 0) const SizedBox(width: TSizes.spaceBtwItems),
              if (salePercentage > 0)
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),
                ),
              if (salePercentage > 0) const SizedBox(width: TSizes.spaceBtwItems),
              TProductPriceText(price: salePrice, isLarge: true),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 1.5),
          TProductTitleText(title: product.title),
          const SizedBox(height: TSizes.spaceBtwItems / 1.5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TProductTitleText(title: 'Status'),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                controller.getProductStockStatus(stock),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 1.5),
          Row(
            children: [
              TCircularImage(
                image: product.brand?.image ?? '',
                width: 32,
                height: 32,
                overlayColor: darkMode ? TColors.white : TColors.black,
              ),
              TBrandTitleWithVerifiedIcon(
                title: product.brand != null ? product.brand!.name : '',
                brandTextSize: TextSizes.medium,
              ),
            ],
          ),
        ],
      );
    });
  }
}
