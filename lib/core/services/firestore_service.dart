import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/product_model.dart';

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
    return _db.collection('users').doc(uid).snapshots().map(
          (doc) => doc.exists ? AppUser.fromFirestore(doc) : null,
        );
  }

  Stream<List<ProductModel>> watchProducts() {
    return _db.collection('products').snapshots().map(
          (snap) => snap.docs.map((d) => ProductModel.fromFirestore(d)).toList(),
        );
  }

  Future<void> placeOrder({
    required String productName,
    required int price,
    required String clientName,
    DateTime? preorderDate,
  }) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection('orders').add({
      'clientId': uid,
      'clientName': clientName,
      'productName': productName,
      'price': price,
      'status': OrderStatus.placed.name,
      'createdAt': FieldValue.serverTimestamp(),
      if (preorderDate != null)
        'preorderDate': Timestamp.fromDate(preorderDate),
    });
  }

  Stream<List<OrderModel>> watchClientOrders(String clientId) {
    return _db
        .collection('orders')
        .where('clientId', isEqualTo: clientId)
        .snapshots()
        .map((snap) {
      final orders =
          snap.docs.map((d) => OrderModel.fromFirestore(d)).toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  Stream<List<OrderModel>> watchAllOrders() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => OrderModel.fromFirestore(d)).toList());
  }

  Stream<List<OrderModel>> watchSewingOrders() {
    return _db
        .collection('orders')
        .where('status', isEqualTo: OrderStatus.sewing.name)
        .snapshots()
        .map((snap) {
      final orders =
          snap.docs.map((d) => OrderModel.fromFirestore(d)).toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status.name,
    });
  }

  Future<void> seedDataIfNeeded() async {
    final productsSnap = await _db.collection('products').limit(1).get();
    if (productsSnap.docs.isNotEmpty) return;

    final batch = _db.batch();

    final products = [
      {'name': 'AVISHU MINIMAL COAT', 'price': 45000, 'isPreorder': false},
      {'name': 'STRUCTURED BLAZER', 'price': 32000, 'isPreorder': false},
      {'name': 'EVENING DRESS', 'price': 28000, 'isPreorder': true},
      {'name': 'WIDE LEG TROUSERS', 'price': 18000, 'isPreorder': false},
    ];

    for (final p in products) {
      batch.set(_db.collection('products').doc(), p);
    }

    batch.commit();

    final testUsers = [
      {'email': 'client@avishu.kz', 'name': 'CLIENT USER', 'role': 'client'},
      {'email': 'franchisee@avishu.kz', 'name': 'FRANCHISEE USER', 'role': 'franchisee'},
      {'email': 'production@avishu.kz', 'name': 'PRODUCTION USER', 'role': 'production'},
    ];

    for (final u in testUsers) {
      try {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: u['email']!,
          password: 'test123',
        );
        await _db.collection('users').doc(cred.user!.uid).set(u);
      } on FirebaseAuthException catch (_) {}
    }

    await _auth.signOut();
  }
}
