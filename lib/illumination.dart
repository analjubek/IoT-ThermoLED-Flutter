import 'package:flutter/material.dart';

class Illumination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                          "Svjetlina\nosvjetljenja",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "90 %",
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 300,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      child: Text(
                        "\nBoja osvjetljenja\n24 sata",
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
                        "\nSvjetlina osvjetljenja\n24 sata",
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
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 300,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      child: Text(
                        "\nBoja osvjetljenja\n7 dana",
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
                        "\nSvjetlina osvjetljenja\n7 dana",
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
