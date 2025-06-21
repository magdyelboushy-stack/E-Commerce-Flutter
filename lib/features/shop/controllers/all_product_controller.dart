import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/repositories/product/product_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../models/product_model.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  final repository = ProductRepository.instance;
  final products =
      <ProductModel>[].obs; // This will hold products for sorting/filtering
  final selectedSortOption = 'Newest'.obs; // Default sort option

  // Constructor
  AllProductsController() {
    print('DEBUG: AllProductsController created.'); // DEBUG
  }

  // Method to assign products (used when data is passed from other screens)
  void assignProducts(List<ProductModel> initialProducts) {
    products.assignAll(initialProducts);
    print(
      'DEBUG: AllProductsController - Assigned initial products count: ${initialProducts.length}',
    ); // DEBUG
    sortProducts(selectedSortOption.value); // Sort them initially
  }

  // Fetch products by query
  Future<List<ProductModel>> fetchProductsByQuery(Query? query) async {
    try {
      if (query == null) {
        print(
          'DEBUG: AllProductsController - Query is null, returning empty list.',
        ); // DEBUG
        return [];
      }
      final fetchedProducts = await repository.fetchProductsByQuery(query);
      print(
        'DEBUG: AllProductsController - Products fetched successfully by query: ${fetchedProducts.length}',
      ); // DEBUG
      return fetchedProducts;
    } catch (e) {
      print(
        'DEBUG: AllProductsController - Error fetching products by query: $e',
      ); // DEBUG
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  // Sort products based on selected option
  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (a.salePrice > 0 && b.salePrice == 0) {
            return -1;
          } else if (a.salePrice == 0 && b.salePrice > 0) {
            return 1;
          }
          return 0;
        });
        break;
      case 'Newest':
        // Assuming 'date' field exists and is a DateTime. If not, you might need to adjust.
        products.sort(
          (a, b) =>
              (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()),
        );
        break;
      case 'Popularity':
        // You might need a 'Popularity' field in your ProductModel
        // For now, let's just sort by title if no specific popularity field
        products.sort((a, b) => b.title.compareTo(a.title));
        break;
      default:
        // Default sort (e.g., by ID or newest if no other option)
        products.sort((a, b) => a.id.compareTo(b.id));
    }
    print(
      'DEBUG: AllProductsController - Products sorted by: $sortOption. Current count: ${products.length}',
    ); // DEBUG
  }

  // Method to clear products when done
  void clearProducts() {
    products.clear();
    print('DEBUG: AllProductsController - Products cleared.'); // DEBUG
  }
}
