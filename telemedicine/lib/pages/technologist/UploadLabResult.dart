import 'dart:io';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:telemedicine/homeIcons.dart';
import 'package:telemedicine/pages/technologist/GetLabOrder.dart';
import 'package:intl/intl.dart';

Color defaultTextColor = Color(0xff373b44);

class UploadLabResult extends StatefulWidget {
  String patientID = "";
  UploadLabResult(this.patientID) {}

  @override
  State<UploadLabResult> createState() => _UploadLabResultState(this.patientID);
}

class _UploadLabResultState extends State<UploadLabResult> {
  String patientID = "";
  _UploadLabResultState(this.patientID) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: "Sukhumvit",
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff75c0c3),
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              "ส่งผลตรวจแลป",
              style: TextStyle(
                color: defaultTextColor,
                fontSize: 40,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: MySearchDelegate());
                },
              )
            ],
          ),
          body: Column(
            children: [
              (patientID != '')
                  ?
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('/patients')
                      .doc('${patientID}')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("No data");
                    } else {
                      return ClipPath(
                        clipper: CustomClipPath(),
                        child: Container(
                          color: Color(0xff75c0c3),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        "${snapshot.data!.get("profileImg")}"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${snapshot.data!.get("name")}',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: defaultTextColor),
                                      ),
                                      Text(
                                        'อายุ ${snapshot.data!.get("ages")} เพศ ${snapshot.data!.get("sex")}',
                                        style:
                                            TextStyle(color: defaultTextColor),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "อีเมล : ${snapshot.data!.get("email")}",
                                  style: TextStyle(color: defaultTextColor),
                                ),
                              ),
                              ListTile(
                                dense: true,
                                title: Text(
                                  "โทร : ${snapshot.data!.get("phone")}",
                                  style: TextStyle(color: defaultTextColor),
                                ),
                              ),
                            ]),
                          ),
                          height: 200,
                          width: double.infinity,
                        ),
                      );
                    }
                      })
                  : Text('  กรุณาค้นหาผู้ป่วยเพื่อแสดงข้อมูลและรายการนัด'),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (patientID != '')
                            ?
                        Text(
                          "รายการนัด",
                          style: TextStyle(fontSize: 18),
                              )
                            : Text(''),
                        (patientID != '')
                            ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(
                                    "/patients/${patientID}/appointments")
                                .where("labState", isEqualTo: "booked")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("No data");
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var ap = snapshot.data!.docs[index];

                                      return Column(
                                        children: [
                                          Material(
                                            elevation: 5.0,
                                            child: ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                          builder: (context) =>
                                                              GetLabOrder(
                                                                  patientID,
                                                                  ap.id)));
                                                },
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                tileColor: Color(0xffe7f6f8),
                                                title:
                                                    Text("Appointments date"),
                                                subtitle: StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "/patients/${patientID}/appointments")
                                                        .doc('${ap.id}')
                                                        .collection(
                                                            'LabAppointment')
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Text("No data");
                                                      } else {
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(snapshot
                                                                    .data!
                                                                    .docs[0]
                                                                    .data()[
                                                                        'selectedDate']
                                                                    .toDate());

                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .access_time),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    '${formattedDate}'),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "${snapshot.data!.docs[0].data()['selectedTime']}")
                                                              ],
                                                            ),
                                                            Divider(),
                                                            Text(
                                                                "${snapshot.data!.docs[0].data()['doctorName']}")
                                                          ],
                                                        );
                                                      }
                                                    })),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      );
                                    });
                              }
                                })
                            : Text('')
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Add your custom path points here
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0046296, size.height * -0.0112903);
    path_0.lineTo(size.width * -0.0058519, size.height * 0.9668710);
    path_0.quadraticBezierTo(size.width * 0.1859074, size.height * 1.0180645,
        size.width * 0.4321389, size.height * 0.7128710);
    path_0.quadraticBezierTo(size.width * 0.7021204, size.height * 0.4563710,
        size.width * 1.0060556, size.height * 0.7520161);
    path_0.lineTo(size.width * 1.0111111, size.height * -0.0080645);
    path_0.lineTo(size.width * -0.0046296, size.height * -0.0112903);
    path_0.close();

    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // You can implement logic for re-clipping if needed
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("patients").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('no data');
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var patientData = snapshot.data!.docs[index];
                  final suggestion = patientData.id;
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () {
                      query = suggestion;
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) =>
                                  UploadLabResult('${query}'))));
                    },
                  );
                });
          }
        });
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }
}
