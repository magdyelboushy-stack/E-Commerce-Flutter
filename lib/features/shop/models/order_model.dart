import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../personalization/models/address/address_model.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = "",
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryDate,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  String get formattedDeliveryDate => deliveryDate != null ? THelperFunctions.getFormattedDate(deliveryDate!) : '';

  String get orderStatusText => status == OrderStatus.delivered
      ? 'Delivered'
      : status == OrderStatus.shipped
      ? 'Shipment on the way'
      : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(), // Convert AddressModel to map
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList(), // Convert CartItemModel to map
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    // 1. التعامل مع الحقول النصية (String) التي قد تكون null في Firestore
    // استخدمنا ?.toString() ?? '' لضمان أنها String أو نص فارغ
    final String id = data['id']?.toString() ?? '';
    final String userId = data['userId']?.toString() ?? '';
    final String paymentMethod = data['paymentMethod']?.toString() ?? 'Paypal';

    // 2. التعامل مع Enum OrderStatus
    OrderStatus status;
    try {
      status = OrderStatus.values.firstWhere(
            (e) => e.toString() == (data['status']?.toString() ?? ''), // التعامل مع حالة null
        orElse: () => OrderStatus.pending, // قيمة افتراضية لو لم يتم العثور على الحالة
      );
    } catch (e) {
      status = OrderStatus.pending; // قيمة افتراضية في حالة حدوث خطأ غير متوقع
      print('Warning: Error parsing OrderStatus. Defaulting to pending. Error: $e');
    }

    // 3. التعامل مع totalAmount
    final double totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;

    // 4. التعامل مع orderDate (Timestamp)
    final DateTime orderDate = (data['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now();

    // 5. التعامل مع address (قد يكون null أو ليس Map)
    final AddressModel? address = (data['address'] is Map<String, dynamic>)
        ? AddressModel.fromMap(data['address'] as Map<String, dynamic>)
        : null;

    // 6. التعامل مع deliveryDate (قد يكون null)
    final DateTime? deliveryDate = data['deliveryDate'] == null
        ? null
        : (data['deliveryDate'] as Timestamp).toDate();

    // 7. التعامل مع items (قائمة المنتجات - مع إصلاح أخطاء الـ compilation)
    final List<CartItemModel> items = (data['items'] is List<dynamic>)
        ? (data['items'] as List<dynamic>).map<CartItemModel>((itemData) { // <--- إضافة <CartItemModel> هنا
      if (itemData is Map<String, dynamic>) {
        // تأكد من أن CartItemModel.fromJson يتعامل بقوة مع Nulls/بيانات مفقودة
        return CartItemModel.fromJson(itemData);
      }
      print('Warning: Order item data is not a valid Map: $itemData');
      // توفير عنصر dummy لمنع الانهيار، مع حذف الـ 'name' الذي يسبب الخطأ
      return CartItemModel(
        productId: 'unknown',
        // name: 'Error Item', // <--- حذف هذا السطر
        price: 0.0,
        quantity: 0,
        variationId: '',
      );
    }).toList()
        : []; // قائمة فارغة كقيمة افتراضية

    return OrderModel(
      id: id,
      userId: userId,
      status: status,
      totalAmount: totalAmount,
      orderDate: orderDate,
      paymentMethod: paymentMethod,
      address: address,
      deliveryDate: deliveryDate,
      items: items,
    );
  }
}