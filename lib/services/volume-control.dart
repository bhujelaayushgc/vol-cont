import 'package:http/http.dart' as http;
import 'dart:convert';

class VolumeControl {
  int volLevel;
  bool isMute = false;

  VolumeControl({ this.volLevel });

  Future<void> muteUnmute(bool __isMute) async {
    String type = 'mute';
    if (__isMute) {
      type = 'unmute';
    }
    http.Response response = await http.post('http://192.168.0.104:3000/$type');
    isMute = jsonDecode(response.body)['isMute'];
  }

  Future<void> getVol() async {
    http.Response response = await http.get('http://192.168.0.104:3000/vol');
    volLevel = jsonDecode(response.body)['current_vol'];
  }

  Future<void> setVol(int vol) async {
    Map data = {
      'volLevel': vol
    };
    http.Response response = await http.post(
      'http://192.168.0.104:3000/vol',
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
//      headers: {"Content-Type": "application/json"}
    );
    volLevel = jsonDecode(response.body)['current_vol'];
  }

  Future<void> volUpDown(bool isUp) async {
    String path = 'vol-down';
    if (isUp) {
      path = 'vol-up';
    }
    http.Response response = await http.post('http://192.168.0.104:3000/$path');
    volLevel = jsonDecode(response.body)['current_vol'];
  }
}