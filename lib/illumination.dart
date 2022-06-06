import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'chartdata.dart';

Future<IlluminationModel> fetchIllumination() async {
  final response = await http.get(
    Uri.parse('home.myopenhab.org'),

    //autentifikacija
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return IlluminationModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load illumination');
  }
}

// trebalo bi raditi (nije testirano)
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

// ne radi (jos)
/*Future<IlluminationModel> postIllumination() async {
  final response = await http.post(
    Uri.parse('https://home.myopenhab.org/rest/items/Huego1_Color'),
    headers: <String, String>{
      'Content-Type': 'text/plain',
      'Accept': "application/json"
    },
    body: jsonEncode(<String, String>{
      'd': "ON",
      'u': "fkozjak@yahoo.com:Iotprojekt2022",
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return IlluminationModel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to change illumination.');
  }
}*/

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

class Illumination extends StatefulWidget {
  @override
  _IlluminationState createState() => new _IlluminationState();
}

class _IlluminationState extends State<Illumination> {
  bool illuminationStatus = true;

  late Future<IlluminationModel> futureIllumination;

  late ChartData chartData;

  @override
  void initState() {
    super.initState();
    futureIllumination = fetchIllumination();
  }

  @override
  Widget build(BuildContext context) {
    chartData = new ChartData(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Osvjetljenje'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 10,
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
                        "Osvjetljenje uključeno",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    FlutterSwitch(
                      //width: 125.0,
                      height: 30.0,
                      //toggleSize: 20.0,
                      value: illuminationStatus,
                      //padding: 8.0,
                      onToggle: (val) {
                        postIllumination();
                        setState(() {
                          illuminationStatus = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (illuminationStatus)
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "Boja\nosvjetljenja",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 25, right: 25),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(10.0),
                                topRight: const Radius.circular(10.0),
                                bottomLeft: const Radius.circular(10.0),
                                bottomRight: const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            "Razina\nosvjetljenja",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.all(5),
                          child: /*FutureBuilder<IlluminationModel>(
                          future: futureIllumination,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "${snapshot.data!.name} %",
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
                            "90 %",
                            style: TextStyle(fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              Container(
                height: 10,
              ),
              Text("Razina osvjetljenja posljednja 24 sata"),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                padding: const EdgeInsets.all(5),
                child: Container(
                    child: BezierChart(
                        bezierChartScale: BezierChartScale.HOURLY,
                        bezierChartAggregation: BezierChartAggregation.AVERAGE,
                        fromDate: chartData.todayBegin,
                        toDate: chartData.todayEnd,
                        config: chartData.bezierChartConfig,
                        series: [
                      BezierLine(
                          lineColor: Colors.black,
                          dataPointFillColor: Colors.black,
                          onMissingValue: (dateTime) {
                            return 0.0;
                          },
                          data: chartData.todayLight),
                    ])),
              ),
              Container(
                height: 10,
              ),
              Text("Razina osvjetljenja posljednjih 7 dana"),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                padding: const EdgeInsets.all(5),
                child: Container(
                  child: BezierChart(
                      bezierChartScale: BezierChartScale.WEEKLY,
                      bezierChartAggregation: BezierChartAggregation.AVERAGE,
                      fromDate: chartData.weekBegin,
                      toDate: chartData.todayEnd,
                      config: chartData.bezierChartConfig,
                      series: [
                        BezierLine(
                            lineColor: Colors.black,
                            dataPointFillColor: Colors.black,
                            onMissingValue: (dateTime) {
                              return 0.0;
                            },
                            data: chartData.weeklyLight),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
