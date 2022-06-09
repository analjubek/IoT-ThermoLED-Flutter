import 'dart:async';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:projekt/chartdata.dart';
import 'package:projekt/openhab_controller.dart';

import 'models.dart';

class Temperature extends StatefulWidget {
  @override
  _TemperatureState createState() => new _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  late OpenHABController openHABController;
  late Future<dynamic> isLoaded;
  late ChartData chartData = ChartData();

  @override
  void initState() {
    super.initState();
    openHABController = OpenHABController();
    setState(() {
      isLoaded = openHABController.fetchTermostat();
    });
  }

  bool termostatStatus = false;

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

  @override
  Widget build(BuildContext context) {
    final startHours = startTime.hour.toString().padLeft(2, '0');
    final startMinutes = startTime.minute.toString().padLeft(2, '0');

    final endHours = endTime.hour.toString().padLeft(2, '0');
    final endMinutes = endTime.minute.toString().padLeft(2, '0');

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
                          openHABController.toggleLamp(val);
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
              Text("Temperatura posljednja 24 sata"),
              Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 300,
                  padding: const EdgeInsets.all(5),
                  child: FutureBuilder(
                    future: isLoaded,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none &&
                          snapshot.hasData) {
                        return Container();
                      }
                      return BezierChart(
                          bezierChartScale: BezierChartScale.HOURLY,
                          bezierChartAggregation:
                              BezierChartAggregation.AVERAGE,
                          fromDate: chartData.todayBegin,
                          toDate: chartData.todayEnd,
                          config: chartData.getBezierChartConfig(context),
                          series: [
                            BezierLine(
                              lineColor: Colors.black,
                              dataPointFillColor: Colors.black,
                              onMissingValue: (dateTime) {
                                return 0.0;
                              },
                              data: chartData.todayTemp,
                            ),
                          ]);
                    },
                  )),
              Container(
                height: 10,
              ),
              Text("Temperatura posljednjih 7 dana"),
              Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 300,
                  padding: const EdgeInsets.all(5),
                  child: FutureBuilder(
                    future: isLoaded,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none &&
                          snapshot.hasData) {
                        return Container();
                      }
                      return BezierChart(
                          bezierChartScale: BezierChartScale.WEEKLY,
                          bezierChartAggregation:
                              BezierChartAggregation.AVERAGE,
                          fromDate: chartData.weekBegin,
                          toDate: chartData.todayEnd,
                          config: chartData.getBezierChartConfig(context),
                          series: [
                            BezierLine(
                                lineColor: Colors.black,
                                dataPointFillColor: Colors.black,
                                onMissingValue: (dateTime) {
                                  return 0.0;
                                },
                                data: chartData.weeklyTemp),
                          ]);
                    },
                  )),
              Container(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
