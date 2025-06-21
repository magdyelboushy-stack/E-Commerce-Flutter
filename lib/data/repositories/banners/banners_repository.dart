import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/banner_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';


class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

 /// Get all order related to current user
  Future<List<BannerModel>> fetchBanners() async {
    try {
      print('DEBUG: BannerRepository - Attempting to fetch banners...'); // DEBUG
      final result = await _db.collection('Banners').where('Active', isEqualTo: true).get();
      
      // ✅ تحقق من عدد البانرات التي تم جلبها
      print('DEBUG: BannerRepository - Fetched ${result.docs.length} active banners.'); // DEBUG
      
      // ✅ اطبع بيانات كل بانر تم جلبه
      for (var doc in result.docs) {
        print('DEBUG: Banner ID: ${doc.id}, Data: ${doc.data()}');
      }

      return result.docs.map((documentSnapshot) => BannerModel.fromSnapshot(documentSnapshot)).toList();
    } on FirebaseException catch (e) {
      print('DEBUG: BannerRepository - Firebase Exception fetching banners: ${e.message}'); // DEBUG
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print('DEBUG: BannerRepository - Format Exception fetching banners.'); // DEBUG
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('DEBUG: BannerRepository - Platform Exception fetching banners: ${e.code}'); // DEBUG
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('DEBUG: BannerRepository - General Error fetching banners: $e'); // DEBUG
      throw 'Something went wrong while fetching Banners.';
    }
  }
  
}