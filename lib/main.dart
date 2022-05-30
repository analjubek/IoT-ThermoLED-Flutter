import 'package:flutter/material.dart';
import 'package:projekt/illumination.dart';
import 'package:projekt/temperature.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('ThermoLED'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            Expanded(
              child: ButtonTheme(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 100),
                      textStyle: const TextStyle(fontSize: 20),
                      primary: Colors.blueAccent,
                      onPrimary: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.thermostat,
                      size: 30,
                    ),
                    label: const Text(
                      'Temperatura',
                    ),
                    //onPressed: () {},
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => (Temperature())),
                      );
                    }),
              ),
            ),
            Spacer(),
            Expanded(
              child: ButtonTheme(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(300, 100),
                    textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.light_mode_outlined,
                    size: 30,
                  ),
                  label: const Text(
                    'Osvjetljenje',
                  ),
                  //onPressed: () {},
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => (Illumination())),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
