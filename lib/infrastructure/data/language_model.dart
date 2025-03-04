import 'package:hive/hive.dart';

part 'language_model.g.dart';

@HiveType(typeId: 1)
class Language {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'nativeName': nativeName,
      };

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        code: json['code'],
        name: json['name'],
        nativeName: json['nativeName'],
      );
}
