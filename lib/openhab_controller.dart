import 'dart:convert';
import 'dart:io';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:projekt/chartdata.dart';

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
  late ChartData chartData = ChartData.empty();
  late LampColor lampColor = LampColor.empty();

  factory OpenHABController() {
    return _openHABController;
  }

  OpenHABController._internal() {
    _items = "${baseUrl}items/";
    _lamp = "${_items}Huego1_Color";
    _temperature = "${_items}TemperatureSensor_TemperatureSensor";
    _brightness = "${_items}BrightnessSensor_BrightnessValue";
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

  Future<dynamic> fetchIllumination() async {
    var url = Uri.parse(_brightness);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response);
      var illumination = IlluminationModel.fromJson(jsonDecode(response.body));
      chartData = ChartData.chartDataWithLight(illumination);
      return Future.value(true);
    } else {
      print(response);
      throw Exception('Failed to load illumination');
    }
  }

  Future<dynamic> fetchColor() async {
    var url = Uri.parse(_lamp);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print(response);
      lampColor = LampColor.fromJson(jsonDecode(response.body));
      return Future.value(true);
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
      print(response);
      var temperature = TermostatModel.fromJson(jsonDecode(response.body));
      chartData = ChartData.chartDataWithTemp(temperature);
      return Future.value(true);
    } else {
      print(response);
      throw Exception('Failed to load illumination');
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
