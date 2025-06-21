import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:t_store/features/authentication/screens/signup/widgets/signup.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/validators/validation.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/login/login_controller.dart';


class TLoginForm extends StatelessWidget {
  const   TLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: controller.email,
              validator: (value) =>  TValidator.validateEmail(value),
              decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: TTexts.email,),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),

            /// Password
            Obx(
              () => TextFormField(
                validator: (value) => TValidator.validatePassword(value),
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                decoration:  InputDecoration(
                  labelText: TTexts.password,
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields / 2),

            // Remember Me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                         value: controller.remeberMe.value,
                         onChanged: (value) => controller.remeberMe.value = !controller.remeberMe.value)
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                // Forget Password
                TextButton(onPressed: () => Get.to(() => const ForgetPassword()), child: const Text(TTexts.forgetPassword),),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.emailAndPasswordSignIn(), child: Text(TTexts.signIn),),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Create Account Btn
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(()=> const SignupScreen()),
                child: Text(TTexts.createAccount),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

