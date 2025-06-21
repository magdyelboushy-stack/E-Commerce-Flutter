import 'package:get/get.dart';
import '../data/repositories/product/product_repository.dart';
import '../features/personalization/controllers/address_controller.dart';
import '../features/shop/controllers/product/checkout_controller.dart';
import '../features/shop/controllers/product/images_controller.dart';
import '../utils/helpers/network_manager.dart';

import '../features/shop/controllers/product/product_controller.dart';

import '../features/shop/controllers/product/variation_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());

    // Repository & Controllers
    Get.put(ProductRepository());
    Get.put(ProductController());
    Get.put(ImagesController());

    // تسجيل الـ VariationController هنا
    Get.put(VariationController());
    Get.put(AddressController());
    Get.put(CheckoutController());
  }
}


