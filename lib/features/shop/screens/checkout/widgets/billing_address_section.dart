import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/controllers/address_controller.dart';


class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TSectionHeading(
          title: 'Shipping Address', buttonTitle: 'Change', onPressed: () => addressController.selectNewAddressPopup(context),),
        addressController.selectedAddress.value.id.isNotEmpty
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coding with T',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.grey, size: 16),
                const SizedBox(width: TSizes.spaceBtwItems),
                Text(
                  '+92-317-8059525',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ), // Row
            const SizedBox(height: TSizes.spaceBtwItems / 2),
            Row(
              children: [
                const Icon(Icons.location_history, color: Colors.grey, size: 16),
                const SizedBox(width: TSizes.spaceBtwItems),
                Expanded(
                  child: Text(
                    'South Liana, Maine 87695, USA',
                    style: Theme.of(context).textTheme.bodyMedium,
                    softWrap: true,
                  ),
                ),
              ],
            ), // Row
          ],
        ):Text('Select Address', style: Theme.of(context).textTheme.bodyMedium),
      ],
    ); // Column// Column
  }
}