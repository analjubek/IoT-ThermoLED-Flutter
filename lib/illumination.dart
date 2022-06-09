import 'dart:async';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:projekt/models.dart';
import 'package:projekt/openhab_controller.dart';
import 'package:flutter_color_models/flutter_color_models.dart';

import 'chartdata.dart';

class Illumination extends StatefulWidget {
  @override
  _IlluminationState createState() => new _IlluminationState();
}

class _IlluminationState extends State<Illumination> {
  bool illuminationStatus = true;

  late Future<dynamic> isChartLoaded;
  late Future<dynamic> isColorLoaded;

  late OpenHABController openHABController;

  late Color lampColor = Colors.white;

  late ChartData chartData = ChartData();

  @override
  void initState() {
    super.initState();
    openHABController = OpenHABController();
    setState(() {
      isColorLoaded = getLampColor();
      isChartLoaded = getChartData(context);
    });
  }

  getChartData(BuildContext context) async {
    chartData = await openHABController.fetchIllumination();
    return Future.value(true);
  }

  getLampColor() async {
    lampColor = await openHABController.fetchColor();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    print(chartData.todayLight);

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
                        openHABController.toggleLamp(val);
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
                          child: FutureBuilder(
                            future: isChartLoaded,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.none &&
                                  snapshot.hasData) {
                                return Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      topRight: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                      bottomRight: const Radius.circular(10.0),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                decoration: new BoxDecoration(
                                  color: lampColor,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0),
                                  ),
                                ),
                              );
                            },
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
                                FutureBuilder(
                                    future: isChartLoaded,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.none &&
                                          snapshot.hasData) {
                                        return Text(
                                          "90",
                                          style: TextStyle(fontSize: 40),
                                          textAlign: TextAlign.center,
                                        );
                                      }
                                      return Text(
                                        chartData.currentLight,
                                        style: TextStyle(fontSize: 40),
                                        textAlign: TextAlign.center,
                                      );
                                    })),
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
                  child: FutureBuilder(
                      future: isChartLoaded,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none &&
                            snapshot.hasData) {
                          return Container();
                        }
                        //var chartData = openHABController.chartData;
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
                                  data: chartData.todayLight),
                            ]);
                      })),
              Container(
                height: 10,
              ),
              Text("Razina osvjetljenja posljednjih 7 dana"),
              Container(
                width: MediaQuery.of(context).size.width - 20,
                height: 300,
                padding: const EdgeInsets.all(5),
                child: FutureBuilder(
                  future: isChartLoaded,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.none &&
                        snapshot.hasData) {
                      return Container();
                    }
                    //var chartData = openHABController.chartData;
                    return BezierChart(
                        bezierChartScale: BezierChartScale.WEEKLY,
                        bezierChartAggregation: BezierChartAggregation.AVERAGE,
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
                              data: chartData.weeklyLight),
                        ]);
                  },
                ),
              ),
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
