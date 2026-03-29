class PaymentCardModel {
  final String id;
  final String cardholderName;
  final String maskedNumber;
  final String last4;
  final String expiry;

  const PaymentCardModel({
    required this.id,
    required this.cardholderName,
    required this.maskedNumber,
    required this.last4,
    required this.expiry,
  });

  factory PaymentCardModel.fromMap(Map<String, dynamic> data) {
    return PaymentCardModel(
      id: data['id'] ?? '',
      cardholderName: data['cardholderName'] ?? '',
      maskedNumber: data['maskedNumber'] ?? '',
      last4: data['last4'] ?? '',
      expiry: data['expiry'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'cardholderName': cardholderName,
    'maskedNumber': maskedNumber,
    'last4': last4,
    'expiry': expiry,
  };

  String get label => '$cardholderName · $maskedNumber · $expiry';
}
