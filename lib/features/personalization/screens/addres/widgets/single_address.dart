import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/personalization/controllers/address_controller.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/address/address_model.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.address,
    required this.onTap
  });

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(() {
      final selectedAddressId = controller.selectedAddress.value.id;
      final selectedAddress = selectedAddressId == address.id;
        return  InkWell(
        onTap: onTap,
        child: TRoundedContainer(
          showBorder: true,
          padding: const EdgeInsets.all(TSizes.md),
          width: double.infinity,
          backgroundColor: selectedAddress ? TColors.primary.withOpacity(0.5):Colors.transparent,
          borderColor: selectedAddress
            ? Colors.transparent
              :dark
                ? TColors.darkGrey
                :TColors.grey,
          margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  selectedAddress ? Iconsax.tick_circle5 : null,
                  color: selectedAddress
                      ? dark
                      ? TColors.light
                      : TColors.dark
                      : null,
                ),
              ), // Positioned
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ), // Text
                  const SizedBox(height: TSizes.sm / 2),
                   Text(address.formattedPhoneNumber, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: TSizes.sm / 2),
                   Text(address.toString(), softWrap: true,),
                ],
              ), // Column
            ],
          ), // Stack
        
        ),
      );
      },
    );
  }
}
