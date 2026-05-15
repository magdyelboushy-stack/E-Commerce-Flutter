import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart'; // Redundant
import 'package:iconsax/iconsax.dart'; // Not directly used in this snippet but likely in TCartItems
import 'package:t_store/common/widgets/appbar/appbar.dart';
// Other imports from your original file...
import 'package:t_store/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:t_store/utils/helpers/helper_functions.dart'; // For isDarkMode if needed elsewhere
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/loaders/animation_loader.dart';
import '../../controllers/product/cart_controller.dart';
import '../checkout/checkout.dart';

// Convert CartScreen to a StatefulWidget
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _mainScreenAnimationController;
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _checkoutButtonSlideAnimation;
  late Animation<double> _checkoutButtonFadeAnimation;

  // For staggered cart items animation (if TCartItems contains multiple items)
  // This part assumes TCartItems will handle its internal item animations
  // or you would pass an animation controller down to it.
  // For simplicity here, we'll animate TCartItems as a whole block first.

  final controller = CartController.instance;

  @override
  void initState() {
    super.initState();

    _mainScreenAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // General content animation (for empty state or the TCartItems block)
    _contentSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeIn)),
    );

    // Checkout button animation
    _checkoutButtonSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic)),
    );
    _checkoutButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _mainScreenAnimationController.forward();

    // Listen to cart item changes to potentially restart animations if needed
    // controller.cartItems.listen((_) {
    //   _mainScreenAnimationController.reset();
    //   _mainScreenAnimationController.forward();
    // });
    // Note: Automatically restarting all animations on every cart change might be jarring.
    // Consider more specific animations for item addition/removal within TCartItems itself.
  }

  @override
  void dispose() {
    _mainScreenAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Controller is already a field
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: FadeTransition(
          opacity: _appBarFadeAnimation,
          child: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
      body: Obx(() {
        final emptyWidget = TAnimationLoaderWidget(
          text: 'Whoops! Cart is EMPTY.',
          animation: TImages.cartAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        Widget content;
        if (controller.cartItems.isEmpty) {
          content = emptyWidget;
        } else {
          // If TCartItems has its own internal staggered animation,
          // you might pass a separate AnimationController to it.
          // For now, TCartItems as a block.
          content = SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TCartItems(), // Consider adding animation within TCartItems
            ),
          );
        }

        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: SlideTransition(
            position: _contentSlideAnimation,
            child: content,
          ),
        );
      }),
      bottomNavigationBar: Obx(() => controller.cartItems.isEmpty
          ? const SizedBox.shrink() // Use shrink to take no space
          : FadeTransition(
        opacity: _checkoutButtonFadeAnimation,
        child: SlideTransition(
          position: _checkoutButtonSlideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: ElevatedButton(
              onPressed: () => Get.to(() => const CheckoutScreen()),
              // The Obx for the text inside the button is fine for dynamic price updates
              child: Obx(() => Text('Checkout \$${controller.totalCartPrice.value}')),
            ),
          ),
        ),
      )),
    );
  }
}

// Consider enhancing TCartItems to animate its children:
// class TCartItems extends StatefulWidget { // If you want to animate items internally
//   const TCartItems({super.key});
//
//   @override
//   State<TCartItems> createState() => _TCartItemsState();
// }
//
// class _TCartItemsState extends State<TCartItems> with SingleTickerProviderStateMixin {
//   late AnimationController _itemsAnimationController;
//   List<Animation<double>> _itemFadeAnimations = [];
//   // ... and slide animations
//
//   final CartController controller = CartController.instance;
//
//   @override
//   void initState() {
//     super.initState();
//     _itemsAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500 + controller.cartItems.length * 100));
//     _setupAnimations();
//     controller.cartItems.listen((_) { // Re-setup if items change
//        _itemsAnimationController.reset();
//       _setupAnimations();
//       _itemsAnimationController.forward();
//     });
//     _itemsAnimationController.forward();
//   }
//
//   void _setupAnimations() {
//     _itemFadeAnimations = List.generate(controller.cartItems.length, (index) =>
//       Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//         parent: _itemsAnimationController,
//         curve: Interval((0.2 * index).clamp(0.0,1.0), (0.2 * index + 0.5).clamp(0.0,1.0) , curve: Curves.easeIn)
//       ))
//     );
//     // Setup slide animations similarly
//   }
//
//   @override
//   void dispose() {
//     _itemsAnimationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => ListView.separated( // Or Column
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(), // If inside SingleChildScrollView
//         itemCount: controller.cartItems.length,
//         separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwSections),
//         itemBuilder: (context, index) {
//           final item = controller.cartItems[index];
//           if (index < _itemFadeAnimations.length) {
//            return FadeTransition(
//              opacity: _itemFadeAnimations[index],
//              // child: SlideTransition(...)
//              child: TCartItem(cartItem: item), // Your actual cart item widget
//            );
//           }
//           return TCartItem(cartItem: item);
//         },
//       ),
//     );
//   }
// }