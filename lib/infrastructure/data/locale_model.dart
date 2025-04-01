import 'package:hive/hive.dart';

part 'locale_model.g.dart';

@HiveType(typeId: 1)
class LocaleModel extends HiveObject {
  @HiveField(0)
  final String languageCode; // Language code (e.g., 'en', 'fi', 'zh')

  @HiveField(1)
  final String scriptCode; // Script code (e.g., 'Hans', 'Hant')

  @HiveField(2)
  final String countryCode; // Country code (e.g., 'US', 'FI', 'CN')

  LocaleModel({
    required this.languageCode,
    required this.scriptCode,
    required this.countryCode,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocaleModel &&
        other.languageCode == languageCode &&
        other.scriptCode == scriptCode &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode =>
      languageCode.hashCode ^ scriptCode.hashCode ^ countryCode.hashCode;

  @override
  String toString() =>
      'LocaleModel(languageCode: $languageCode, scriptCode: $scriptCode, countryCode: $countryCode)';

  // Convenience method to create a copy with modified fields
  LocaleModel copyWith({
    String? languageCode,
    String? scriptCode,
    String? countryCode,
  }) {
    return LocaleModel(
      languageCode: languageCode ?? this.languageCode,
      scriptCode: scriptCode ?? this.scriptCode,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'languageCode': languageCode,
      'scriptCode': scriptCode,
      'countryCode': countryCode,
    };
  }

  // Create from Map
  factory LocaleModel.fromMap(Map<String, dynamic> map) {
    return LocaleModel(
      languageCode: map['languageCode'] as String,
      scriptCode: map['scriptCode'] as String,
      countryCode: map['countryCode'] as String,
    );
  }
}
