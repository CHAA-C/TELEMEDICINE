import 'package:flutter/material.dart';
import 'package:telemedicine/homeIcons.dart';
import 'package:telemedicine/pages/HistoryTaking.dart';
import 'package:telemedicine/pages/VideoCallScreen.dart';
import 'package:telemedicine/pages/diagnosis_result.dart';
import 'package:telemedicine/pages/doctor/LookLabResult.dart';
import 'package:telemedicine/pages/doctor/dispensing_page.dart';
import 'package:telemedicine/pages/lab_page.dart';
import 'package:telemedicine/pages/med_receive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:telemedicine/pages/mockup_vdocall.dart';
import 'package:intl/intl.dart';
import 'package:telemedicine/pages/pay_ment.dart';

class docHome extends StatefulWidget {
  const docHome({super.key});

  @override
  State<docHome> createState() => _docHomeState();
}

class _docHomeState extends State<docHome> {
  String DocName = "";
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
          DocName = "น.พ.สมศักดิ์ กิตติการ";
          profileImage = data["docPic"];
        });

        print(data["name"]);
        print(data["profileImg"]);
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    String mypath = '';
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
                          Text(
                            " คุณ${DocName}",
                            style: TextStyle(fontSize: 18),
                          )
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/chaa-c.appspot.com/o/patients%2FDocinfoPic.png?alt=media&token=a60cac64-2098-4a10-a820-4a6cf5745dba&_gl=1*f8ghrd*_ga*OTUwMDQ4MjQ4LjE2OTY5MTcyMTA.*_ga_CW55HF8NVT*MTY5NzQ1MTc0Mi4zNi4xLjE2OTc0NTIxNTQuNTkuMC4w'),
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
                  padding: EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 96,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                            width: buttonWidth,
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
                                print("ประวัติคนไข้");
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => LookLabResult(
                                            ""))); // หน้าประวัติคนไข้
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MyHomeIcons.result,
                                    size: 45,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "ประวัติคนไข้",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: buttonWidth,
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
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Row(
                                      children: [
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/chaa-c.appspot.com/o/patients%2Fnews.jpg?alt=media&token=ea5bbca5-07d9-45a7-a7fc-346da66f903a&_gl=1*1gegwz4*_ga*OTUwMDQ4MjQ4LjE2OTY5MTcyMTA.*_ga_CW55HF8NVT*MTY5NzQ1MTc0Mi4zNi4xLjE2OTc0NTIyNTguMjMuMC4w', // เพิ่ม URL รูปที่คุณต้องการแสดง
                                          width:
                                              225, // ปรับขนาดรูปตามความต้องการ
                                          height: 225,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.newspaper,
                                    size: 45,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "News",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: buttonWidth,
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
                                print("Contacts");
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Row(
                                      children: [
                                        Image.network(
                                          'https://firebasestorage.googleapis.com/v0/b/chaa-c.appspot.com/o/patients%2Fcontacts.png?alt=media&token=01c90ebd-8b73-4206-b2b4-0feea1c3c18d&_gl=1*11a8hb*_ga*OTUwMDQ4MjQ4LjE2OTY5MTcyMTA.*_ga_CW55HF8NVT*MTY5NzQ1MTc0Mi4zNi4xLjE2OTc0NTIyMjEuNjAuMC4w', // เพิ่ม URL รูปที่คุณต้องการแสดง
                                          width:
                                              225, // ปรับขนาดรูปตามความต้องการ
                                          height: 225,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_box,
                                    size: 45,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "Contacts",
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("/patients/${patientID}/appointments")
                        .where("State", isEqualTo: "waiting")
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
                              return Padding(
                                padding:
                                    EdgeInsetsDirectional.only(bottom: 8.0),
                                child: Container(
                                  // height: 200,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFFE9F1FE), // background
                                      onPrimary:
                                          Color(0xFF545F71), // foreground
                                    ),
                                    onPressed: () {
                                      mypath = ap.id;
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => Dispense(
                                      //       mypath: mypath,
                                      //     ),
                                      //   ),
                                      // );
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         VideoCallScreen(),
                                      //   ),
                                      // );
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
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Dispense(
                                              mypath: mypath,
                                            ),
                                          ),
                                        );
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoCallScreen(
                                                    patientID, mypath),
                                          ),
                                        );
                                      } else {
                                        print("${nowTime} ${ap['QueueTime']}");
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title:
                                                      Text("ยังไม่ถึงเวลานัด"),
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
                                            "วันนัดหมาย",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "อาการ : ${ap['symptoms']}", //patientName ชลศรี น่านแก้ว
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          ),
                                          Text("ผู้ป่วย : ${ap["patientName"]}")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
                // FloatingActionButton(
                //   onPressed: () {
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Dispense(mypath: mypath,),
                //       ),
                //     );
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => VideoCallScreen(),
                //       ),
                //     );
                //   },
                //   child: Text("Video Call"),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
