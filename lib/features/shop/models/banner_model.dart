import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String imageUrl;
  final String targetScreen;
  final bool active;

  BannerModel({
    required this.imageUrl,
    required this.targetScreen,
    required this.active,
  });

  // Helper function to create an empty banner model
  static BannerModel empty() =>
      BannerModel(imageUrl: '', targetScreen: '', active: false);

  // Convert model to Json structure so that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': imageUrl, // ✅ تم التعديل
      'TargetScreen': targetScreen, // ✅ تم التعديل
      'Active': active, // ✅ تم التعديل
    };
  }

  /// Map Json oriented document snapshot from Firebase to BannerModel
  factory BannerModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return BannerModel(
        imageUrl: data['ImageUrl'] ?? '', // ✅ تم التعديل
        targetScreen: data['TargetScreen'] ?? '', // ✅ تم التعديل
        active: data['Active'] ?? false, // ✅ تم التعديل
      );
    } else {
      return BannerModel.empty();
    }
  }
}
