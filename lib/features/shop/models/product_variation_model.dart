import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/parsers.dart';

class ProductVariationModel {
  final String id;
  String sku;
  String image;
  String? description;
  double price;
  double salePrice;
  int stock;
  Map<String, String> attributeValues;

  ProductVariationModel({
    required this.id,
    this.sku = '',
    this.image = '',
    this.description = '',
    this.price = 0.0,
    this.salePrice = 0.0,
    this.stock = 0,
    required this.attributeValues,
  });

  static ProductVariationModel empty() =>
      ProductVariationModel(id: '', attributeValues: {});

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Image': image,
      'Description': description,
      'Price': price,
      'SalePrice': salePrice,
      'SKU': sku,
      'Stock': stock,
      'AttributeValues': attributeValues,
    };
  }

  factory ProductVariationModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductVariationModel(
      id: doc.id,
      sku: data['sku'] ?? '',
      image: data['image'] ?? '',
      description: data['description'],
      price: _parseDouble(data['Price']),
      salePrice: _parseDouble(data['SalePrice']),
      stock: parseInt(data['Stock']),
      attributeValues: Map<String, String>.from(data['AttributeValues'] ?? {}),
    );
  }

  factory ProductVariationModel.fromJson(Map<String, dynamic> json) {
    return ProductVariationModel(
      id: json['Id'] ?? '',
      sku: json['SKU'] ?? '',
      image: json['Image'] ?? '',
      description: json['Description'],
      price: _parseDouble(json['Price']),
      salePrice: _parseDouble(json['SalePrice']),
      stock: parseInt(json['Stock']),
      attributeValues: Map<String, String>.from(json['AttributeValues'] ?? {}),
    );
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
