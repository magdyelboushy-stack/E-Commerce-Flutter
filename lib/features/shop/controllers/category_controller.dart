import 'package:get/get.dart';
import '../../../../utils/popups/loaders.dart';

import '../../../data/repositories/categories/categories_repository.dart';
import '../../../data/repositories/product/product_repository.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepository = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  /// -- Load category data
  Future<void> fetchCategories() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // Fetch categories from repository (Firestore or other source)
      final categories = await _categoryRepository.getAllCategories();

      // Assign all categories
      allCategories.assignAll(categories);

      // Filter featured categories with empty parentId
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.trim().isEmpty,).take(8).toList(),);

    } catch (e) {
      // Show error if any
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Hide loader
      isLoading.value = false;
    }
  }

  /// Load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try {
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }


  /// Get Category or Sub-Category Products.
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async {
    // Fetch limited (4) products against each subCategory;
    final products = await ProductRepository.instance.getProductsForCategory(categoryId: categoryId, limit: limit);
    return products;
  }
}
