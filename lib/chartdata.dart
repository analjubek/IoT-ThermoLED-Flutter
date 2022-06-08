import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class ChartData {
  double currentLight = 90;
  double currentTemp = 25.0;

  List<DataPoint<DateTime>> todayLight = [];
  List<DataPoint<DateTime>> todayTemp = [];

  List<DataPoint<DateTime>> weeklyLight = [];
  List<DataPoint<DateTime>> weeklyTemp = [];

  DateTime todayBegin = DateTime.now().subtract(Duration(days: 1));
  DateTime weekBegin = DateTime.now().subtract(Duration(days: 7));
  DateTime todayEnd = DateTime.now();

  ChartData.chartDataWithTemp(TermostatModel termostatModel) {
    ChartData();
  }

  ChartData.chartDataWithLight(IlluminationModel illuminationModel) {
    ChartData();
  }

  ChartData.empty();

  ChartData() {
    todayLight.add(new DataPoint(
        value: 60.0, xAxis: todayBegin.add(Duration(minutes: 30))));
    todayLight.add(new DataPoint(
        value: 62.0, xAxis: todayBegin.add(Duration(minutes: 60))));
    todayLight.add(new DataPoint(
        value: 53.0, xAxis: todayBegin.add(Duration(minutes: 90))));
    todayLight.add(new DataPoint(
        value: 70.0, xAxis: todayBegin.add(Duration(minutes: 120))));
    todayLight.add(new DataPoint(
        value: 80.0, xAxis: todayBegin.add(Duration(minutes: 150))));
    todayLight.add(new DataPoint(
        value: 90.0, xAxis: todayBegin.add(Duration(minutes: 180))));
    todayLight.add(new DataPoint(
        value: 80.0, xAxis: todayBegin.add(Duration(minutes: 210))));
    todayLight.add(new DataPoint(
        value: 81.0, xAxis: todayBegin.add(Duration(minutes: 240))));
    todayLight.add(new DataPoint(
        value: 74.0, xAxis: todayBegin.add(Duration(minutes: 270))));

    todayTemp.add(new DataPoint(
        value: 19.0, xAxis: todayBegin.add(Duration(minutes: 30))));
    todayTemp.add(new DataPoint(
        value: 20.0, xAxis: todayBegin.add(Duration(minutes: 60))));
    todayTemp.add(new DataPoint(
        value: 20.0, xAxis: todayBegin.add(Duration(minutes: 90))));
    todayTemp.add(new DataPoint(
        value: 21.0, xAxis: todayBegin.add(Duration(minutes: 120))));
    todayTemp.add(new DataPoint(
        value: 23.0, xAxis: todayBegin.add(Duration(minutes: 150))));
    todayTemp.add(new DataPoint(
        value: 25.0, xAxis: todayBegin.add(Duration(minutes: 180))));
    todayTemp.add(new DataPoint(
        value: 27.0, xAxis: todayBegin.add(Duration(minutes: 210))));
    todayTemp.add(new DataPoint(
        value: 25.0, xAxis: todayBegin.add(Duration(minutes: 240))));
    todayTemp.add(new DataPoint(
        value: 23.0, xAxis: todayBegin.add(Duration(minutes: 270))));

    weeklyTemp.add(
        new DataPoint(value: 19.0, xAxis: todayBegin.add(Duration(hours: 12))));
    weeklyTemp.add(
        new DataPoint(value: 20.0, xAxis: todayBegin.add(Duration(hours: 24))));
    weeklyTemp.add(
        new DataPoint(value: 20.0, xAxis: todayBegin.add(Duration(hours: 36))));
    weeklyTemp.add(
        new DataPoint(value: 21.0, xAxis: todayBegin.add(Duration(hours: 48))));
    weeklyTemp.add(
        new DataPoint(value: 23.0, xAxis: todayBegin.add(Duration(hours: 60))));
    weeklyTemp.add(
        new DataPoint(value: 25.0, xAxis: todayBegin.add(Duration(hours: 72))));
    weeklyTemp.add(
        new DataPoint(value: 27.0, xAxis: todayBegin.add(Duration(hours: 84))));
    weeklyTemp.add(
        new DataPoint(value: 25.0, xAxis: todayBegin.add(Duration(hours: 96))));
    weeklyTemp.add(new DataPoint(
        value: 23.0, xAxis: todayBegin.add(Duration(hours: 108))));

    weeklyLight.add(
        new DataPoint(value: 60.0, xAxis: todayBegin.add(Duration(hours: 12))));
    weeklyLight.add(
        new DataPoint(value: 62.0, xAxis: todayBegin.add(Duration(hours: 24))));
    weeklyLight.add(
        new DataPoint(value: 53.0, xAxis: todayBegin.add(Duration(hours: 36))));
    weeklyLight.add(
        new DataPoint(value: 70.0, xAxis: todayBegin.add(Duration(hours: 48))));
    weeklyLight.add(
        new DataPoint(value: 80.0, xAxis: todayBegin.add(Duration(hours: 60))));
    weeklyLight.add(
        new DataPoint(value: 90.0, xAxis: todayBegin.add(Duration(hours: 72))));
    weeklyLight.add(
        new DataPoint(value: 80.0, xAxis: todayBegin.add(Duration(hours: 84))));
    weeklyLight.add(
        new DataPoint(value: 81.0, xAxis: todayBegin.add(Duration(hours: 96))));
    weeklyLight.add(new DataPoint(
        value: 74.0, xAxis: todayBegin.add(Duration(hours: 108))));
  }

  BezierChartConfig getBezierChartConfig(BuildContext context) {
    return BezierChartConfig(
        contentWidth: MediaQuery.of(context).size.width / 2,
        footerHeight: 30.0,
        verticalIndicatorStrokeWidth: 3.0,
        verticalIndicatorColor: Colors.black26,
        showVerticalIndicator: true,
        verticalIndicatorFixedPosition: true,
        snap: false,
        backgroundColor: Colors.grey[200],
        bubbleIndicatorColor: Colors.blue,
        displayYAxis: true,
        stepsYAxis: 10,
        startYAxisFromNonZeroValue: true,
        //bubbleIndicatorValueFormat: NumberFormat("#####", "en_US"),
        bubbleIndicatorValueStyle:
            TextStyle(color: Colors.blue, fontSize: 15.0),
        bubbleIndicatorLabelStyle: TextStyle(color: Colors.blue),
        bubbleIndicatorTitleStyle:
            TextStyle(color: Colors.blue, fontSize: 15.0),
        xAxisTextStyle: TextStyle(color: Colors.blue, fontSize: 10.0),
        yAxisTextStyle: TextStyle(color: Colors.blue, fontSize: 10.0));
  }
}
