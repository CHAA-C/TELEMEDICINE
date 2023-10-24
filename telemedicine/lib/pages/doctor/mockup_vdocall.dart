import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telemedicine/pages/HomeScreen.dart';

class VDOCall extends StatefulWidget {
  String apID;
  VDOCall(this.apID) {}

  @override
  State<VDOCall> createState() => _VDOCallState(this.apID);
}

class _VDOCallState extends State<VDOCall> {
  String apID;
  _VDOCallState(this.apID) {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
      home: Scaffold(
        body: Text("VDOCall appointmentID = ${apID}"),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var appointment = FirebaseFirestore.instance
                .collection('/patients/user001/appointments')
                .doc('${apID}');
            appointment.update({"State": "not_paid"}).then(
                (value) => print("Update success"),
                onError: (e) => print("Update error:" + e));
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => HomeScreen())));
          },
        ),
      ),
    );
  }
}
