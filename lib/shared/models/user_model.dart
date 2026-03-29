import 'package:cloud_firestore/cloud_firestore.dart';

import 'payment_card_model.dart';
import 'saved_measurement_profile_model.dart';

enum UserRole { client, franchisee, production }

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final int? dailyRevenueTarget;
  final List<PaymentCardModel> savedCards;
  final SavedMeasurementProfileModel? savedMeasurements;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.dailyRevenueTarget,
    this.savedCards = const [],
    this.savedMeasurements,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == data['role'],
        orElse: () => UserRole.client,
      ),
      dailyRevenueTarget: data['dailyRevenueTarget'] as int?,
      savedCards: ((data['savedCards'] as List<dynamic>?) ?? const [])
          .map(
            (item) => PaymentCardModel.fromMap(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      savedMeasurements: data['savedMeasurements'] == null
          ? null
          : SavedMeasurementProfileModel.fromMap(
              Map<String, dynamic>.from(data['savedMeasurements'] as Map),
            ),
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'role': role.name,
    if (dailyRevenueTarget != null) 'dailyRevenueTarget': dailyRevenueTarget,
    'savedCards': savedCards.map((card) => card.toMap()).toList(),
    if (savedMeasurements != null)
      'savedMeasurements': savedMeasurements!.toMap(),
  };
}
