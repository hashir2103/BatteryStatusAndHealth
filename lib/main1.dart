import 'dart:async';

import 'package:battery/battery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Battery Info'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Battery _battery = Battery();
  String status;
  int _batteryLevel;
  StreamSubscription<BatteryState> _batterySubscription;
  @override
  void initState() {
    super.initState();
    _batterySubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        status = state.toString().split('.')[1];
      });
    });
  }

  @override
  dispose() {
    super.dispose();
    if (_batterySubscription != null) {
      _batterySubscription.cancel();
    }
  }
  
  Future<void> _getLevel() async {
    final int batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text('State : $status',style: TextStyle(
                  fontSize: 40,
                ),),
              ),    
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text('Level : $_batteryLevel %',style: TextStyle(
                  fontSize: 40,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: RaisedButton(
                  padding: EdgeInsets.all(15),
                  color: Colors.purpleAccent,
                  onPressed: _getLevel, child: Text('Check Level',
                style: TextStyle(
                  fontSize: 20
                ),)),
              ),
              
            ],
          ),
        ));
  }
}
