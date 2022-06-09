import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projekt/chartdata.dart';
import 'package:projekt/list_measurement.dart';

import 'models.dart';

class OpenHABController {
  static final OpenHABController _openHABController =
      OpenHABController._internal();

  final String baseUrl = "https://home.myopenhab.org/rest/";
  final String _email = "fkozjak@yahoo.com";
  final String _password = "Iotprojekt2022";

  late String _items;
  late String _lamp;
  late String _temperature;
  late String _brightness;
  late String _tempChart;
  late String _lightChart;
  late ChartData chartData = ChartData.empty();
  late LampColor lampColor = LampColor.empty();

  DateTime weekBegin = DateTime.now().subtract(Duration(days: 7));
  DateTime todayEnd = DateTime.now();

  factory OpenHABController() {
    return _openHABController;
  }

  OpenHABController._internal() {
    _items = "${baseUrl}items/";
    _lamp = "${_items}Huego1_Color";
    _temperature = "${_items}TemperatureSensor_TemperatureSensor";
    _brightness = "${_items}BrightnessSensor_BrightnessValue";
    _tempChart =
        "${baseUrl}persistence/items/TemperatureSensor_TemperatureSensor";
    _lightChart =
        "${baseUrl}persistence/items/BrightnessSensor_BrightnessValue";
  }

  void toggleLamp(bool turnOn) async {
    Map<String, String> headers = _getPostHeaders();

    var data = turnOn ? 'ON' : 'OFF';

    var url = Uri.parse(_lamp);
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) {
      print(res);
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    print(res.body);
  }

  Future<ChartData> fetchIllumination() async {
    var url = Uri.parse(_brightness);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      var illumination = IlluminationModel.fromJson(jsonDecode(response.body));
      return ChartData.chartDataWithLight(illumination);
    } else {
      print(response.body);
      throw Exception('Failed to load illumination');
    }
  }

  Future<Color> fetchColor() async {
    var url = Uri.parse(_lamp);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      lampColor = LampColor.fromJson(jsonDecode(response.body));
      HSVColor hsvColor = HSVColor.fromAHSV(0.5, lampColor.r.toDouble(),
          lampColor.g.toDouble() / 100, lampColor.b.toDouble() / 100);
      print("hsv color" + hsvColor.toString());
      Color color = hsvColor.toColor();
      print("color " + color.toString());
      return color;
    } else {
      print(response);
      throw Exception('Failed to fetch illumination color.');
    }
  }

// provjerit
  // promijeni request
  Future<TermostatModel> changeTermostat(String title) async {
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
      }),
    );

    if (response.statusCode == 201) {
      return TermostatModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to change termostat.');
    }
  }

  // promijenit
  Future<dynamic> fetchTermostat() async {
    var url = Uri.parse(_temperature);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print("FETCH " + response.body);
      chartData = ChartData.chartDataWithTemp(jsonDecode(response.body));
      return Future.value(true);
    } else {
      print(response.body);
      throw Exception('Failed to load illumination');
    }
  }

  Future<ChartData> fetchLightChart() async {
    final DateFormat dateformatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeformatter = DateFormat('hh:mm:ss');
    var begin = dateformatter.format(weekBegin) +
        "T" +
        timeformatter.format(weekBegin) +
        "Z";
    var end = dateformatter.format(todayEnd) +
        "T" +
        timeformatter.format(todayEnd) +
        "Z";

    print("BASE " + begin);
    print("BASE " + end);

    var base = _lightChart + "?starttime=" + begin + "&endttime=" + end;
    print("BASE " + base);

    var url = Uri.parse(base);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      var listMeasurements =
          ListMeasurement.fromJson(jsonDecode(response.body));
      return ChartData.chartDataWithChart(listMeasurements);
    } else {
      print(response);
      throw Exception('Failed to fetch illumination color.');
    }
  }

  Future<ChartData> fetchTempChart() async {
    final DateFormat dateformatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeformatter = DateFormat('hh:mm:ss');
    var begin = dateformatter.format(weekBegin) +
        "T" +
        timeformatter.format(weekBegin) +
        "Z";
    var end = dateformatter.format(todayEnd) +
        "T" +
        timeformatter.format(todayEnd) +
        "Z";

    print("BASE " + begin);
    print("BASE " + end);

    var base = _tempChart + "?starttime=" + begin + "&endttime=" + end;
    print("BASE " + base);

    var url = Uri.parse(base);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response.body);
      var listMeasurements =
          ListMeasurement.fromJson(jsonDecode(response.body));
      return ChartData.chartDataWithChart(listMeasurements);
    } else {
      print(response);
      throw Exception('Failed to fetch illumination color.');
    }
  }

  Map<String, String> _getPostHeaders() {
    var headers = {
      'Content-Type': 'text/plain',
      'Accept': 'application/json',
      'Authorization': _getAuth(),
    };
    return headers;
  }

  Map<String, String> _getGetHeaders() {
    var headers = {
      'Accept': 'application/json',
      'Authorization': _getAuth(),
    };
    return headers;
  }

  String _getAuth() {
    return 'Basic ${base64Encode(utf8.encode('$_email:$_password'))}';
  }
}
