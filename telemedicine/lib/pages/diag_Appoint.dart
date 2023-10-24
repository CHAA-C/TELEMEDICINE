import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';
import 'package:telemedicine/pages/diagnosis_result.dart';
import 'package:telemedicine/pages/lab_page.dart';
import 'package:telemedicine/pages/paying.dart';

class DiagAppoint extends StatefulWidget {
  const DiagAppoint({Key? key}) : super(key: key);

  @override
  _DiagAppointState createState() => _DiagAppointState();
}

class _DiagAppointState extends State<DiagAppoint> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HotDoc",
      home: DiagAppointpage(),
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
    );
  }
}

class DiagAppointpage extends StatefulWidget {
  String mypath = '';

  DiagAppointpage({super.key});
  @override
  _DiagAppointpageState createState() => _DiagAppointpageState();
}

class _DiagAppointpageState extends State<DiagAppointpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "ผลวินิจฉัย",
          style: TextStyle(
            color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
            fontSize: 40,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("patients")
              .doc("user001")
              .collection("appointments")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final appointmentSnapshot = snapshot.data!.docs;
            return ListView.builder(
                itemCount: appointmentSnapshot.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                          height: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                widget.mypath =
                                    "${appointmentSnapshot[index].id}";
                                Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiagResult(
                                      mypath: widget.mypath,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                primary: Color(0xFFE9F1FE),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "วันนัดหมาย",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${appointmentSnapshot[index]['QueueDate'].toDate().hour}:${(appointmentSnapshot[index]['QueueDate'].toDate().minute)} น. - ${appointmentSnapshot[index]['QueueDate'].toDate().hour + 1}:${(appointmentSnapshot[index]['QueueDate'].toDate().minute)} น.',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              '${appointmentSnapshot[index]['QueueDate'].toDate().day} ${_getMonth(appointmentSnapshot[index]['QueueDate'].toDate().month)} ${appointmentSnapshot[index]['QueueDate'].toDate().year}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Divider(
                                            color: Colors.grey, thickness: 3),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            CircleAvatar(radius: 12),
                                            Text(
                                                ' ${appointmentSnapshot[index]['docName']}',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ])))));
                });
          }),
    );
  }

  String _getMonth(int month) {
    // ฟังก์ชัน _getMonth คือฟังก์ชันที่จะดึงชื่อเดือนจากหมายเลขเดือน
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
}
