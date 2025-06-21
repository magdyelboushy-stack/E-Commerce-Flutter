import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../common/widgets/products.cart/cart/add_remove_button.dart';
import '../../../../../common/widgets/products.cart/cart/cart_item.dart';
import '../../../../../common/widgets/texts/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/cart_controller.dart';

class TCartItems extends StatelessWidget {
  const TCartItems({
    super.key, this.showAddRemoveButton=true,
  });

  final bool showAddRemoveButton;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return Obx(
          () =>  ListView.separated(
        shrinkWrap: true,
        itemCount: cartController.cartItems.length,
        separatorBuilder: (_, __) => SizedBox(height: TSizes.spaceBtwSections),
        itemBuilder: (_, index) => Obx(() {
          final item = cartController.cartItems[index];
          return Column(
            children: [
              /// Cart Item
              TCartItem(cartItem: item),
              if(showAddRemoveButton) const SizedBox(height: TSizes.spaceBtwItems),

              /// Add Remove Button Row with total Price
              if(showAddRemoveButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /// Extra Space
                        SizedBox(width: 70),

                        /// Add Remove Buttons
                        TProductQuantityWithAddRemoveButton(
                          quantity: item.quantity,
                          add: () => cartController.addOneToCart(item),
                          remove: () => cartController.removeOneFromCart(item),
                        ),
                      ],
                    ),
                  ],
                ),
              /// -- Product total price
              TProductPriceText(price: item.price * item.quantity), // <--- CHANGE IS HERE
            ],
          );},
        ),
      ),
    );
  }
}