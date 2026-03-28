import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/product_model.dart';

// ── Services ─────────────────────────────────────────────

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// ── Auth State ───────────────────────────────────────────

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ── Current App User ─────────────────────────────────────

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.read(firestoreServiceProvider).watchCurrentUser();
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// ── Products ─────────────────────────────────────────────

final productsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.read(firestoreServiceProvider).watchProducts();
});

// ── Client Orders ────────────────────────────────────────

final clientOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreServiceProvider).watchClientOrders(user.uid);
});

// ── All Orders (Franchisee) ──────────────────────────────

final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.read(firestoreServiceProvider).watchAllOrders();
});

// ── Sewing Orders (Production) ───────────────────────────

final sewingOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.read(firestoreServiceProvider).watchSewingOrders();
});
