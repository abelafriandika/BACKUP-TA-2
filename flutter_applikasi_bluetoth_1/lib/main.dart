import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart'; // Ganti dengan paket Bluetooth yang Anda gunakan
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Sensor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? esp32Device;
  bool isConnected = false;
  String temperature = 'N/A';

  @override
  void initState() {
    super.initState();
    // Mencari perangkat Bluetooth yang diinginkan (ESP32) saat aplikasi dibuka.
    scanForDevices();
  }

  void scanForDevices() {
    flutterBlue.scan(timeout: Duration(seconds: 5)).listen((scanResult) {
      if (scanResult.device.name == 'ESP32') {
        setState(() {
          esp32Device = scanResult.device;
        });
      }
    });
  }

  void connectToDevice() async {
    if (esp32Device != null) {
      await esp32Device!.connect();
      setState(() {
        isConnected = true;
      });
      // Mulai mendengarkan data dari ESP32.
      esp32Device!.setNotifyValue(serviceUuid, characteristicUuid, true);
      esp32Device!.onValueChanged.listen((value) {
        String data = utf8.decode(value);
        setState(() {
          temperature = data;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32 Sensor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Suhu:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              temperature,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            isConnected
                ? Text('Terhubung ke ESP32')
                : ElevatedButton(
                    onPressed: connectToDevice,
                    child: Text('Hubungkan ke ESP32'),
                  ),
          ],
        ),
      ),
    );
  }
}
