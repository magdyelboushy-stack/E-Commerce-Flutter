import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/personalization/controllers/address_controller.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Scaffold(
      appBar: TAppBar(showBackArrow: true, title: Text('Add new Address')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.addressFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller.name,
                  validator: (value) => TValidator.validateEmptyText('Name', value),
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Name'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: (value) => TValidator.validateEmptyText('Phone Number', value), // Changed 'Name' to 'Phone Number' here
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: 'Phone Number'),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.street,
                        validator: (value) => TValidator.validateEmptyText('Street', value),
                        decoration: const InputDecoration(labelText: 'Street', prefixIcon: Icon(Iconsax.building_31)),
                      ), // TextFormField
                    ), // Expanded
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.postalCode,
                        validator: (value) => TValidator.validateEmptyText('Postal Code', value),
                        decoration: const InputDecoration(labelText: 'Postal Code', prefixIcon: Icon(Iconsax.code)),
                      ), // TextFormField
                    ), // Expanded
                  ],
                ),// Row
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.city,
                        validator: (value) => TValidator.validateEmptyText('City', value),
                        expands: false,
                        decoration: const InputDecoration(labelText: 'City', prefixIcon: Icon(Iconsax.building)),
                      ), // TextFormField
                    ), // Expanded
                    const SizedBox(width: TSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.state,
                        validator: (value) => TValidator.validateEmptyText('State', value),
                        expands: false,
                        decoration: const InputDecoration(labelText: 'State', prefixIcon: Icon(Iconsax.activity)),
                      ), // TextFormField
                    ), // Expanded
                  ],
                ),// Row
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.country,
                  validator: (value) => TValidator.validateEmptyText('Country', value),
                  decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Iconsax.global)),
                ),
                const SizedBox(height: TSizes.defaultSpace),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => controller.addNewAddresses(), // Call the method here
                        child: Text('Save')
                    )
                ),
                // Row
              ],
            ),
          ),
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}