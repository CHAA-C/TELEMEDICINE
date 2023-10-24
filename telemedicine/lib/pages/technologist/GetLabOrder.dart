import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

TextStyle header = TextStyle(fontWeight: FontWeight.bold, fontSize: 17);
TextStyle content = TextStyle(color: Color(0xFF545F71));

class GetLabOrder extends StatefulWidget {
  String patientID;
  String appointmentID;
  GetLabOrder(this.patientID, this.appointmentID) {}

  @override
  State<GetLabOrder> createState() =>
      _GetLabOrderState(this.patientID, this.appointmentID);
}

class _GetLabOrderState extends State<GetLabOrder> {
  String patientID;
  String appointmentID;
  _GetLabOrderState(this.patientID, this.appointmentID) {}

  // List test1 = ["A", "B", "C", "D", "E", "F"];
  List resultList1 = [""];
  List resultList2 = [""];
  List resultList3 = [""];
  List resultList4 = [""];

  Future<String> uploadPdf(String filename, File file) async {
    final reference = FirebaseStorage.instance
        .ref()
        .child("labResult/${patientID}/$filename.pdf");
    final uploadeTask = reference.putFile(file);
    await uploadeTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (pickedFile != null) {
      File file = File(pickedFile.files[0].path!);
      final downloadLink = await uploadPdf(appointmentID, file);

      var db = FirebaseFirestore.instance;
      await db
          .collection("/patients/${patientID}/appointments")
          .doc("${appointmentID}")
          .update({"labResult": "${downloadLink}", "labState": "done"}).then(
              (value) => print("DocumentSnapshot successfully updated!"),
              onError: (e) => print("Error updating document $e"));

      print("PDF loaded Successfully");
    }
  }

  Future<void> getLabOrder() async {
    var db = FirebaseFirestore.instance;
    await db
        .collection(
            "/patients/${patientID}/appointments/${appointmentID}/LabAppointment")
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        // for (var docSnapshot in querySnapshot.docs) {
        //   print('${docSnapshot.id} => ${docSnapshot.data()}');
        // }
        resultList1 = querySnapshot.docs[0].data()["thalassemia_screening"];
        resultList2 =
            querySnapshot.docs[0].data()["DNA_analysisforThalassemias"];
        resultList3 =
            querySnapshot.docs[0].data()["DNA_analysisforCoagulation"];
        resultList4 = querySnapshot.docs[0].data()["G_6_PDDeficiency"];
        print(resultList4);
        if (resultList1.isEmpty) {
          resultList1 = ["ไม่มีการตรวจในหมวดนี้"];
        }
        if (resultList2.isEmpty) {
          resultList2 = ["ไม่มีการตรวจในหมวดนี้"];
        }
        if (resultList3.isEmpty) {
          resultList3 = ["ไม่มีการตรวจในหมวดนี้"];
        }
        if (resultList4.isEmpty) {
          resultList4 = ["ไม่มีการตรวจในหมวดนี้"];
          print(resultList4);
        }

        setState(() {});
      },
      onError: (e) {
        print("Error completing: $e");
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLabOrder();
  }

  @override
  Widget build(BuildContext context) {
    // dataList = getLabOrder();
    // print(resultList);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "รายการตรวจ",
            style: TextStyle(
              color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
              fontSize: 40,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF75C0C3)),
                  dataRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFFE7F6FB)),
                  columns: [
                    DataColumn(
                        label: Container(
                      child: Text(
                        "Thalassemia screening",
                        style: header,
                      ),
                    ))
                  ],
                  rows: resultList1.map((e) {
                    return DataRow(cells: [
                      DataCell(Text(
                        e.toString(),
                        style: content,
                      ))
                    ]);
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF75C0C3)),
                  dataRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFFE7F6FB)),
                  columns: [
                    DataColumn(
                        label: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DNA analysis for Thalassemias and",
                            style: header,
                          ),
                          Text(
                            "Hemoglobinopathies",
                            style: header,
                          )
                        ],
                      ),
                    ))
                  ],
                  rows: resultList2.map((e) {
                    return DataRow(cells: [
                      DataCell(Text(
                        e.toString(),
                        style: content,
                      ))
                    ]);
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF75C0C3)),
                  dataRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFFE7F6FB)),
                  columns: [
                    DataColumn(
                        label: Container(
                      child: Text(
                        "DNA analysis for Coagulation factors",
                        style: header,
                      ),
                    ))
                  ],
                  rows: resultList3.map((e) {
                    return DataRow(cells: [
                      DataCell(Text(
                        e.toString(),
                        style: content,
                      ))
                    ]);
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFF75C0C3)),
                  dataRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFFE7F6FB)),
                  columns: [
                    DataColumn(
                        label: Container(
                      child: Text(
                        "G-6-PD Deficiency",
                        style: header,
                      ),
                    ))
                  ],
                  rows: resultList4.map((e) {
                    return DataRow(cells: [
                      DataCell(Text(
                        e.toString(),
                        style: content,
                      ))
                    ]);
                  }).toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 60,
                  child: TextButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(4.0),
                          // side: MaterialStateProperty.all(
                          //   BorderSide(
                          //     color: const Color.fromARGB(255, 224, 224,
                          //         224), // Change this color to your desired border color
                          //     width:
                          //         2.0, // Change this value to set the border width
                          //   ),
                          // ),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color(0xFFE9F1FE)),
                          iconColor: MaterialStatePropertyAll<Color>(
                              Color(0xFF545F71))),
                      onPressed: () {
                        pickFile();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "ส่งผลแลป",
                            style: TextStyle(color: Color(0xFF545F71)),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
