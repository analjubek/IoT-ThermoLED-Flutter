part of 'measurement.dart';

Measurement _$MeasurementFromJson(Map<String, dynamic> json) {
  return Measurement(
    json['time'] as int,
    json['state'] as String,
  );
}

Map<String, dynamic> _$MeasurementToJson(Measurement instance) =>
    <String, dynamic>{
      'time': instance.time,
      'state': instance.state,
    };
