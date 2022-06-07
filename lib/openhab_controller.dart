import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models.dart';

class OpenHABController {
  static final OpenHABController _openHABController =
      OpenHABController._internal();

  final String baseUrl = "https://home.myopenhab.org/rest/";
  final String _email = "fkozjak@yahoo.com";
  final String _password = "Iotprojekt2022";

  late String _items;
  late String _lamp;

  factory OpenHABController() {
    return _openHABController;
  }

  OpenHABController._internal() {
    _items = "${baseUrl}items/";
    _lamp = "${_items}Huego1_Color";
  }

  // radi
  void postIllumination() async {
    Map<String, String> headers = _getPostHeaders();

    var data = 'ON';

    var url = Uri.parse(_lamp);
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    print(res.body);
  }

  // provjerit
  Future<IlluminationModel> fetchIllumination() async {
    var url = Uri.parse(baseUrl);
    var headers = _getGetHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return IlluminationModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load illumination');
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
  Future<TermostatModel> fetchTermostat() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),

      //autentifikacija
      headers: {
        HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return TermostatModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load termostat');
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
