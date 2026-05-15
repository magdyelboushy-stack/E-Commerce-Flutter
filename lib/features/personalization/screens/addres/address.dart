import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart'; // Redundant
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/rounded_container.dart'; // Keep if TSingleAddress uses it
import 'package:t_store/features/personalization/screens/addres/widgets/single_address.dart';
import 'package:t_store/utils/helpers/cloud_helper_functions.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/address_controller.dart';
import '../../models/address/address_model.dart'; // Assuming TSingleAddress uses AddressModel
import 'add_new_address.dart';

// Convert UserAddressScreen to a StatefulWidget
class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> with TickerProviderStateMixin {
  late AnimationController _mainScreenAnimationController;
  late Animation<double> _appBarFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _floatingButtonSlideAnimation;
  late Animation<double> _floatingButtonFadeAnimation;

  // For staggered list item animation
  AnimationController? _listAnimationController;
  List<Animation<double>> _listItemFadeAnimations = [];
  List<Animation<Offset>> _listItemSlideAnimations = [];

  final controller = Get.put(AddressController());
  List<AddressModel> _currentAddresses = []; // To manage list animations

  @override
  void initState() {
    super.initState();

    _mainScreenAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _appBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    // General content animation (for empty state or the TCartItems block)
    _contentSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.3, 1.0, curve: Curves.easeIn)),
    );

    // Floating Button animation
    _floatingButtonSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic)),
    );
    _floatingButtonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainScreenAnimationController, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _mainScreenAnimationController.forward();

    // Listen to refreshData to re-trigger list animations if needed
    // This is useful if the data is refreshed externally and you want animations to replay.
    // controller.refreshData.listen((_) {
    //   // If you want all screen animations to replay on refresh:
    //   // _mainScreenAnimationController.reset();
    //   // _mainScreenAnimationController.forward();
    //   // Or just re-initialize list animations if the list itself is the primary thing changing
    //   if (_listAnimationController != null && _currentAddresses.isNotEmpty) {
    //     _listAnimationController!.reset();
    //     _listAnimationController!.forward();
    //   }
    // });
  }

  void _initializeListAnimations(int itemCount) {
    if (itemCount == 0) {
      _listItemFadeAnimations = [];
      _listItemSlideAnimations = [];
      return;
    }

    _listAnimationController?.dispose();
    _listAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 + (itemCount * 80)), // Adjust duration based on items
    );

    _listItemFadeAnimations = List.generate(
      itemCount,
          (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _listAnimationController!,
          curve: Interval(
            (index * 0.08).clamp(0.0, 1.0),
            ((index * 0.08) + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    _listItemSlideAnimations = List.generate(
      itemCount,
          (index) => Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero) // Slide from right
          .animate(
        CurvedAnimation(
          parent: _listAnimationController!,
          curve: Interval(
            (index * 0.08).clamp(0.0, 1.0),
            ((index * 0.08) + 0.5).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );
    _listAnimationController!.forward();
  }

  @override
  void dispose() {
    _mainScreenAnimationController.dispose();
    _listAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(AddressController()); // Already initialized as a field

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: FadeTransition(
          opacity: _appBarFadeAnimation,
          child: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: FadeTransition(
            opacity: _contentFadeAnimation,
            child: SlideTransition(
              position: _contentSlideAnimation,
              child: Obx(
                    () => FutureBuilder<List<AddressModel>>( // Specify type for FutureBuilder
                  key: Key(controller.refreshData.value.toString()), // Key for FutureBuilder refresh
                  future: controller.getAllUserAddresses(),
                  builder: (context, snapshot) {
                    final response = TCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
                    if (response != null) return response; // This will be the loader or empty state

                    final addresses = snapshot.data!;

                    // If address list changes, re-initialize list animations
                    if (_currentAddresses.length != addresses.length || !_areAddressListsEqual(_currentAddresses, addresses)) {
                      _currentAddresses = List.from(addresses);
                      _initializeListAnimations(addresses.length);
                    }

                    if (_listItemFadeAnimations.isEmpty && addresses.isNotEmpty) {
                      _initializeListAnimations(addresses.length);
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // If inside SingleChildScrollView
                      itemCount: addresses.length,
                      itemBuilder: (_, index) {
                        if (index < _listItemFadeAnimations.length && index < _listItemSlideAnimations.length) {
                          return FadeTransition(
                            opacity: _listItemFadeAnimations[index],
                            child: SlideTransition(
                              position: _listItemSlideAnimations[index],
                              child: TSingleAddress(
                                address: addresses[index],
                                onTap: () => controller.selectedAddress(addresses[index]),
                              ),
                            ),
                          );
                        }
                        // Fallback if animations not ready
                        return TSingleAddress(
                          address: addresses[index],
                          onTap: () => controller.selectedAddress(addresses[index]),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: _floatingButtonFadeAnimation,
        child: SlideTransition(
          position: _floatingButtonSlideAnimation,
          child: FloatingActionButton(
            backgroundColor: TColors.primary,
            onPressed: () => Get.to(() => const AddNewAddressScreen()),
            child: const Icon(Iconsax.add, color: TColors.white),
          ),
        ),
      ),
    );
  }

  bool _areAddressListsEqual(List<AddressModel> list1, List<AddressModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      // Compare based on a unique property, e.g., address ID
      if (list1[i].id != list2[i].id) return false;
    }
    return true;
  }
}