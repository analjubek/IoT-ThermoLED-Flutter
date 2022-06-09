part of 'list_measurement.dart';

ListMeasurement _$ListMeasurementFromJson(Map<String, dynamic> json) {
  return ListMeasurement(
    (json['data'] as List<dynamic>)
        .map((e) => Measurement.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ListMeasurementToJson(ListMeasurement instance) =>
    <String, dynamic>{
      'data': instance.measurements.map((e) => e.toJson()).toList(),
    };
