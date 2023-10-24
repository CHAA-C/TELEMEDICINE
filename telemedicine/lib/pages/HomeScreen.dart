import 'package:flutter/material.dart';
import 'package:telemedicine/homeIcons.dart';
import 'package:telemedicine/pages/HistoryTaking.dart';
import 'package:telemedicine/pages/VideocallScreen.dart';
import 'package:telemedicine/pages/diag_Appoint.dart';
import 'package:telemedicine/pages/diagnosis_result.dart';
import 'package:telemedicine/pages/lab_page.dart';
import 'package:telemedicine/pages/med_receive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/doctor/mockup_vdocall.dart';
import 'package:intl/intl.dart';
import 'package:telemedicine/pages/pay_ment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String patientName = "";
  String profileImage = "";
  double buttonWidth = 100.0;
  Color defaultTextColor = Color(0xFF545F71);
  Color green = Color(0xFF75C0C3);
  String patientID = "user001";
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

  void initState() {
    super.initState();
    var db = FirebaseFirestore.instance;
    final docRef = db.collection("patients").doc("${patientID}");
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          patientName = data["name"];
          profileImage = data["profileImg"];
        });

        print(data["name"]);
        print(data["profileImg"]);
      },
      onError: (e) => print("Error getting document: $e"),
    );

    db
        .collection("/patients/${patientID}/appointments")
        .where("QueueDate", isLessThan: DateTime.now())
        .where('State', isEqualTo: 'waiting')
        .get()
        .then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          // อัปเดตค่า `capital` เป็น `false` ข้างในเอกสาร
          docSnapshot.reference.update({'State': 'timeout'}).then((_) {
            print('Updated ${docSnapshot.id}');
          }).catchError((error) {
            print('Error updating ${docSnapshot.id}: $error');
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
      home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ยินดีต้อนรับ",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: defaultTextColor),
                            ),
                            Text(" คุณ${patientName}")
                          ],
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(profileImage),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 207,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Image.asset('assets/images/home/infographic.png'),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " บริการ",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: defaultTextColor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 96,
                            width: 175,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4, // กำหนดความหนาของเงา
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // กำหนดรูปร่างของปุ่ม
                                ),
                                primary: green, // กำหนดสีพื้นหลังของปุ่ม
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => HistoryTaking()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MyHomeIcons.add_to_photos,
                                      size: 60, color: Colors.black),
                                  Text(
                                    "จองคิวหมอ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 96,
                            width: 175,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 4, // กำหนดความหนาของเงา
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // กำหนดรูปร่างของปุ่ม
                                ),
                                primary: green, // กำหนดสีพื้นหลังของปุ่ม
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => DiagAppoint()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(MyHomeIcons.result,
                                      size: 60, color: Colors.black),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "ผลวินิจฉัย/",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                      Text(
                                        "จองแลป",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // child: ListView(
                      //   scrollDirection: Axis.horizontal,
                      //   children: <Widget>[
                      //     Container(
                      //         width: buttonWidth,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             elevation: 4,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(
                      //                   10.0), // กำหนดรูปร่างของปุ่ม
                      //             ),
                      //             primary: green, // กำหนดสีพื้นหลังของปุ่ม
                      //           ),
                      //           onPressed: () {
                      //             print("จองคิวหมอ");
                      //             Navigator.push(
                      //                 context,
                      //                 new MaterialPageRoute(
                      //                     builder: (context) =>
                      //                         HistoryTaking()));
                      //           },
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(MyHomeIcons.add_to_photos,
                      //                   size: 45, color: Colors.black),
                      //               Text(
                      //                 "จองคิวหมอ",
                      //                 style: TextStyle(
                      //                     fontSize: 13.5, color: Colors.black),
                      //               )
                      //             ],
                      //           ),
                      //         )),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Container(
                      //         width: buttonWidth,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             elevation: 4, // กำหนดความหนาของเงา
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(
                      //                   10.0), // กำหนดรูปร่างของปุ่ม
                      //             ),
                      //             primary: green, // กำหนดสีพื้นหลังของปุ่ม
                      //           ),
                      //           onPressed: () {
                      //             print("ผลวินิจฉัย");
                      //             Navigator.push(
                      //                 context,
                      //                 new MaterialPageRoute(
                      //                     builder: (context) => DiagResult()));
                      //           },
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(MyHomeIcons.result,
                      //                   size: 45, color: Colors.black),
                      //               Text(
                      //                 "ผลวินิจฉัย",
                      //                 style: TextStyle(color: Colors.black),
                      //               )
                      //             ],
                      //           ),
                      //         )),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Container(
                      //         width: buttonWidth,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             elevation: 4, // กำหนดความหนาของเงา
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(
                      //                   10.0), // กำหนดรูปร่างของปุ่ม
                      //             ),
                      //             primary: green, // กำหนดสีพื้นหลังของปุ่ม
                      //           ),
                      //           onPressed: () {
                      //             print("จองคิวแลป");
                      //             Navigator.push(
                      //                 context,
                      //                 new MaterialPageRoute(
                      //                     builder: (context) => LabPage()));
                      //           },
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 MyHomeIcons.microscope,
                      //                 size: 45,
                      //                 color: Colors.black,
                      //               ),
                      //               Text(
                      //                 "จองคิวแลป",
                      //                 style: TextStyle(color: Colors.black),
                      //               )
                      //             ],
                      //           ),
                      //         )),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Container(
                      //         width: buttonWidth,
                      //         child: ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             elevation: 4, // กำหนดความหนาของเงา
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(
                      //                   10.0), // กำหนดรูปร่างของปุ่ม
                      //             ),
                      //             primary: green, // กำหนดสีพื้นหลังของปุ่ม
                      //           ),
                      //           onPressed: () {
                      //             print("รับยา");
                      //             Navigator.push(
                      //                 context,
                      //                 new MaterialPageRoute(
                      //                     builder: (context) => Meddy()));
                      //           },
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 MyHomeIcons.pills,
                      //                 size: 45,
                      //                 color: Colors.black,
                      //               ),
                      //               Text(
                      //                 "รับยา",
                      //                 style: TextStyle(color: Colors.black),
                      //               )
                      //             ],
                      //           ),
                      //         )),
                      //   ],
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " การนัดหมาย",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: defaultTextColor),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("/patients/${patientID}/appointments")
                          .where('QueueDate', isGreaterThan: DateTime.now())
                          .where("State", isEqualTo: "waiting")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("ไม่มีข้อมูล");
                        } else {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var ap = snapshot.data!.docs[index];
                                return Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(bottom: 8.0),
                                  child: Container(
                                    // height: 200,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color(0xFFe7f6fb), // background
                                        onPrimary:
                                            Color(0xFF545F71), // foreground
                                      ),
                                      onPressed: () {
                                        DateTime now = DateTime.now();
                                        String nowTime =
                                            DateFormat('kk.mm').format(now);
                                        print(now.day);
                                        if ((now.day.compareTo(ap['QueueDate']
                                                    .toDate()
                                                    .day) ==
                                                0) &&
                                            (double.parse(ap['QueueTime']) <
                                                    double.parse(nowTime) &&
                                                (double.parse(ap['QueueTime']) +
                                                        1.0) >
                                                    double.parse(nowTime))) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      VDOCall("${ap.id}"))));
                                        } else {
                                          print(
                                              "${nowTime} ${ap['QueueTime']}");
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text(
                                                        "ยังไม่ถึงเวลานัด"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            cancelAp(patientID,
                                                                ap.id);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                              'ยกเลิกนัด')),
                                                    ],
                                                  ));
                                          print("ยังไม่ถึงเวลา");
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "วันนัดหมอ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${ap["QueueTime"]} น. - ${(double.parse(ap["QueueTime"]) + 1.00).toStringAsFixed(2)} น.",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                Text(
                                                  '${ap['QueueDate'].toDate().day} ${_getMonth(ap['QueueDate'].toDate().month)} ${ap['QueueDate'].toDate().year}',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                            Divider(
                                              thickness: 3,
                                            ),
                                            Text("${ap["docName"]}")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      }),
                  Divider(),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("/patients/${patientID}/appointments")
                          .where("State", isEqualTo: "waiting")
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
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection(
                                            "/patients/${patientID}/appointments")
                                        .doc('${ap.id}')
                                        .collection('LabAppointment')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text('no data');
                                      } else {
                                        var labData =
                                            snapshot.data!.docs[0].data();

                                        return Padding(
                                          padding: EdgeInsetsDirectional.only(
                                              bottom: 8.0),
                                          child: Container(
                                            // height: 200,
                                            child: Card(
                                              color: Color(0xffe9f1fe),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 18.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "วันตรวจแลป",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${ap["QueueTime"]} น. - ${(double.parse(ap["QueueTime"]) + 1.00).toStringAsFixed(2)} น.",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          '${labData['selectedDate'].toDate().day} ${_getMonth(labData['selectedDate'].toDate().month)} ${labData['selectedDate'].toDate().year}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        )
                                                      ],
                                                    ),
                                                    Divider(
                                                      thickness: 3,
                                                    ),
                                                    Text(
                                                        "${labData["labselected"]}")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    });
                              });
                        }
                      }),
                ],
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => VideoCallScreen('user001', 'ap001'),
          //     ),
          //   );
          // }
          // ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "หน้าหลัก"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.document_scanner), label: "ประวัติ"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money), label: "จ่ายเงิน"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "โปรไฟล์")
            ],
            onTap: (index) {
              if (index == 2) {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Payment(),
                  ),
                );
              }
            },
          )),
    );
  }
}

cancelAp(patientID, appointmentID) {
  var db = FirebaseFirestore.instance;
  final appointmentRef = db
      .collection("/patients/${patientID}/appointments")
      .doc("${appointmentID}");
  appointmentRef.update({"State": 'cancel'}).then(
      (value) => print("appointment ${appointmentID} successfully cancel !"),
      onError: (e) => print("Error updating document $e"));
}
