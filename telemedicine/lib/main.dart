import 'package:flutter/material.dart';
import 'package:telemedicine/pages/HistoryTaking.dart';
import 'package:telemedicine/pages/HomeScreen.dart';
import 'package:telemedicine/pages/doctor/LookLabResult.dart';
import 'package:telemedicine/pages/doctor/MakeLabAP.dart';
import 'package:telemedicine/pages/doctor/docHome.dart';
import 'package:telemedicine/pages/technologist/UploadLabResult.dart';
import 'package:telemedicine/pages/diagnosis_result.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telemedicine/pages/pharmacist/getMedList.dart';
import 'package:telemedicine/pages/med_receive.dart';
import 'package:telemedicine/pages/technologist/getLabOrder.dart';
import 'package:telemedicine/pages/lab_page.dart';
import 'package:telemedicine/pages/pay_ment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(child: Text("${snapshot.error}")),
          );
        } else {
          return MaterialApp(
            title: 'HOT DOC',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: "Sukhumvit",
            ),
            home: docHome(),
            // home: getMedList()
            // home: Meddy(),
            // home: MakeLabAP(),
            // home: GetLabOrder(),
            // home: UploadLabResult(),
            // home: LookLabResult(),
            //home: LookLabResult(),
          );
        }
      },
    );
  }
}
