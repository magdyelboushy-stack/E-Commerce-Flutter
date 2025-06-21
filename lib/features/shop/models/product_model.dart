import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/parsers.dart';
import 'brand_model.dart';
import 'product_attribute_model.dart';
import 'product_variation_model.dart';

class ProductModel {
  final String id;
  final String title;
  final double price;
  final double salePrice;
  final String productType;
  final int stock;
  final List<String> images;
  final List<ProductAttributeModel> productAttributes;
  final List<ProductVariationModel> productVariations;
  final BrandModel? brand;
  final String description;
  final String sku;
  final bool isFeatured;
  final String categoryId;
  final DateTime? date; // ✅ الجديد

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.salePrice,
    required this.productType,
    required this.stock,
    required this.images,
    required this.productAttributes,
    required this.productVariations,
    required this.description,
    required this.sku,
    required this.isFeatured,
    required this.categoryId,
    this.brand,
    required this.date, // ✅ الجديد
  });

  static ProductModel empty() => ProductModel(
    id: '',
    title: '',
    price: 0.0,
    salePrice: 0.0,
    productType: '',
    stock: 0,
    images: [],
    productAttributes: [],
    productVariations: [],
    description: '',
    sku: '',
    isFeatured: false,
    categoryId: '',
    brand: null,
    date: null,
  );

  String? get thumbnail => images.isNotEmpty ? images[0] : null;

  factory ProductModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.tryParse(data['Price'].toString()) ?? 0.0,
      salePrice: double.tryParse(data['SalePrice'].toString()) ?? 0.0,
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes:
          data['ProductAttributes'] != null
              ? (data['ProductAttributes'] as List)
                  .map((e) => ProductAttributeModel.fromJson(e))
                  .toList()
              : [],
      productVariations:
          data['ProductVariations'] != null
              ? (data['ProductVariations'] as List)
                  .map((e) => ProductVariationModel.fromJson(e))
                  .toList()
              : [],
      date: (data['Date'] as Timestamp?)?.toDate(), // ✅ الجديد
    );
  }

  factory ProductModel.fromQuerySnapshot(
    QueryDocumentSnapshot<Object?> document,
  ) {
    final data = document.data() as Map<String, dynamic>;
    return ProductModel(
      id: document.id,
      sku: data['SKU'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      isFeatured: data['IsFeatured'] ?? false,
      price: double.tryParse(data['Price'].toString()) ?? 0.0,
      salePrice: double.tryParse(data['SalePrice'].toString()) ?? 0.0,
      categoryId: data['CategoryId'] ?? '',
      description: data['Description'] ?? '',
      productType: data['ProductType'] ?? '',
      brand: data['Brand'] != null ? BrandModel.fromJson(data['Brand']) : null,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      productAttributes:
          data['ProductAttributes'] != null
              ? (data['ProductAttributes'] as List)
                  .map((e) => ProductAttributeModel.fromJson(e))
                  .toList()
              : [],
      productVariations:
          data['ProductVariations'] != null
              ? (data['ProductVariations'] as List)
                  .map((e) => ProductVariationModel.fromJson(e))
                  .toList()
              : [],
      date: (data['Date'] as Timestamp?)?.toDate(), // ✅ الجديد
    );
  }
}
