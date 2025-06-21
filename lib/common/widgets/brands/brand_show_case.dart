// brand_show_case.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:t_store/common/widgets/shimmers/shimmer.dart';
import 'package:t_store/features/shop/models/brand_model.dart';
import 'package:t_store/features/shop/screens/brand/brand_products.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/rounded_container.dart';
import 'brand_card.dart';

class TBrandShowcase extends StatelessWidget {
  const TBrandShowcase({
    super.key,
    required this.images,
    required this.brand, // BrandModel هنا مطلوب
  });

  final List<String> images;
  final BrandModel brand; // تعريف خاصية brand

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: TRoundedContainer(
        showBorder: true,
        borderColor: TColors.darkGrey,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(TSizes.md),
        margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
        child: Column(
          children: [
            /// Brand with Products Count
            TBrandCard(showBorder: false, brand: brand), // تمرير البراند إلى TBrandCard
            const SizedBox(height: TSizes.spaceBtwItems),
      
            /// Brand Top 3 Product
            Row(children: images.map((image) => brandTopProductImageWidget(image, context)).toList())
          ],
        ),
      ),
    );
  }
}

Widget brandTopProductImageWidget(String image, BuildContext context) {
  return Expanded(
    child: TRoundedContainer(
      height: 100,
      backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkGrey : TColors.light,
      margin: const EdgeInsets.only(right: TSizes.sm),
      padding: const EdgeInsets.all(TSizes.md),
      child: CachedNetworkImage(
        fit: BoxFit.contain,
        imageUrl: image,
        progressIndicatorBuilder: (context,url,downloadProgress) => const TShimmerEffect(width: 100, height: 100),
        errorWidget: (context, url,error)=> const Icon(Icons.error),
      ),
    ),
  );
}