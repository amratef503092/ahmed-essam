class CountryModel {
  final List<Countries> countries;
  const CountryModel({required this.countries});
  CountryModel copyWith({List<Countries>? countries}) {
    return CountryModel(countries: countries ?? this.countries);
  }

  Map<String, Object?> toJson() {
    return {
      'countries':
          countries.map<Map<String, dynamic>>((data) => data.toJson()).toList()
    };
  }

  static CountryModel fromJson(Map<String, Object?> json) {
    return CountryModel(
        countries: json['countries'] == null
            ? []
            : (json['countries'] as List)
                .map<Countries>(
                    (data) => Countries.fromJson(data as Map<String, Object?>))
                .toList());
  }

  @override
  String toString() {
    return '''CountryModel(
                countries:${countries.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is CountryModel &&
        other.runtimeType == runtimeType &&
        other.countries == countries;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, countries);
  }
}

class Countries {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? code;
  const Countries({this.id, this.nameAr, this.nameEn, this.code});
  Countries copyWith(
      {String? id, String? nameAr, String? nameEn, String? code}) {
    return Countries(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      code: code ?? this.code,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name_ar': nameAr, 'name_en': nameEn, 'code': code};
  }

  static Countries fromJson(Map<String, Object?> json) {
    return Countries(
      id: json['id'] == null ? null : json['id'] as String,
      nameAr: json['name_ar'] == null ? null : json['name_ar'] as String,
      nameEn: json['name_en'] == null ? null : json['name_en'] as String,
      code: json['code'] == null ? null : json['code'] as String,
    );
  }

  @override
  String toString() {
    return '''Countries(
                id:$id,
nameAr:$nameAr,
nameEn:$nameEn,
code:$code
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Countries &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.nameAr == nameAr &&
        other.nameEn == nameEn &&
        other.code == code;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, nameAr, nameEn, code);
  }
}
