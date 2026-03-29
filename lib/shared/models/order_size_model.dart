enum OrderSizeMode { standard, custom, savedProfile }

class OrderSizeModel {
  final OrderSizeMode mode;
  final String standardSize;
  final Map<String, String> customMeasurements;

  const OrderSizeModel({
    required this.mode,
    this.standardSize = '',
    this.customMeasurements = const {},
  });

  const OrderSizeModel.standard(String size)
    : this(mode: OrderSizeMode.standard, standardSize: size);

  const OrderSizeModel.custom(Map<String, String> measurements)
    : this(mode: OrderSizeMode.custom, customMeasurements: measurements);

  const OrderSizeModel.savedProfile(Map<String, String> measurements)
    : this(mode: OrderSizeMode.savedProfile, customMeasurements: measurements);

  factory OrderSizeModel.fromMap(
    Map<String, dynamic>? data, {
    String legacySize = '',
  }) {
    if (data == null) {
      return OrderSizeModel.standard(legacySize.trim());
    }

    final modeRaw = data['mode'] as String?;
    final mode = OrderSizeMode.values.firstWhere(
      (value) => value.name == modeRaw,
      orElse: () => OrderSizeMode.standard,
    );

    final rawMeasurements =
        (data['customMeasurements'] as Map<String, dynamic>? ?? const {});
    final measurements = <String, String>{
      for (final entry in rawMeasurements.entries)
        entry.key: '${entry.value}'.trim(),
    }..removeWhere((_, value) => value.isEmpty);

    final standardSize = (data['standardSize'] as String? ?? legacySize).trim();

    if (measurements.isNotEmpty) {
      if (mode == OrderSizeMode.savedProfile) {
        return OrderSizeModel.savedProfile(measurements);
      }
      if (mode == OrderSizeMode.custom) {
        return OrderSizeModel.custom(measurements);
      }
    }

    return OrderSizeModel.standard(standardSize);
  }

  bool get isCustom => mode == OrderSizeMode.custom;

  bool get isSavedProfile => mode == OrderSizeMode.savedProfile;

  bool get hasDetailedMeasurements => isCustom || isSavedProfile;

  bool get isEmpty => !isCustom && standardSize.trim().isEmpty;

  String get summary => isSavedProfile
      ? 'Сохранённые мерки'
      : isCustom
      ? 'Кастомный пошив'
      : (standardSize.trim().isEmpty ? 'Не указан' : standardSize.trim());

  String get details {
    if (!isCustom) return summary;
    if (customMeasurements.isEmpty) return 'Параметры не указаны';
    return customMeasurements.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(' · ');
  }

  String get compactDisplay => isSavedProfile
      ? 'Сохранённые'
      : isCustom
      ? 'Кастомный'
      : summary;

  String get displayText => isCustom ? '$summary · $details' : summary;

  Map<String, dynamic> toMap() => {
    'mode': mode.name,
    'standardSize': standardSize.trim(),
    'customMeasurements': {
      for (final entry in customMeasurements.entries)
        entry.key: entry.value.trim(),
    },
  };
}
