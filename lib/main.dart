import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get_ip/get_ip.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("ADB over WiFi"),
        ),
        body: Content(),
      ),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Port(),
          Address()
        ],
      ),
    );
  }
}

class Port extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.pinkAccent,
          child: Text("点击", style: TextStyle(fontSize: 18, color: Colors.white),),
          onPressed: () {
            Process.start("su", []).then((process) {
              process.stdin.writeln("setprop service.adb.tcp.port 5555");
              process.stdin.writeln("stop adbd");
              process.stdin.writeln("start adbd");
              process.stdin.writeln("exit");
            });
          },
        )
      ],
    );
  }
}

class Address extends StatefulWidget {
  @override
  AddressState createState() => new AddressState();
}

class AddressState extends State<Address> {
  String _ip = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String ipAddress;

    try {
      ipAddress = await GetIp.ipAddress;
    } on PlatformException {
      ipAddress = 'Failed to get ipAddress.';
    }

    if (!mounted) return;

    setState(() {
      _ip = ipAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Running on: $_ip'),
      ],
    );
  }
}