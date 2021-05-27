import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Live Tracker';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String realTimePosition = "";
  final firestoreInstance = FirebaseFirestore.instance;

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      realTimePosition = position.toString();
      List<dynamic> arrayLatTmp = [position.latitude];
      List<dynamic> arrayLongTmp = [position.longitude];
      firestoreInstance
          .collection('position')
          .doc("PprjWV3sJMHNPLXz6Cim")
          .update({"lat": arrayLatTmp});
      firestoreInstance
          .collection('position')
          .doc("PprjWV3sJMHNPLXz6Cim")
          .update({"long": arrayLongTmp});
      arrayLatTmp.clear();
      arrayLongTmp.clear();
    });
    print(position.toString());
  }

  @override
  void initState() {
    getCurrentPosition();
    Timer timer =
        Timer.periodic(Duration(seconds: 5), (Timer t) => getCurrentPosition());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(realTimePosition),
          ],
        ),
      ),
    );
  }
}
