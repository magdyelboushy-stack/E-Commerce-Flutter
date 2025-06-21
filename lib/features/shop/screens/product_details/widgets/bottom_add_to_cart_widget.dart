import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

import '../../../../../common/widgets/icon/t_circular_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/cart_controller.dart';
import '../../../models/product_model.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = CartController.instance;

    // تهيئة الكمية عند دخول الشاشة لأول مرة
    // يجب أن تكون هذه الدالة موجودة في CartController وتحدد الكمية بناءً على المنتج
    // أو يمكننا تهيئة الكمية الافتراضية هنا إذا لم تكن موجودة بالفعل في السلة.
    // أفضل طريقة هي أن يتم تهيئة productQuantityInCart في CartController
    // بناءً على المنتج المحدد، أو تكون قيمتها الافتراضية 1.

    // إذا لم يكن هناك منتج في السلة، ابدأ بالكمية 1 لتمكين زر الإضافة.
    // يجب أن يكون هذا جزءًا من منطق CartController.
    // لنفترض أننا نستخدم productQuantityInCart مباشرة بعد التحديث
    // أو يتم إعداده بشكل صحيح عند تحديد المنتج.

    // إذا كانت هذه هي شاشة تفاصيل المنتج، فالكمية الافتراضية التي يريد المستخدم إضافتها عادة ما تكون 1.
    // يمكنك تعيينها في CartController عند تحديد المنتج أو عند فتح شاشة التفاصيل.
    // لنقوم بتحديثها هنا (مع العلم أن الطريقة الأفضل هي من الـ controller نفسه):
    // ولكن الطريقة المثلى هي أن يتم هذا في الـ CartController عند استعراض المنتج.
    // for example: cartController.initializeProductQuantity(product.id);
    //
    // للحظة، سنضمن أن الكمية لا تبدأ من الصفر إذا لم يكن المنتج في السلة بالفعل
    // وهذا يجب أن يتم في Controller (CartController)
    // دعنا نفترض أن updateAlreadyAddedProductCount تقوم بذلك.

    // بما أنك قمت بـ updateAlreadyAddedProductCount(product)،
    // إذا كان المنتج ليس في السلة، فستظل productQuantityInCart.value = 0.
    // الحل هنا هو السماح للمستخدم بإضافة منتج واحد على الأقل عندما يفتح شاشة المنتج.

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
        vertical: TSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
                children: [
                  TCircularIcon(
                    icon: Iconsax.minus,
                    backgroundColor: TColors.darkGrey,
                    width: 40,
                    height: 40,
                    color: TColors.white,
                    // زر الطرح يصبح غير فعال إذا كانت الكمية 1 أو أقل
                    onPressed: controller.productQuantityInCart.value <= 1
                        ? null
                        : () => controller.productQuantityInCart.value -= 1,
                  ), // TCircularIcon
                  SizedBox(width: TSizes.spaceBtwItems),
                  Text(controller.productQuantityInCart.value.toString(),
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(width: TSizes.spaceBtwItems),
                  TCircularIcon(
                    icon: Iconsax.add,
                    backgroundColor: TColors.black,
                    width: 40,
                    height: 40,
                    color: TColors.white,
                    onPressed: () => controller.productQuantityInCart.value += 1,
                  ), // TCircularIcon
                ],
              ),
             // Row
            ElevatedButton(
              // هنا التغيير: اجعل الزر مفعلاً دائمًا (إلا إذا أردت منع الإضافة بكمية 0)
              // بما أن زر "الزيادة" سيعمل دائمًا لجعله 1 على الأقل.
              // إذا كنت تريد أن يكون الزر معطلاً فقط إذا كانت الكمية 0،
              // فهذا يعتمد على منطق "productQuantityInCart" هل يبدأ من 0 أم 1.
              // الأفضل هو أن يبدأ من 1 أو أن يتم تحديثه عند فتح الشاشة.
        
              // لنفترض أنك تريد السماح بإضافة المنتج حتى لو كانت الكمية المعروضة 0 في البداية.
              // أو أنك ستضمن أن productQuantityInCart لا تكون 0 في البداية.
        
              // الحل المباشر هنا هو السماح بالضغط دائمًا، أو التحقق من القيمة قبل الاستدعاء
              // وليس تعطيل الزر بالكامل.
              // onPressed: controller.productQuantityInCart.value < 1 ? null : () => controller.addToCart(product), // الكود القديم
              onPressed: () => controller.addToCart(product), // الكود الجديد: دائمًا قابل للضغط
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: TColors.black,
                side: const BorderSide(color: TColors.black),
              ),
              child: const Text('Add To Cart'),
            ),
          ],
        ),
      ),
    );
  }
}