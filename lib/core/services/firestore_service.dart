import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/models/order_size_model.dart';
import '../../shared/models/payment_card_model.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/saved_measurement_profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser?> getCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  Stream<AppUser?> watchCurrentUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }

  Stream<List<ProductModel>> watchProducts() {
    return _db.collection('products').snapshots().map((snap) {
      final products = snap.docs
          .map((d) => ProductModel.fromFirestore(d))
          .toList();
      products.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return products;
    });
  }

  Future<void> placeOrder({
    required String productName,
    required int price,
    required String clientName,
    required OrderSizeModel sizing,
    required PaymentMethod paymentMethod,
    DateTime? preorderDate,
  }) async {
    final uid = _auth.currentUser!.uid;
    final paymentStatus = paymentMethod == PaymentMethod.cash
        ? PaymentStatus.pending
        : PaymentStatus.paid;
    await _db.collection('orders').add({
      'clientId': uid,
      'clientName': clientName,
      'productName': productName,
      'size': sizing.summary,
      'sizing': sizing.toMap(),
      'price': price,
      'status': OrderStatus.placed.name,
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'createdAt': FieldValue.serverTimestamp(),
      if (paymentStatus == PaymentStatus.paid)
        'paidAt': FieldValue.serverTimestamp(),
      if (preorderDate != null)
        'preorderDate': Timestamp.fromDate(preorderDate),
    });
  }

  Future<void> placeCartOrders({
    required List<CartItemModel> items,
    required String clientName,
    required PaymentMethod paymentMethod,
  }) async {
    if (items.isEmpty) return;

    final uid = _auth.currentUser!.uid;
    final ordersRef = _db.collection('orders');
    final batch = _db.batch();
    final paymentStatus = paymentMethod == PaymentMethod.cash
        ? PaymentStatus.pending
        : PaymentStatus.paid;

    for (final item in items) {
      batch.set(ordersRef.doc(), {
        'clientId': uid,
        'clientName': clientName,
        'productName': item.productName,
        'size': item.sizing.summary,
        'sizing': item.sizing.toMap(),
        'price': item.price,
        'status': OrderStatus.placed.name,
        'paymentMethod': paymentMethod.name,
        'paymentStatus': paymentStatus.name,
        'createdAt': FieldValue.serverTimestamp(),
        if (paymentStatus == PaymentStatus.paid)
          'paidAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Stream<List<OrderModel>> watchClientOrders(String clientId) {
    return _db
        .collection('orders')
        .where('clientId', isEqualTo: clientId)
        .snapshots()
        .map((snap) {
          final orders = snap.docs
              .map((d) => OrderModel.fromFirestore(d))
              .toList();
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  Stream<List<OrderModel>> watchAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => OrderModel.fromFirestore(d)).toList(),
        );
  }

  Stream<List<OrderModel>> watchSewingOrders() {
    return _db
        .collection('orders')
        .where('status', isEqualTo: OrderStatus.sewing.name)
        .snapshots()
        .map((snap) {
          final orders = snap.docs
              .map((d) => OrderModel.fromFirestore(d))
              .toList();
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final payload = <String, Object?>{'status': status.name};
    if (status == OrderStatus.ready) {
      payload['completedAt'] = FieldValue.serverTimestamp();
    } else {
      payload['completedAt'] = FieldValue.delete();
    }
    await _db.collection('orders').doc(orderId).update(payload);
  }

  Future<void> deleteOrder(String orderId) async {
    await _db.collection('orders').doc(orderId).delete();
  }

  Future<void> updateDailyRevenueTarget(int target) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).update({
      'dailyRevenueTarget': target,
    });
  }

  Future<void> addSavedCard({
    required String cardholderName,
    required String cardNumber,
    required String expiry,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 4) return;

    final last4 = digits.substring(digits.length - 4);
    final card = PaymentCardModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      cardholderName: cardholderName.trim(),
      maskedNumber: '•••• •••• •••• $last4',
      last4: last4,
      expiry: expiry.trim(),
    );

    final userDoc = _db.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    final data = snapshot.data() ?? <String, dynamic>{};
    final cards = ((data['savedCards'] as List<dynamic>?) ?? const [])
        .map(
          (item) =>
              PaymentCardModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
    cards.add(card);

    await userDoc.update({
      'savedCards': cards.map((item) => item.toMap()).toList(),
    });
  }

  Future<void> removeSavedCard(String cardId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userDoc = _db.collection('users').doc(uid);
    final snapshot = await userDoc.get();
    final data = snapshot.data() ?? <String, dynamic>{};
    final cards = ((data['savedCards'] as List<dynamic>?) ?? const [])
        .map(
          (item) =>
              PaymentCardModel.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .where((card) => card.id != cardId)
        .toList();

    await userDoc.update({
      'savedCards': cards.map((item) => item.toMap()).toList(),
    });
  }

  // ── Product management (franchisee) ────────────────────────────────────────

  Future<String?> uploadProductImage(String productId, File imageFile) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('products/$productId.jpg');
    final task = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await task.ref.getDownloadURL();
  }

  Future<void> addProduct(ProductModel product) async {
    final ref = _db.collection('products').doc(product.id);
    await ref.set(product.toMap());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _db.collection('products').doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
    // Also delete image from Storage if exists
    try {
      await FirebaseStorage.instance
          .ref()
          .child('products/$productId.jpg')
          .delete();
    } catch (_) {}
  }

  // ── Admin methods ──────────────────────────────────────────────────────────

  Stream<List<AppUser>> watchAllUsers() {
    return _db.collection('users').snapshots().map(
      (snap) => snap.docs.map((d) => AppUser.fromFirestore(d)).toList()
        ..sort((a, b) => a.name.compareTo(b.name)),
    );
  }

  Future<void> updateUserRole(String uid, UserRole role) async {
    await _db.collection('users').doc(uid).update({'role': role.name});
  }

  Future<void> deleteUserDoc(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  Future<String?> createAppUser({
    required String email,
    required String name,
    required UserRole role,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;
      await _db.collection('users').doc(uid).set({
        'email': email.trim(),
        'name': name.trim().toUpperCase(),
        'role': role.name,
        'savedCards': <dynamic>[],
      });
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Қате';
    }
  }

  Future<void> saveMeasurementProfile(
    SavedMeasurementProfileModel profile,
  ) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _db.collection('users').doc(uid).update({
      'savedMeasurements': profile.toMap(),
    });
  }

  Future<void> seedDataIfNeeded() async {
    await _syncDemoCatalog();

    final List<Map<String, Object>> testUsers = [
      {'email': 'client@avishu.kz', 'name': 'CLIENT USER', 'role': 'client'},
      {
        'email': 'franchisee@avishu.kz',
        'name': 'FRANCHISEE USER',
        'role': 'franchisee',
        'dailyRevenueTarget': 180000,
      },
      {
        'email': 'production@avishu.kz',
        'name': 'PRODUCTION USER',
        'role': 'production',
      },
      {
        'email': 'admin@avishu.kz',
        'name': 'ADMIN USER',
        'role': 'admin',
      },
    ];

    // Check each user individually and create only missing ones
    for (final u in testUsers) {
      final email = u['email']! as String;
      try {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: 'test123',
        );
        await _db.collection('users').doc(cred.user!.uid).set(u);
      } on FirebaseAuthException catch (e) {
        // email-already-in-use means user exists in Auth — ensure Firestore doc exists
        if (e.code == 'email-already-in-use') {
          final signIn = await _auth.signInWithEmailAndPassword(
            email: email,
            password: 'test123',
          );
          final uid = signIn.user!.uid;
          final doc = await _db.collection('users').doc(uid).get();
          if (!doc.exists) {
            await _db.collection('users').doc(uid).set(u);
          }
          await _auth.signOut();
        }
      }
    }

    await _auth.signOut();
  }

  Future<void> _syncDemoCatalog() async {
    final productsRef = _db.collection('products');
    final existingProducts = await productsRef.get();
    final batch = _db.batch();

    const measurementFields = ['Ширина груди', 'Ширина плеч', 'Длина рукава'];

    const demoCatalog = <String, Map<String, Object>>{
      'white_tshirt': {
        'name': 'WHITE T-SHIRT',
        'price': 14000,
        'isPreorder': false,
        'sortOrder': 0,
        'imageKey': 'white_tshirt',
        'measurementFields': measurementFields,
      },
      'black_tshirt': {
        'name': 'BLACK T-SHIRT',
        'price': 14500,
        'isPreorder': false,
        'sortOrder': 1,
        'imageKey': 'black_tshirt',
        'measurementFields': measurementFields,
      },
      'grey_tshirt': {
        'name': 'GREY T-SHIRT',
        'price': 15000,
        'isPreorder': false,
        'sortOrder': 2,
        'imageKey': 'grey_tshirt',
        'measurementFields': measurementFields,
      },
      'black_sweater_preorder': {
        'name': 'BLACK SWEATER',
        'price': 22000,
        'isPreorder': true,
        'sortOrder': 3,
        'imageKey': 'black_sweater',
        'measurementFields': measurementFields,
      },
    };

    final validIds = demoCatalog.keys.toSet();
    for (final doc in existingProducts.docs) {
      if (!validIds.contains(doc.id)) {
        batch.delete(doc.reference);
      }
    }

    for (final entry in demoCatalog.entries) {
      batch.set(productsRef.doc(entry.key), entry.value);
    }

    await batch.commit();
  }
}
