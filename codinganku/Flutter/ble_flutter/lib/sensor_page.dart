import 'dart:async';
// import 'dart:convert' show utf8;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

/// Local imports
// import '../../../../../model/sample_view.dart';

Future<int> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse(
        'https://api.thingspeak.com/update?api_key=7L6BDUPGRR43WCDO&field1=$title'),
        
    // Melakukan HTTP POST request ke URL Thingspeak dengan menggunakan paket 'http'.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  //debugPrint('currentValue: $response.statusCode');
  if (response.statusCode == 200) {
    // Jika server merespons dengan kode HTTP 200 (OK), maka fungsi ini mengembalikan 200.
    // Ini menunjukkan bahwa data suhu telah berhasil dikirim ke server Thingspeak.
    return 200;
  } else {
    // Jika server merespons dengan kode selain 200, maka fungsi ini melempar pengecualian.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

class SensorPage extends StatefulWidget {
  const SensorPage({Key? key, required this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  SensorPageState createState() => SensorPageState();
}

class SensorPageState extends State<SensorPage> {
  // ignore: non_constant_identifier_names
  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  // ignore: non_constant_identifier_names
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady;
  late Stream<List<int>> stream;
  List<double> traceDust = <double>[];

  // ignore: library_private_types_in_public_api
  List<_ChartData>? chartData;
  late int count;
  // ignore: unused_field
  ChartSeriesController? _chartSeriesController;

  @override
  void dispose() {
    chartData!.clear();
    _chartSeriesController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
    count = 0;
    chartData = <_ChartData>[
      _ChartData(0, 0),
      // _ChartData(1, 47),
      // _ChartData(2, 33),
      // _ChartData(3, 49),
      // _ChartData(4, 54),
      // _ChartData(5, 41),
      // _ChartData(6, 58),
      // _ChartData(7, 51),
      // _ChartData(8, 98),
      // _ChartData(9, 41),
      // _ChartData(10, 53),
      // _ChartData(11, 72),
      // _ChartData(12, 86),
      // _ChartData(13, 52),
      // _ChartData(14, 94),
      // _ChartData(15, 92),
      // _ChartData(16, 86),
      // _ChartData(17, 72),
      // _ChartData(18, 94),
    ];
  }

  connectToDevice() async {
  // ignore: unnecessary_null_comparison
  if (widget.device == null) {
    _Pop();
    return;
  }

  // Menjalankan timer selama 15 detik.
  Timer(const Duration(seconds: 15), () {
    // Jika perangkat belum siap dalam waktu 15 detik, maka akan disconnect dan kembali.
    if (!isReady) {
      disconnectFromDevice();
      _Pop();
    }
  });

  // Menjalankan koneksi ke perangkat Bluetooth.
  await widget.device.connect();

  // Mengeksekusi fungsi discoverServices() untuk menemukan layanan Bluetooth.
  discoverServices();
}

disconnectFromDevice() {
  // ignore: unnecessary_null_comparison
  if (widget.device == null) {
    _Pop();
    return;
  }

  // Memutuskan koneksi dengan perangkat Bluetooth.
  widget.device.disconnect();
}

discoverServices() async {
  // ignore: unnecessary_null_comparison
  if (widget.device == null) {
    _Pop();
    return;
  }

  // Mencari layanan Bluetooth yang tersedia pada perangkat.
  List<BluetoothService> services = await widget.device.discoverServices();
  for (var service in services) {
    if (service.uuid.toString() == SERVICE_UUID) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
          // Mengatur notifikasi karakteristik dan mendapatkan data streaming.
          characteristic.setNotifyValue(!characteristic.isNotifying);
          stream = characteristic.value;

          // Mengatur status "isReady" menjadi true.
          setState(() {
            isReady = true;
          });
        }
      }
    }
  }

  // Jika perangkat belum siap setelah mencari layanan, maka akan disconnect dan kembali.
  if (!isReady) {
    _Pop();
  }
}

Future<bool> _onWillPop() async {
  // Menampilkan dialog konfirmasi ketika pengguna mencoba untuk kembali.
  return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('Do you want to disconnect device and go back?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    // Memutuskan koneksi dan kembali.
                    disconnectFromDevice();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes')),
            ],
          ));
}

  // ignore: non_constant_identifier_names
  _Pop() {
    // Fungsi ini digunakan untuk menutup halaman atau dialog yang sedang aktif.
  // Ini dilakukan dengan memanggil Navigator.of(context).pop(true).
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    // Fungsi ini digunakan untuk mengonversi data byte dari perangkat Bluetooth
  // menjadi string menggunakan utf8.decode(dataFromDevice).
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    // Metode build adalah bagian utama dari widget yang digunakan untuk membangun antarmuka pengguna.
  // Di sini, kita mengatur tampilan dan logika aplikasi.

    // Oscilloscope oscilloscope = Oscilloscope(
    //   showYAxis: true,
    //   // ignore: deprecated_member_use
    //   padding: 0.0,
    //   backgroundColor: Colors.white,
    //   traceColor: Colors.blue,
    //   yAxisMax: 120.0,
    //   yAxisMin: 0.0,
    //   dataSet: traceDust,
    // );

// WillPopScope digunakan untuk menangani tindakan ketika pengguna mencoba untuk kembali (menutup) aplikasi.
  // Ketika pengguna mencoba untuk kembali, _onWillPop akan dipanggil untuk menampilkan dialog konfirmasi.
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Temperature of Machine'),
        ),
        body: Container(
            child: !isReady
                ? const Center(
                    child: Text(
                      "Waiting...",
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                  )
                : StreamBuilder<List<int>>(
                    stream: stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<int>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.active) {
                        var currentValue = _dataParser(snapshot.data!);

                        createAlbum(currentValue);
                        if (currentValue != "") {
                          double suhusensr = double.parse(currentValue);
                          _updateDataSource(
                              int.parse(suhusensr.floor().toString()));
                        }
                        debugPrint('currentValue: $currentValue');
                        traceDust.add(double.tryParse(currentValue) ?? 0);

                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text('Current value from Sensor',
                                        style: TextStyle(fontSize: 14)),
                                    Text('$currentValue °C',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24))
                                  ]),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: oscilloscope,
                            // )
                            SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                primaryXAxis: NumericAxis(
                                    majorGridLines:
                                        const MajorGridLines(width: 0)),
                                primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                        const MajorTickLines(size: 0)),
                                series: <LineSeries<_ChartData, int>>[
                                  LineSeries<_ChartData, int>(
                                    onRendererCreated:
                                        (ChartSeriesController controller) {
                                      _chartSeriesController = controller;
                                    },
                                    dataSource: chartData!,
                                    color:
                                        const Color.fromRGBO(192, 108, 132, 1),
                                    xValueMapper: (_ChartData sales, _) =>
                                        sales.country,
                                    yValueMapper: (_ChartData sales, _) =>
                                        sales.sales,
                                    animationDuration: 0,
                                  )
                                ]),
                          ],
                        ));
                      } else {
                        return const Text('Check the stream');
                      }
                    },
                  )),
      ),
    );
  }

  ///Continously updating the data source based on timer
  void _updateDataSource(int data) {
    chartData!.add(_ChartData(count, data));
    if (chartData!.length > 300) {
      chartData!.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartData!.length - 1],
      );
    }
    count = count + 1;
  }
}

/// Private calss for storing the chart series data points.
class _ChartData {
  _ChartData(this.country, this.sales);
  final int country;
  final num sales;
}
