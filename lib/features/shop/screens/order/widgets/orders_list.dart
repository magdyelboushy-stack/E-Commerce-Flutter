import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/cloud_helper_functions.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/loaders/animation_loader.dart';
import '../../../controllers/product/order_controller.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());
    final dark = THelperFunctions.isDarkMode(context);
    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (_, snapshot) {
        // Nothing Found Widget
        final emptyWidget = TAnimationLoaderWidget(
          text: 'Whoops! No Orders Yet!',
          animation: TImages.cartAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        /// Helper Function: Handle Loader, No Record, OR ERROR Message
        final response = TCloudHelperFunctions.checkMultiRecordState(
          snapshot: snapshot,
          nothingFound: emptyWidget,
        );
        if (response != null) return response;

        /// Congratulations 🎉 Record found.
        final orders = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          separatorBuilder: (_, __) =>
          const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orders[index];

            return TRoundedContainer(
              showBorder: true,
              backgroundColor:
              THelperFunctions.isDarkMode(context) ? TColors.dark : TColors.light,
              child: Column(
                children: [
                  /// -- Row 1 (Status and Date)
                  Row(
                    children: [
                      /// -- Icon
                      const Icon(Iconsax.ship, size: TSizes.iconMd),
                      const SizedBox(width: TSizes.spaceBtwItems / 2),

                      /// 2 - Status and Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderStatusText,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .apply(color: TColors.primary, fontWeightDelta: 1),
                            ),
                            Text(order.formattedOrderDate,
                                style: Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ),

                      /// 3 Icon (Arrow)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  /// -- Row 2 (Order ID and Shipping Date)
                  Row(
                    children: [
                      /// First part of Row 2 (Order ID)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.tag),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order',
                                      style: Theme.of(context).textTheme.labelMedium),
                                  Text(order.id,
                                      style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Second part of Row 2 (Shipping Date)
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Iconsax.calendar),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Shipping Date',
                                      style: Theme.of(context).textTheme.labelMedium),
                                  Text(order.formattedDeliveryDate,
                                      style: Theme.of(context).textTheme.titleMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}