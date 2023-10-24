import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:intl/intl.dart';

Color defaultTextColor = Color(0xff373b44);

class LookLabResult extends StatefulWidget {
  // String appointmentID = "";
  String patientID = "";
  LookLabResult(String patientID) {
    this.patientID = patientID;
  }

  @override
  State<LookLabResult> createState() => _LookLabResultState(this.patientID);
}

class _LookLabResultState extends State<LookLabResult> {
  String appointmentID = "";
  String patientID = "";
  _LookLabResultState(this.patientID) {}

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
          .update({"labResult": "${downloadLink}"}).then(
              (value) => print("DocumentSnapshot successfully updated!"),
              onError: (e) => print("Error updating document $e"));

      print("PDF loaded Successfully");
    }
  }

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
              "ข้อมูลผู้ป่วย",
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
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('/patients')
                          .doc('${patientID}')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("No data");
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: Container(
                              color: Color(0xff75c0c3),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${snapshot.data!.get("name")}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: defaultTextColor),
                                              ),
                                              Text(
                                                'อายุ ${snapshot.data!.get("ages")} เพศ ${snapshot.data!.get("sex")}',
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "การแพ้ : ${snapshot.data!.get("allergicHistory")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                              Text(
                                                "โรคประจำตัว : ${snapshot.data!.get("chronic")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                              Text(
                                                "ประวัติการผ่าตัด : ${snapshot.data!.get("surgery_history")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                              Text(
                                                "ประวัติโรคเลือด : ${snapshot.data!.get("bloodDisease_history")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "สิทธิ์รักษา : ${snapshot.data!.get("claim")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                              Text(
                                                "โทร : ${snapshot.data!.get("phone")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                              Text(
                                                "อีเมล : ${snapshot.data!.get("email")}",
                                                style: TextStyle(
                                                    color: defaultTextColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ]),
                              ),
                              height: 200,
                              width: double.infinity,
                            ),
                          );
                        }
                      })
                  : Text(''),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ประวัติ",
                          style: TextStyle(fontSize: 18),
                        ),
                        (patientID != '')
                            ? StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection(
                                        "/patients/${patientID}/appointments")
                                    .where("labState", isEqualTo: "done")
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
                                              Card(
                                                elevation: 5.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  //set border radius more than 50% of height and width to make circle
                                                ),
                                                child: ListTile(
                                                  onTap: () {},
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  tileColor: Color(0xffe7f6f8),
                                                  title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "Appointments date"),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          PdfViewScreen(
                                                                              pdfUrl: '${ap.data()['labResult']}')));
                                                            },
                                                            child:
                                                                Text('ผลแลป'))
                                                      ]),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons
                                                              .history),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                              '${ap['QueueDate'].toDate().day} ${_getMonth(ap['QueueDate'].toDate().month)} ${ap['QueueDate'].toDate().year}'),
                                                        ],
                                                      ),
                                                      Text(
                                                          "${ap["QueueTime"]} น. - ${(double.parse(ap["QueueTime"]) + 1.00).toStringAsFixed(2)} น."),
                                                      Divider(),
                                                      Text(ap['symptoms']),
                                                      Text(ap[
                                                          'symptomSeverity']),
                                                      Text(
                                                          'สิ่งกระตุ้น ${ap['symptomTriggers']}'),
                                                      Text(ap['symptoms']),
                                                      (ap['isFamilyMemberExperienced'] ==
                                                              true)
                                                          ? Text(
                                                              'คนในพันธุกรรมเคยเป็น')
                                                          : Text(
                                                              'คนในพันธุกรรมไม่เคยเป็น'),
                                                      (ap['isCloseContact'] ==
                                                              true)
                                                          ? Text(
                                                              'เคยสัมผัสใกล้ชิดผู้ป่วย')
                                                          : Text(
                                                              'ไม่เคยสัมผัสผู้ป่วย'),
                                                    ],
                                                  ),
                                                  // subtitle: StreamBuilder(
                                                  //     stream: FirebaseFirestore
                                                  //         .instance
                                                  //         .collection(
                                                  //             "/patients/${patientID}/appointments")
                                                  //         .doc('${ap.id}')
                                                  //         .collection(
                                                  //             'LabAppointment')
                                                  //         .snapshots(),
                                                  //     builder: (context,
                                                  //         snapshot) {
                                                  //       if (!snapshot
                                                  //           .hasData) {
                                                  //         return Text(
                                                  //             "No data");
                                                  //       } else {
                                                  //         String formattedDate = DateFormat(
                                                  //                 'dd/MM/yyyy')
                                                  //             .format(snapshot
                                                  //                 .data!
                                                  //                 .docs[0]
                                                  //                 .data()[
                                                  //                     'selectedDate']
                                                  //                 .toDate());
                                                  //         var labData =
                                                  //             snapshot.data!
                                                  //                 .docs[0]
                                                  //                 .data();

                                                  //         return Column(
                                                  //           crossAxisAlignment:
                                                  //               CrossAxisAlignment
                                                  //                   .start,
                                                  //           children: [
                                                  //             Row(
                                                  //               children: [
                                                  //                 Icon(Icons
                                                  //                     .access_time),
                                                  //                 SizedBox(
                                                  //                   width: 10,
                                                  //                 ),
                                                  //                 Text(
                                                  //                     '${formattedDate}'),
                                                  //                 SizedBox(
                                                  //                   width: 10,
                                                  //                 ),
                                                  //                 Text(
                                                  //                     "${labData['selectedTime']}")
                                                  //               ],
                                                  //             ),
                                                  //             Divider(),
                                                  //             Text(
                                                  //                 "${labData['doctorName']}")
                                                  //           ],
                                                  //         );
                                                  //       }
                                                  //     })
                                                ),
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
          )),
    );
  }
}

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  PDFDocument? document;
  void initialisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document != null
          ? PDFViewer(document: document!)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // Add your custom path points here
    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0046296, size.height * -0.0058333);
    path_0.lineTo(size.width * -0.0001574, size.height * 1.0050596);
    path_0.lineTo(size.width * 1.0060463, size.height * 0.9621000);
    path_0.lineTo(size.width * 1.0111111, size.height * -0.0026095);
    path_0.lineTo(size.width * -0.0046296, size.height * -0.0058333);
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
                                  LookLabResult('${query}'))));
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

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'มกราคม';
    case 2:
      return 'กุมภาพันธ์';
    case 3:
      return 'มีนาคม';
    case 4:
      return 'เมษายน';
    case 5:
      return 'พฤษภาคม';
    case 6:
      return 'มิถุนายน';
    case 7:
      return 'กรกฎาคม';
    case 8:
      return 'สิงหาคม';
    case 9:
      return 'กันยายน';
    case 10:
      return 'ตุลาคม';
    case 11:
      return 'พฤศจิกายน';
    case 12:
      return 'ธันวาคม';
    default:
      return '';
  }
}
