import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';
import 'package:diar/models/ethirium_utils.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EthereumUtils ethUtils = EthereumUtils();
  var _data;
  String d = "";
  @override
  void initState() {
    String d = " ";
    ethUtils.initial();
    ethUtils.getmove().then((value) {
      _data = value;
      setState(() {});
    });
    super.initState();
  }

  //funtion
  void writeSerial(String data) async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.length == 0) {
      // No devices found
      return;
    }

    UsbDevice device = devices[0];
    UsbPort port;
    try {
      port = (await device.create())!;
      await port.open();
      await port.setDTR(true); // Set DTR to reset Arduino
      await Future.delayed(Duration(milliseconds: 100)); // Wait for reset
      await port.setDTR(false);
      while (true) {
        await port.write(Uint8List.fromList(data.codeUnits));
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  String converttostring(var data) {
    ethUtils.initial();
    ethUtils.getmove().then((value) {
      _data = value;
      data = _data.toString();
      setState(() {});
    });
    print(data);

    if (data ==
        "[222, 97, 51, 49, 140, 180, 182, 171, 124, 118, 67, 40, 229, 201, 41, 176, 92, 72, 184, 65, 75, 30, 35, 22, 197, 9, 153, 71, 147, 76, 167, 181]") {
      d = "forward";
      writeSerial(d);
    }
    if (data ==
        "[167, 194, 192, 93, 87, 253, 33, 18, 225, 127, 187, 212, 224, 248, 56, 5, 62, 23, 150, 211, 238, 150, 92, 23, 55, 42, 193, 132, 219, 105, 130, 48]") {
      d = "back";
      writeSerial(d);
    }
    if (data ==
        "[101, 108, 189, 151, 161, 125, 174, 178, 225, 174, 128, 153, 78, 218, 206, 247, 98, 244, 71, 201, 136, 224, 34, 254, 91, 76, 142, 181, 60, 43, 1, 210]") {
      d = "left";
      writeSerial(d);
    }
    if (data ==
        "[29, 144, 78, 54, 115, 0, 192, 86, 152, 98, 83, 138, 153, 157, 132, 11, 37, 42, 80, 145, 160, 255, 237, 44, 232, 175, 52, 160, 68, 220, 122, 33]") {
      d = "right";
      writeSerial(d);
    }
    if (data ==
        "[159, 150, 250, 2, 151, 38, 83, 230, 144, 98, 175, 45, 116, 235, 195, 150, 196, 175, 13, 4, 222, 205, 80, 123, 72, 93, 219, 247, 71, 92, 70, 222]") {
      d = "stop";
      writeSerial(d);
    }

    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: _data == null
                  ? CircularProgressIndicator()
                  : Text(
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                      converttostring(_data.toString()))),
          const SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }
}
