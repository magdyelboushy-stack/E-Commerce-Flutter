// all_brands.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/utils/constants/sizes.dart';
import '../../../../common/widgets/brands/brand_card.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../models/brand_model.dart';
import 'brand_products.dart';
import '../../controllers/brand_controller.dart'; // استيراد BrandController
import '../../../../common/widgets/shimmers/brands_simmer.dart'; // استيراد BrandsShimmer

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brandController = BrandController.instance;

    return Scaffold(
      appBar: const TAppBar(title: Text('Brand'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              /// Heading
              const TSectionHeading(title: 'Brands', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// -- Brands
          Obx(
                () {
              if (brandController.isLoading.value)  return TBrandsShimmer();

              if(brandController.allBrands.isEmpty){
                return Center(
                    child: Text('No Data Found',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
              }
              return TGridLayout(
                itemCount: brandController.allBrands.length,
                mainAxisExtent: 80,
                itemBuilder: (_, index) {
                  final brand = brandController.allBrands[index];
                  // In the Backend Tutorial we will pass the Each Brand & onPress Event also.
                  return  TBrandCard(
                    showBorder: true,
                    brand: brand,
                    onTap: () => Get.to(() =>  BrandProducts(brand: brand,)),
                  );
                },
              ); // TGridLayout
            },
          ),
            ],
          ),
        ),
      ),
    );
  }
}
