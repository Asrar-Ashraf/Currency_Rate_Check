import 'dart:convert';
import 'package:flutter/foundation.dart';

class Currencymodel {
  final String result;
  final String documentation;
  final String termsOfUse;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final int timeNextUpdateUnix;
  final String timeNextUpdateUtc;
  final String baseCode;
  final Map<String, dynamic> bpi;

  Currencymodel({
    required this.result,
    required this.documentation,
    required this.termsOfUse,
    required this.timeLastUpdateUnix, // ✅ CORRECTED
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.baseCode,
    required this.bpi,
  });

  // ✅ CORRECTED FROM MAP METHOD
  factory Currencymodel.fromMap(Map<String, dynamic> map) {
    return Currencymodel(
      result: map['result'] as String,
      documentation: map['documentation'] as String,
      termsOfUse: map['terms_of_use'] as String, // ✅ CORRECT JSON KEY
      timeLastUpdateUnix:
          map['time_last_update_unix'] as int, // ✅ CORRECT JSON KEY
      timeLastUpdateUtc: map['time_last_update_utc'] as String,
      timeNextUpdateUnix: map['time_next_update_unix'] as int,
      timeNextUpdateUtc: map['time_next_update_utc'] as String,
      baseCode: map['base_code'] as String, // ✅ CORRECT JSON KEY
      bpi: Map<String, dynamic>.from(
        (map['conversion_rates'] as Map<String, dynamic>),
      ), // ✅ CORRECT JSON KEY
    );
  }

  // ✅ CORRECTED TO MAP METHOD
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'result': result,
      'documentation': documentation,
      'terms_of_use': termsOfUse, // ✅ MATCHES JSON
      'time_last_update_unix': timeLastUpdateUnix, // ✅ MATCHES JSON
      'time_last_update_utc': timeLastUpdateUtc,
      'time_next_update_unix': timeNextUpdateUnix,
      'time_next_update_utc': timeNextUpdateUtc,
      'base_code': baseCode, // ✅ MATCHES JSON
      'conversion_rates': bpi, // ✅ MATCHES JSON
    };
  }

  String toJson() => json.encode(toMap());

  factory Currencymodel.fromJson(String source) =>
      Currencymodel.fromMap(json.decode(source) as Map<String, dynamic>);

  // copyWith, toString, ==, hashCode methods remain same...

  Currencymodel copyWith({
    String? result,
    String? documentation,
    String? termsOfUse,
    int? timeLastUpdateUnix, // ✅ CORRECTED
    String? timeLastUpdateUtc,
    int? timeNextUpdateUnix,
    String? timeNextUpdateUtc,
    String? baseCode,
    Map<String, dynamic>? bpi,
  }) {
    return Currencymodel(
      result: result ?? this.result,
      documentation: documentation ?? this.documentation,
      termsOfUse: termsOfUse ?? this.termsOfUse,
      timeLastUpdateUnix: timeLastUpdateUnix ?? this.timeLastUpdateUnix, // ✅
      timeLastUpdateUtc: timeLastUpdateUtc ?? this.timeLastUpdateUtc,
      timeNextUpdateUnix: timeNextUpdateUnix ?? this.timeNextUpdateUnix,
      timeNextUpdateUtc: timeNextUpdateUtc ?? this.timeNextUpdateUtc,
      baseCode: baseCode ?? this.baseCode,
      bpi: bpi ?? this.bpi,
    );
  }

  @override
  String toString() {
    return 'Currencymodel(result: $result, documentation: $documentation, termsOfUse: $termsOfUse, timeLastUpdateUnix: $timeLastUpdateUnix, timeLastUpdateUtc: $timeLastUpdateUtc, timeNextUpdateUnix: $timeNextUpdateUnix, timeNextUpdateUtc: $timeNextUpdateUtc, baseCode: $baseCode, bpi: $bpi)';
  }

  @override
  bool operator ==(covariant Currencymodel other) {
    if (identical(this, other)) return true;

    return other.result == result &&
        other.documentation == documentation &&
        other.termsOfUse == termsOfUse &&
        other.timeLastUpdateUnix == timeLastUpdateUnix && // ✅
        other.timeLastUpdateUtc == timeLastUpdateUtc &&
        other.timeNextUpdateUnix == timeNextUpdateUnix &&
        other.timeNextUpdateUtc == timeNextUpdateUtc &&
        other.baseCode == baseCode &&
        mapEquals(other.bpi, bpi);
  }

  @override
  int get hashCode {
    return result.hashCode ^
        documentation.hashCode ^
        termsOfUse.hashCode ^
        timeLastUpdateUnix.hashCode ^
        timeLastUpdateUtc.hashCode ^
        timeNextUpdateUnix.hashCode ^
        timeNextUpdateUtc.hashCode ^
        baseCode.hashCode ^
        bpi.hashCode;
  }
}
