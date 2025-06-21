import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product_model.dart';
import '../../../../utils/constants/sizes.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  /// Variables
  RxString selectedProductImage = ''.obs;

  /// Initialize with product images and set the selected image once
  void setProduct(ProductModel product) {
    final images = getAllProductImages(product);
    if (images.isNotEmpty) {
      selectedProductImage.value = images.first;
    }
  }

  /// -- Get All Images from product and Variations
  List<String> getAllProductImages(ProductModel product) {
    // Use Set to add unique images
    final images = <String>{};

    // Load thumbnail image if exists
    if (product.thumbnail != null && product.thumbnail!.isNotEmpty) {
      images.add(product.thumbnail!);
    }

    // Get all images from product.images if available
    if (product.images != null && product.images!.isNotEmpty) {
      images.addAll(product.images!);
    }

    // Get all images from product variations if available
    if (product.productVariations != null &&
        product.productVariations!.isNotEmpty) {
      images.addAll(
        product.productVariations!
            .map((variation) => variation.image)
            .whereType<String>(),
      );
    }

    return images.toList();
  }

  /// Show Image Popup - Fullscreen Dialog
  void showEnlargedImage(String image) {
    Get.to(
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TSizes.defaultSpace * 2,
                horizontal: TSizes.defaultSpace,
              ),
              child: CachedNetworkImage(imageUrl: image),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
