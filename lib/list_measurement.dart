import 'package:json_annotation/json_annotation.dart';

import 'measurement.dart';

part 'list_measurement.g.dart';

@JsonSerializable(explicitToJson: true)
class ListMeasurement {
  List<Measurement> measurements;

  ListMeasurement(this.measurements);

  factory ListMeasurement.fromJson(Map<String, dynamic> json) =>
      _$ListMeasurementFromJson(json);
}
