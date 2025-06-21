import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/icon/t_circular_icon.dart';
import 'package:t_store/common/widgets/layouts/grid_layout.dart';
import 'package:t_store/common/widgets/products.cart/product_card_vertical.dart';
import 'package:t_store/common/widgets/shimmers/vertical_product_shimmer.dart';
import 'package:t_store/features/shop/screens/home/home.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';
import 'package:t_store/utils/loaders/animation_loader.dart';

import '../../../../navigation_menu.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/favourite_controller.dart';
import '../../models/product_model.dart';


class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
    return Scaffold(
      appBar: TAppBar(
        title: Text('Wishlist',style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          TCircularIcon(icon: Iconsax.add, onPressed: ()=>Get.to(const HomeScreen())),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),

          child: Obx(
            () => FutureBuilder(
              future: controller.favoriteProducts(),
              builder: (context, snapshot){
            
                final emptyWidget = TAnimationLoaderWidget(
                  text: 'Whoops! Wishlist is empty.',
                  animation: TImages.pencileAnimation,
                  showAction: true,
                  actionText: 'Let\'s add some',
                  onActionPressed: () => Get.off(() => const NavigationMenu()),
                );
            
                const loader = TVerticalProductShimmer(itemCount: 6,);
                final widget = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader,nothingFound: emptyWidget);
                if(widget != null) return widget;
            
                final products = snapshot.data!;
                return TGridLayout(itemCount: products.length, itemBuilder: (_,index) => TProductCardVertical(product:products[index])
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
