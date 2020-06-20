import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home()
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int volLevel = 50;

  void getVol() async {
    http.Response response = await http.get('http://192.168.0.104:3000/vol');
    setState(() {
      volLevel = jsonDecode(response.body)['current_vol'];
    });
  }

  void setVol(int vol) async {
    Map data = {
      'volLevel': vol
    };
    http.Response response = await http.post(
      'http://192.168.0.104:3000/vol',
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
//      headers: {"Content-Type": "application/json"}
    );
    setState(() {
      volLevel = jsonDecode(response.body)['current_vol'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          'Volume Control'
        )
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            volLevel.toString(),
            style: TextStyle(
              fontSize: 26
            ),
          ),
          Slider(
            onChanged: (double newVal) {
              setState(() {
                volLevel = newVal.round();
              });
            },
            onChangeEnd: (double newVal) {
              setVol(newVal.round());
            },
            min: 0,
            max: 100,
//        divisions: 50,
            value: volLevel.toDouble(),
          )
        ],
      )
    );
  }
}
