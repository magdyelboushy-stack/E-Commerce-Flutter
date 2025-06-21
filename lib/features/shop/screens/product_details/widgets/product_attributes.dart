import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:t_store/common/widgets/texts/product_price_text.dart';
import 'package:t_store/common/widgets/texts/product_title.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/variation_controller.dart';
import '../../../models/product_model.dart';


class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VariationController>();
    final dark = THelperFunctions.isDarkMode(context);

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          if(controller.selectedVariation.value.id.isNotEmpty)
          /// --- Selected Attribute Pricing And Description
          TRoundedContainer(
            backgroundColor: dark ? TColors.darkGrey : TColors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title Price
                Row(
                  children: [
                    const TSectionHeading(title: 'Variation', showActionButton: false),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Column(
                      children: [
                        Row(
                          children: [
                            const TProductTitleText(title: 'Price :', smallSize: true),
                            /// Actual Price
                            if(controller.selectedVariation.value.salePrice > 0)
                            Text(
                              '\$${controller.selectedVariation.value.price}',
                              style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
      
                            /// Sale Price
                            TProductPriceText(price: double.tryParse(controller.getVariationPrice()) ?? 0),
                          ],
                        ),
                        /// Stock
                        Row(
                          children: [
                            const TProductTitleText(title: 'Stock : ', smallSize: true),
                            Text(controller.variationStockStatus.value, style: Theme.of(context).textTheme.titleMedium),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
      
                /// Variation Description
                 TProductTitleText(title: controller.selectedVariation.value.description ?? '', smallSize: true, maxLines: 4,),
              ],
            ),
          ),
      
          const SizedBox(height: TSizes.spaceBtwItems),
      
          /// --- Attributes
          /// --- Attributes
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.productAttributes!
                .map((attribute) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TSectionHeading(title: attribute.name ?? '', showActionButton: false),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    children: attribute.values!.map((attributeValue) {
                      final isSelected = controller.selectedAttributes[attribute.name] == attributeValue;
                      final available = controller
                          .getAttributesAvailabilityInVariation(product.productVariations!, attribute.name!)!
                          .contains(attributeValue);
                  
                      return TChoiceChip(
                        text: attributeValue,
                        selected: isSelected,
                        onSelected: available
                            ? (selected) {
                          if (selected && available) {
                            controller.onAttributeSelected(product, attribute.name ?? '', attributeValue);
                          }
                        }
                            : null,
                      ); // TChoiceChip
                    }).toList(),
                  ),
                ) // Wrap
              ],
            )) // Column
                .toList(),
          ) // Column // Column
        ],
      ),
    );
  }
}
