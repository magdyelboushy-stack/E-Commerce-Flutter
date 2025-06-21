import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edge_widget.dart';
import '../../../../../common/widgets/icon/t_circular_icon.dart';
import '../../../../../common/widgets/images/t_rounded_image.dart';
import '../../../../../common/widgets/products.cart/favourite_icon/favourite_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/product/images_controller.dart';
import '../../../models/product_model.dart';

class TProductImageSlider extends StatelessWidget {
  final ProductModel product;

  const TProductImageSlider({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.find<ImagesController>();

    // Initialize images and selected image once
    controller.setProduct(product);

    final images = controller.getAllProductImages(product);

    return TCurvedEdgeWidget(
      child: Container(
        color: dark ? TColors.darkerGrey : TColors.light,
        child: Stack(
          children: [
            // Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(TSizes.productImageRadius * 2),
                child: Center(child: Obx(
                        () {
                    final image = controller.selectedProductImage.value;
                    return GestureDetector(
                      onTap: () => controller.showEnlargedImage(image),
                      child: GestureDetector(
                        onTap: ()=> controller.showEnlargedImage(image),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          progressIndicatorBuilder: (_, __, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress, color: TColors.primary,),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Image Slider (thumbnails)
            Positioned(
              right: 0,
              bottom: 30,
              left: TSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(() {
                    final imageSelected = controller.selectedProductImage.value == images[index];
                    return GestureDetector(
                      onTap: () => controller.selectedProductImage.value = images[index],
                      child: TRoundedImage(
                        width: 80,
                        isNetworkImage: true,
                        backgroundColor: dark ? TColors.dark : TColors.white,
                        padding: const EdgeInsets.all(TSizes.sm),
                        imageUrl: images[index],
                        onPressed: () => controller.selectedProductImage.value = images[index],
                        border: Border.all(
                          color: imageSelected ? TColors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Appbar Icons (Back & Heart)
             TAppBar(
              showBackArrow: true,
              actions: [TFavouriteIcon(productId: product.id,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
