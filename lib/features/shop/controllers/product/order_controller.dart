import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/order/order_repository.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';


import '../../../personalization/controllers/address_controller.dart';
import '../../models/order_model.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';
class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  // Variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());

  // Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      print('Error in OrderController.fetchUserOrders: $e'); // <--- إضافة هذا السطر
      TLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }


  // Add methods for order processing
  void processOrder(double totalAmount) async {
    /// Start Loader
    TFullScreenLoader.openLoadingDialog('Processing your order', TImages.pencileAnimation);

    try {
      // Get user authentication Id
      final userId = AuthenticationRepository.instance.authUser.uid;
      if (userId.isEmpty) return;

      // Add Details
      final order = OrderModel(
        /// Generate a unique ID for the order
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        address: addressController.selectedAddress.value,
        // Set Date as needed
        deliveryDate: DateTime.now(),
        items: cartController.cartItems.toList(),
      );
      // save the order to firestore
      await orderRepository.saveOrder(order,userId );

      // Update the cart
      cartController.clearCart();

      // Show Success Message
      Get.off(() => SuccessScreen(
        image: TImages.cartAnimation,
        title: 'Payment Successful',
        subTitle: 'Your Item will be shipped soon',
        onPressed: () => Get.offAll(() => const NavigationMenu()),
      ));
    } catch (e) {
      print('Error in OrderController.processOrder: $e'); // <--- إضافة هذا السطر
      TLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
  }
}