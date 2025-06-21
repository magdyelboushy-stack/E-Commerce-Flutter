import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/utils/constants/enums.dart'; // Ensure correct path

import '../../../../common/widgets/list_tiles/payment_titled.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/paymet_method_model.dart'; // Ensure correct path

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  // Variable to store the selected payment method, initialized with a default
  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;

  @override
  void onInit() {
    // Set the default payment method when the controller is initialized
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Paypal', image: TImages.paypal);
    super.onInit();
  }

  // Function to display the BottomSheet for selecting a payment method
  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.lg), // Corrected padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwSections),
              // List of payment methods
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Paypal', image: TImages.paypal)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Google Pay', image: TImages.googlePay)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Apple Pay', image: TImages.applePay)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'VISA', image: TImages.visa)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Master Card', image: TImages.masterCard)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Paytm', image: TImages.paytm)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Paystack', image: TImages.paystack)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              TPaymentTitle(paymentMethod: PaymentMethodModel(name: 'Credit Card', image: TImages.creditCard)),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
            ],
          ), // Column
        ), // Container
      ), // SingleChildScrollView
    );
  }
}