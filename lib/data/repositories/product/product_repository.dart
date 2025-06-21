import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  // Firestore instance
  final _db = FirebaseFirestore.instance;

  /// Get all featured products (from ProductModel)
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot =
          await _db
              .collection('Products')
              .where('IsFeatured', isEqualTo: true)
              .limit(4)
              .get();
      print(
        'DEBUG: ProductRepository - Fetched featured products (limit 4) count: ${snapshot.docs.length}',
      ); // DEBUG
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      print(
        'DEBUG: ProductRepository - Firebase Exception in getFeaturedProducts (limit 4): ${e.message}',
      ); // DEBUG
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      print(
        'DEBUG: ProductRepository - Platform Exception in getFeaturedProducts (limit 4): ${e.code}',
      ); // DEBUG
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(
        'DEBUG: ProductRepository - General Error in getFeaturedProducts (limit 4): $e',
      ); // DEBUG
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get all products (from ProductModel) - used for "View All"
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      // Note: The previous getFeaturedProducts had limit(4). This one does not.
      final snapshot =
          await _db
              .collection('Products')
              .where('IsFeatured', isEqualTo: true)
              .get();
      print(
        'DEBUG: ProductRepository - Fetched all featured products count: ${snapshot.docs.length}',
      ); // DEBUG
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      print(
        'DEBUG: ProductRepository - Firebase Exception in getAllFeaturedProducts: ${e.message}',
      ); // DEBUG
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      print(
        'DEBUG: ProductRepository - Platform Exception in getAllFeaturedProducts: ${e.code}',
      ); // DEBUG
      throw TPlatformException(e.code).message;
    } catch (e) {
      print(
        'DEBUG: ProductRepository - General Error in getAllFeaturedProducts: $e',
      ); // DEBUG
      throw 'Something went wrong. Please try again';
    }
  }

  /// Fetch products by query
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<ProductModel> productList = querySnapshot.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();
      return productList;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get Products based on the Query
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async {
    try {
      final snapshot = await _db.collection('Products').where(FieldPath.documentId, whereIn: productIds).get();
      return snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getProductsForBrand({
    required String brandId,
    int limit = -1,
  }) async {
    try {
      final querySnapshot =
          limit == -1
              ? await _db
                  .collection('Products')
                  .where('Brand.Id', isEqualTo: brandId)
                  .get()
              : await _db
                  .collection('Products')
                  .where('Brand.Id', isEqualTo: brandId)
                  .limit(limit)
                  .get();

      final products =
          querySnapshot.docs
              .map((doc) => ProductModel.fromSnapshot(doc))
              .toList();

      return products;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<ProductModel>> getProductsForCategory({required String categoryId, int limit = 4,}) async {
    try {
      // Query to get all documents where productid matches the provided categoryId & Fetch limited or unlimited based on limit
      QuerySnapshot productCategoryQuery =
          limit == -1
              ? await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).get()
              : await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).limit(limit).get();

      // Extract ProductIds from the documents
      List<String> productIds =
          productCategoryQuery.docs
              .map((doc) => doc['productId'] as String)
              .toList();

      // Query to get all documents where the brandId is in the list of brandIds, FieldPath.documentId to query documents in Collection
      final productsQuery =
          await _db
              .collection('Products')
              .where(FieldPath.documentId, whereIn: productIds)
              .get();

      // Extract brand names or other relevant data from the documents
      List<ProductModel> products =
          productsQuery.docs
              .map((doc) => ProductModel.fromSnapshot(doc))
              .toList();

      return products;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
