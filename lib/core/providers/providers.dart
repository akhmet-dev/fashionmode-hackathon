import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/firestore_service.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/order_model.dart';
import '../../shared/models/cart_item_model.dart';
import '../../shared/models/app_notification_model.dart';
import '../../shared/models/order_size_model.dart';
import '../../shared/models/product_model.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.read(firestoreServiceProvider).watchCurrentUser();
    },
    loading: () => Stream.value(null),
    error: (e, _) => Stream.value(null),
  );
});

final productsProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.read(firestoreServiceProvider).watchProducts();
});

final clientOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.read(firestoreServiceProvider).watchClientOrders(user.uid);
});

final allOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.read(firestoreServiceProvider).watchAllOrders();
});

final sewingOrdersProvider = StreamProvider<List<OrderModel>>((ref) {
  return ref.read(firestoreServiceProvider).watchSewingOrders();
});

final allUsersProvider = StreamProvider<List<AppUser>>((ref) {
  return ref.read(firestoreServiceProvider).watchAllUsers();
});

class CartController extends StateNotifier<List<CartItemModel>> {
  CartController() : super(const []);

  void addProduct(ProductModel product, {required OrderSizeModel sizing}) {
    state = [...state, CartItemModel.fromProduct(product, sizing: sizing)];
  }

  void toggleSelection(String itemId) {
    state = [
      for (final item in state)
        if (item.id == itemId)
          item.copyWith(isSelected: !item.isSelected)
        else
          item,
    ];
  }

  void removeItem(String itemId) {
    state = state.where((item) => item.id != itemId).toList();
  }

  void removeItems(Iterable<String> itemIds) {
    final ids = itemIds.toSet();
    state = state.where((item) => !ids.contains(item.id)).toList();
  }

  void clear() {
    state = const [];
  }
}

final cartProvider = StateNotifierProvider<CartController, List<CartItemModel>>(
  (ref) {
    return CartController();
  },
);

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).length;
});

final selectedCartItemsProvider = Provider<List<CartItemModel>>((ref) {
  return ref.watch(cartProvider).where((item) => item.isSelected).toList();
});

class NotificationInboxController
    extends StateNotifier<List<AppNotificationModel>> {
  NotificationInboxController() : super(const []);

  String? _storageKey;

  Future<void> syncUser(AppUser? user) async {
    _storageKey = user == null ? null : 'notification_inbox_${user.uid}';
    if (_storageKey == null) {
      state = const [];
      return;
    }

    final storageKey = _storageKey;
    final prefs = await SharedPreferences.getInstance();
    if (storageKey == null) return;
    final raw = prefs.getStringList(storageKey) ?? const [];
    state =
        raw
            .map(
              (item) => AppNotificationModel.fromMap(
                jsonDecode(item) as Map<String, dynamic>,
              ),
            )
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addNotification({
    required String title,
    required String body,
    String? id,
  }) async {
    if (_storageKey == null) return;

    final notification = AppNotificationModel(
      id: id ?? '${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      body: body,
      createdAt: DateTime.now(),
      isRead: false,
    );

    state = [notification, ...state];
    await _persist();
  }

  Future<void> markAllRead() async {
    if (_storageKey == null || state.isEmpty) return;
    state = [for (final item in state) item.copyWith(isRead: true)];
    await _persist();
  }

  Future<void> _persist() async {
    if (_storageKey == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey!,
      state.map((item) => jsonEncode(item.toMap())).toList(),
    );
  }
}

final notificationInboxProvider =
    StateNotifierProvider<
      NotificationInboxController,
      List<AppNotificationModel>
    >((ref) {
      return NotificationInboxController();
    });

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref
      .watch(notificationInboxProvider)
      .where((notification) => !notification.isRead)
      .length;
});
