import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:intl/intl.dart' show DateFormat;

void main() {
  // Preferred orientation: Landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            displayLarge: TextStyle(color: Colors.grey, fontSize: 30),
          ),
          fontFamily: 'Alatsi',
        ),
        home: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade900, Colors.grey.shade900],
            ),
          ),
          child: const Scaffold(
            body: Clock(),
            backgroundColor: Colors.transparent,
          ),
        ));
  }
}

// Utility class to convert values to binary integers
class BinaryTime {
  // Contains strings of binary nums
  late List<String> binaryIntegers;

  // Initializes BinaryTime
  BinaryTime() {
    DateTime now = DateTime.now();
    String hms = DateFormat("Hms").format(now).replaceAll(':', '');

    binaryIntegers = hms
        .split('')
        .map((str) => int.parse(str).toRadixString(2).padLeft(4, '0'))
        .toList();
  }

  // Getters
  get hoursTens => binaryIntegers[0];
  get hoursOnes => binaryIntegers[1];
  get minuteTens => binaryIntegers[2];
  get minuteOnes => binaryIntegers[3];
  get secondsTens => binaryIntegers[4];
  get secondsOnes => binaryIntegers[5];
}

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  BinaryTime _now = BinaryTime();

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = BinaryTime();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Clock columns
          ClockColumn(
            binaryInteger: _now.hoursTens,
            title: 'H',
            color: Colors.blue,
            rows: 2,
          ),
          ClockColumn(
              binaryInteger: _now.hoursOnes,
              title: 'h',
              color: Colors.lightBlue),
          ClockColumn(
            binaryInteger: _now.minuteTens,
            title: 'M',
            color: Colors.green,
            rows: 3,
          ),
          ClockColumn(
            binaryInteger: _now.minuteOnes,
            title: 'm',
            color: Colors.lightGreen,
          ),
          ClockColumn(
            binaryInteger: _now.secondsTens,
            title: 'S',
            color: Colors.red,
            rows: 3,
          ),
          ClockColumn(
            binaryInteger: _now.secondsOnes,
            title: 's',
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ClockColumn extends StatelessWidget {
  String binaryInteger;
  String title;
  Color color;
  int rows;
  late List bits;

  ClockColumn(
      {super.key,
      this.binaryInteger = "",
      this.title = "",
      this.color = Colors.white,
      this.rows = 4}) {
    bits = binaryInteger.split('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...[
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge,
          )
        ],
        ...bits.asMap().entries.map((entry) {
          int ind = entry.key;
          String bit = entry.value;

          bool isActive = (bit == '1');
          int binaryCellValue = pow(2, 3 - ind).toInt();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 475),
            curve: Curves.ease,
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: isActive
                  ? color
                  : (ind < 4 - rows)
                      ? Colors.white.withOpacity(0)
                      : Colors.black38,
            ),
            margin: const EdgeInsets.all(4),
            child: Center(
              child: isActive
                  ? Text(
                      binaryCellValue.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container(),
            ),
          );
        }),
        ...[
          Text(
            int.parse(binaryInteger, radix: 2).toString(),
            style: TextStyle(fontSize: 30, color: color),
          ),
          Text(
            binaryInteger,
            style: TextStyle(fontSize: 15, color: color),
          )
        ]
      ],
    );
  }
}
