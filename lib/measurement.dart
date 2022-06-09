import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'measurement.g.dart';

@JsonSerializable()
class Measurement {
  int time;
  String state;

  Measurement(this.time, this.state);

  factory Measurement.fromJson(Map<String, dynamic> json) =>
      _$MeasurementFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementToJson(this);
}
