import 'package:flutter/material.dart';

import 'package:volcontrol/services/volume-control.dart';

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
  Map volData = {
    'level': 0,
    'isMute': false,
    'icon': Icons.volume_mute
  };

  void setupVolume() async {
    VolumeControl vc = VolumeControl(volLevel: 0);
    await vc.getVol();
    setState(() {
      volData = {
        'level': vc.volLevel,
        'isMute': vc.isMute,
      };
    });
  }

  @override
  void initState() {
    super.initState();
    setupVolume();
  }

  @override
  Widget build(BuildContext context) {
    IconData speaker = volData['isMute'] ? Icons.volume_off : Icons.volume_mute;
    VolumeControl vc = VolumeControl(volLevel: volData['level']);
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
            volData['level'].toString(),
            style: TextStyle(
              fontSize: 26
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  await vc.volUpDown(false);
                  setState(() {
                    volData['level'] = vc.volLevel;
                  });
                },
                icon: Icon(Icons.volume_down),
                color: Colors.blueGrey[900],
                iconSize: 40,
              ),
              Expanded(
                child: Slider(
                  onChanged: (double newVal) {
                    setState(() {
                      volData['level'] = newVal.round();
                    });
                  },
                  onChangeEnd: (double newVal) async {
                    await vc.setVol(newVal.round());
                    setState(() {
                      volData['level'] = vc.volLevel;
                    });
                  },
                  min: 0,
                  max: 100,
//        divisions: 50,
                  value: volData['level'].toDouble(),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await vc.volUpDown(true);
                  setState(() {
                    volData['level'] = vc.volLevel;
                  });
                },
                icon: Icon(Icons.volume_up),
                color: Colors.blueGrey[900],
                iconSize: 40,
              ),
            ],
          ),
          IconButton(
            onPressed: () async {
              await vc.muteUnmute(volData['isMute']);
              setState(() {
                volData['isMute'] = vc.isMute;
              });
            },
            icon: Icon(speaker),
            color: Colors.blueGrey[900],
            iconSize: 60,
          )
        ],
      )
    );
  }
}
