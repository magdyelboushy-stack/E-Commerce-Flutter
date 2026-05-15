import 'package:flutter/material.dart';
import 'package:get/get.dart'; // تأكد من استيراد Get
import 'package:t_store/common/widgets/texts/section_heading.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/features/personalization/controllers/address_controller.dart'; // تأكد من استيراد الـ Controller

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
          title: 'Shipping Address',
          buttonTitle: 'Change',
          onPressed: () => addressController.selectNewAddressPopup(context),
        ),
        const SizedBox(height: TSizes.spaceBtwItems), // مسافة صغيرة بعد العنوان

        // !!! هذا هو الجزء الذي تم تعديله !!!
        Obx(
              () {
            if (addressController.selectedAddress.value.id.isEmpty) {
              return Text(
                'Select Address',
                style: Theme.of(context).textTheme.bodyMedium,
              );
            } else {
              final selectedAddress = addressController.selectedAddress.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAddress.name, // يعرض اسم المستخدم من العنوان المختار
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.grey, size: 16),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Text(
                        selectedAddress.phoneNumber, // يعرض رقم الهاتف
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      const Icon(Icons.location_history, color: Colors.grey, size: 16),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Expanded(
                        child: Text(
                          // يعرض العنوان الكامل (الشارع، المدينة، الدولة، الرمز البريدي)
                          '${selectedAddress.street}, ${selectedAddress.city}, ${selectedAddress.state}, ${selectedAddress.postalCode}, ${selectedAddress.country}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}