import 'order_size_model.dart';

class SavedMeasurementProfileModel {
  final String height;
  final String bust;
  final String waist;
  final String hips;
  final String shoulderWidth;
  final String sleeveLength;
  final String figureFeatures;

  const SavedMeasurementProfileModel({
    required this.height,
    required this.bust,
    required this.waist,
    required this.hips,
    required this.shoulderWidth,
    required this.sleeveLength,
    this.figureFeatures = '',
  });

  factory SavedMeasurementProfileModel.fromMap(Map<String, dynamic> data) {
    return SavedMeasurementProfileModel(
      height: data['height'] ?? '',
      bust: data['bust'] ?? '',
      waist: data['waist'] ?? '',
      hips: data['hips'] ?? '',
      shoulderWidth: data['shoulderWidth'] ?? '',
      sleeveLength: data['sleeveLength'] ?? '',
      figureFeatures: data['figureFeatures'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'height': height,
    'bust': bust,
    'waist': waist,
    'hips': hips,
    'shoulderWidth': shoulderWidth,
    'sleeveLength': sleeveLength,
    'figureFeatures': figureFeatures,
  };

  Map<String, String> toMeasurementMap() => {
    'Рост': height,
    'Обхват груди': bust,
    'Обхват талии': waist,
    'Обхват бёдер': hips,
    'Ширина плеч': shoulderWidth,
    'Длина рукава': sleeveLength,
    if (figureFeatures.trim().isNotEmpty)
      'Особенности фигуры': figureFeatures.trim(),
  };

  OrderSizeModel toOrderSizeModel() {
    return OrderSizeModel.savedProfile(toMeasurementMap());
  }

  String get summary =>
      'Рост $height · Грудь $bust · Талия $waist · Бёдра $hips';
}
