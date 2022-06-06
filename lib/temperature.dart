import 'dart:convert';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'dart:async';
import 'package:day_picker/day_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:projekt/chartdata.dart';

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

// RADI --> paljenje/gasenje lampe - TESTIRANO
void postIllumination() async {
  var uname = 'fkozjak@yahoo.com';
  var pword = 'Iotprojekt2022';
  var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

  var headers = {
    'Content-Type': 'text/plain',
    'Accept': 'application/json',
    'Authorization': authn,
  };

  var data = 'ON';

  var url = Uri.parse('https://home.myopenhab.org/rest/items/Huego1_Color');
  var res = await http.post(url, headers: headers, body: data);
  if (res.statusCode != 200)
    throw Exception('http.post error: statusCode= ${res.statusCode}');
  print(res.body);
}

class IlluminationModel {
  String? link;
  String? state;
  bool? editable;
  String? type;
  String? name;
  String? label;
  String? category;
  List<String>? tags;
  List<String>? groupNames;

  IlluminationModel(
      {this.link,
      this.state,
      this.editable,
      this.type,
      this.name,
      this.label,
      this.category,
      this.tags,
      this.groupNames});

  IlluminationModel.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    state = json['state'];
    editable = json['editable'];
    type = json['type'];
    name = json['name'];
    label = json['label'];
    category = json['category'];
    tags = json['tags'].cast<String>();
    groupNames = json['groupNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['state'] = this.state;
    data['editable'] = this.editable;
    data['type'] = this.type;
    data['name'] = this.name;
    data['label'] = this.label;
    data['category'] = this.category;
    data['tags'] = this.tags;
    data['groupNames'] = this.groupNames;
    return data;
  }
}

/*
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
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return TermostatModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to change termostat.');
  }
}*/

class TermostatModel {
  final int userId;
  final int id;
  final String title;

  const TermostatModel({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory TermostatModel.fromJson(Map<String, dynamic> json) {
    return TermostatModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class Temperature extends StatefulWidget {
  @override
  _TemperatureState createState() => new _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  late Future<TermostatModel> futureTermostat;

  @override
  void initState() {
    super.initState();
    futureTermostat = fetchTermostat();
  }

  bool termostatStatus = true;

  int _currentTemperature = 20;
  late NumberPicker temperaturePicker;

  _handleTemperatureChanged(num value) {
    if (value != null) {
      if (value is int) {
        setState(() => _currentTemperature = value);
      }
    }
  }

  bool scheduleStatus = true;

  List<DayInWeek> _days = [
    DayInWeek(
      "Ponedjeljak",
    ),
    DayInWeek(
      "Utorak",
    ),
    DayInWeek(
      "Srijeda",
    ),
    DayInWeek(
      "Četvrtak",
    ),
    DayInWeek(
      "Petak",
    ),
    DayInWeek(
      "Subota",
    ),
    DayInWeek(
      "Nedjelja",
    ),
  ];

  TimeOfDay startTime = TimeOfDay(hour: 15, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 22, minute: 30);

  ChartData chartData = new ChartData();

  @override
  Widget build(BuildContext context) {
    final startHours = startTime.hour.toString().padLeft(2, '0');
    final startMinutes = startTime.minute.toString().padLeft(2, '0');

    final endHours = endTime.hour.toString().padLeft(2, '0');
    final endMinutes = endTime.minute.toString().padLeft(2, '0');

    // s ovim se mogu podesavati boje, velicina itd
    BezierChartConfig bezierConfig = BezierChartConfig();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Temperatura'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              /*ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[100]),
                ),
                child: Text(
                  'Click button',
                  style: TextStyle(fontSize: 32, color: Colors.blue),
                ),
                onPressed: () {
                  getUserData();
                },
              ),*/
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "Trenutna temperatura",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: /*FutureBuilder<TermostatModel>(
                        future: futureTermostat,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              "${snapshot.data!.id}°C",
                              style: TextStyle(fontSize: 40),
                              textAlign: TextAlign.center,
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),*/
                          Text(
                        "27°C",
                        style: TextStyle(fontSize: 50),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.grey[200],
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Termostat uključen",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    FlutterSwitch(
                      //width: 125.0,
                      height: 30.0,
                      //toggleSize: 20.0,
                      value: termostatStatus,
                      //padding: 8.0,
                      onToggle: (val) {
                        postIllumination();
                        setState(() {
                          termostatStatus = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (termostatStatus)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "Željena temperatura (°C)",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      NumberPicker(
                        axis: Axis.horizontal,
                        minValue: 15,
                        maxValue: 30,
                        value: _currentTemperature,
                        onChanged: _handleTemperatureChanged,
                      ),
                    ],
                  ),
                ),
              if (termostatStatus)
                Container(
                  color: Colors.grey[200],
                  height: 50,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Postavljanje rasporeda",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FlutterSwitch(
                        //width: 125.0,
                        height: 30.0,
                        //toggleSize: 20.0,
                        value: scheduleStatus,
                        //padding: 8.0,
                        onToggle: (val) {
                          setState(() {
                            scheduleStatus = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              if (termostatStatus & scheduleStatus)
                Container(
                  height: 10,
                ),
              if (termostatStatus & scheduleStatus)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectWeekDays(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    days: _days,
                    border: false,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                        tileMode: TileMode
                            .repeated, // repeats the gradient over the canvas
                      ),
                    ),
                    onSelect: (values) {
                      // <== Callback to handle the selected days
                      print(values);
                    },
                  ),
                ),
              if (termostatStatus & scheduleStatus)
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Vrijeme paljenja",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[100]),
                            ),
                            child: Text(
                              '${startHours}:${startMinutes}',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.blue),
                            ),
                            onPressed: () async {
                              TimeOfDay? newStartTime = await showTimePicker(
                                  cancelText: "ODUSTANI",
                                  confirmText: "SPREMI",
                                  context: context,
                                  initialTime: startTime);
                              if (newStartTime == null) return;
                              setState(() {
                                startTime = newStartTime;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Vrijeme gašenja",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey[100]),
                            ),
                            child: Text(
                              '${endHours}:${endMinutes}',
                              style:
                                  TextStyle(fontSize: 32, color: Colors.blue),
                            ),
                            onPressed: () async {
                              TimeOfDay? newEndTime = await showTimePicker(
                                  cancelText: "ODUSTANI",
                                  confirmText: "SPREMI",
                                  context: context,
                                  initialTime: endTime);
                              if (newEndTime == null) return;
                              setState(() {
                                endTime = newEndTime;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              Container(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 300,
                    padding: const EdgeInsets.all(5),
                    child: BezierChart(
                        bezierChartScale: BezierChartScale.HOURLY,
                        bezierChartAggregation: BezierChartAggregation.AVERAGE,
                        fromDate: chartData.todayBegin,
                        toDate: chartData.todayEnd,
                        series: [
                          BezierLine(
                              lineColor: Colors.black,
                              dataPointFillColor: Colors.black,
                              onMissingValue: (dateTime) {
                                return 0.0;
                              },
                              data: chartData.todayTemp),
                        ]),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 300,
                    padding: const EdgeInsets.all(5),
                    child: BezierChart(
                        bezierChartScale: BezierChartScale.HOURLY,
                        bezierChartAggregation: BezierChartAggregation.AVERAGE,
                        fromDate: chartData.weekBegin,
                        toDate: chartData.todayEnd,
                        series: [
                          BezierLine(
                              lineColor: Colors.black,
                              dataPointFillColor: Colors.black,
                              onMissingValue: (dateTime) {
                                return 0.0;
                              },
                              data: chartData.weeklyTemp),
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
