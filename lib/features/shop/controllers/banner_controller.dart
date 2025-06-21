import 'package:get/get.dart';

import '../../../data/repositories/banners/banners_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/banner_model.dart';

class BannerController extends GetxController {


  /// Variables
  final carousalCurrentIndex = 0.obs;
  final isLoading = false.obs;
  final RxList<BannerModel> banners = <BannerModel>[].obs;


  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  /// Update Page Indicator
  void updatePageIndicator(index){
    carousalCurrentIndex.value = index;
  }

  /// Fetch Banners
  Future<void> fetchBanners() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // Fetch Banners
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      // Assign Banners to the controller
      this.banners.assignAll(banners);

    } catch (e, stacktrace) {
      print('Error fetching banners: $e');
      print(stacktrace);
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
    finally {
      // Remove Loader
      isLoading.value = false;
    }
  }
}