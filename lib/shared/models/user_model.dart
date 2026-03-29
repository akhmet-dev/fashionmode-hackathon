import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { client, franchisee, production }

class AppUser {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final int? dailyRevenueTarget;

  const AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.dailyRevenueTarget,
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
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'role': role.name,
    if (dailyRevenueTarget != null) 'dailyRevenueTarget': dailyRevenueTarget,
  };
}
