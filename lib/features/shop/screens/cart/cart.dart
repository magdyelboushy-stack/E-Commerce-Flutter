import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:t_store/common/widgets/icon/t_circular_icon.dart';
import 'package:t_store/common/widgets/images/t_rounded_image.dart';
import 'package:t_store/common/widgets/texts/product_price_text.dart';
import 'package:t_store/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import '../../../../common/widgets/products.cart/cart/add_remove_button.dart';
import '../../../../common/widgets/products.cart/cart/cart_item.dart';
import '../../../../common/widgets/texts/product_title.dart';
import '../../../../common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/loaders/animation_loader.dart';
import '../../controllers/product/cart_controller.dart';
import '../checkout/checkout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      appBar: TAppBar(showBackArrow: true,title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall)),
      body: Obx(
            () {
          // Nothing Found Widget
          final emptyWidget = TAnimationLoaderWidget(
            text: 'Whoops! Cart is EMPTY.',
            animation: TImages.cartAnimation,
            showAction: true,
            actionText: 'Let\'s fill it',
            onActionPressed: () => Get.off(() => const NavigationMenu()),
          ); // TAnimationLoaderWidget

          if (controller.cartItems.isEmpty) {
            return emptyWidget;
          } else {
            return  SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              // -- Items in Cart
              child: TCartItems(),
              ),
            );
          } // Padding
        },
      ), // Obx

      /// Checkout
      bottomNavigationBar: controller.cartItems.isEmpty ? SizedBox() : Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
            onPressed: ()=>Get.to(()=>const CheckoutScreen()),
            child: Obx(() => Text('Checkout \$${controller.totalCartPrice.value}'))),
      ),
    );
  }
}

