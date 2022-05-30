import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'dart:async';
import 'package:day_picker/day_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Temperature extends StatefulWidget {
  @override
  _TemperatureState createState() => new _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
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

  TimeOfDay startTime = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay endTime = TimeOfDay(hour: 11, minute: 30);

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
                      child: Text(
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
                    child: Container(
                      child: Text(
                        "\nTemperatura\n24 sata",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(5),
                          topRight: const Radius.circular(5),
                          bottomLeft: const Radius.circular(5),
                          bottomRight: const Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 300,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      child: Text(
                        "\nTemperatura\n7 dana",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(5),
                          topRight: const Radius.circular(5),
                          bottomLeft: const Radius.circular(5),
                          bottomRight: const Radius.circular(5),
                        ),
                      ),
                    ),
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