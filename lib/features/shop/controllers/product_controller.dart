import 'package:get/get.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import '../../../../data/repositories/product/product_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/popups/loaders.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final productRepository = Get.find<ProductRepository>();
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  void fetchFeaturedProducts() async {
    try {
      // Show loader while loading Products
      isLoading.value = true;

      // Fetch Products from
      final products = await productRepository.getFeaturedProducts();
      print(
        'DEBUG: ProductController - Fetched featured products count: ${products.length}',
      ); // Added debug print

      // assign Products to featuredProducts
      featuredProducts.assignAll(products);
    } catch (e) {
      print(
        'DEBUG: ProductController - Error fetching featured products: $e',
      ); // Added debug print
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      // Fetch Products from
      final products = await productRepository.getAllFeaturedProducts();
      print(
        'DEBUG: ProductController - Fetched all featured products count: ${products.length}',
      ); // Added debug print
      return products;
    } catch (e) {
      print(
        'DEBUG: ProductController - Error fetching all featured products: $e',
      ); // Added debug print
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return []; // Ensure to return an empty list on error
    }
  }

  /// -- Get Product Price (handle different types: Simple, Variable)
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    // If product type is 'Variable' Calculate price range for variations
    if (product.productType == ProductType.variable.toString()) {
      for (var variation in product.productVariations!) {
        // Determine the price to consider (sale price if available, otherwise regular price)
        double priceToConsider =
            variation.salePrice > 0.0 ? variation.salePrice : variation.price;

        // Update smallest and largest prices
        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }

      // If smallest and largest prices are the same, return a single price
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toString();
      } else {
        // Otherwise, return a price range
        return '\$$smallestPrice - \$$largestPrice';
      }
    } else {
      // If product type is 'Single' or others, return sale price or regular price
      return (product.salePrice > 0 ? product.salePrice : product.price)
          .toString();
    }
  }

  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Check Product Stock Status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}
