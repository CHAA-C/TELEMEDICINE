import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';

class LabPage extends StatefulWidget {
  String mypath;
  LabPage({Key? key, required this.mypath}) : super(key: key);

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  String type = 'โรงพยาบาล';
  String selectedLabTest = '';
  String place = '-';
  String time = '-';
  String date = '-';
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  void paymentNoti(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('จองคิวสำเร็จ!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const HomeScreen(),
                  ),
                );
              },
              child: Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "ตรวจแลป",
          style: TextStyle(
            color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
            fontSize: 40,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "กรุณาเลือก  ",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF75C0C3),
                        ),
                      ),
                      DropdownButton<String>(
                        value: type,
                        items: <String>[
                          'โรงพยาบาล',
                          'คลินิก',
                          'แลปเฉพาะ',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 30),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            type = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("lab").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text("เกิดข้อผิดพลาด: ${snapshot.error}");
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("ไม่มีข้อมูล");
                  }

                  List<String> labData = [];

                  if (type == 'โรงพยาบาล') {
                    labData = List.from(snapshot.data!.docs[0].get("Hospital"));
                  } else if (type == 'คลินิก') {
                    labData = List.from(snapshot.data!.docs[0].get("Clinic"));
                  } else if (type == 'แลปเฉพาะ') {
                    labData = List.from(snapshot.data!.docs[0].get("Lab"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: labData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(labData[index]),
                        tileColor: labData[index] == selectedLabTest
                            ? Color(0xFF75C0C3)
                            : null,
                        onTap: () {
                          setState(() {
                            selectedLabTest = labData[index];
                            place = selectedLabTest;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Container(
                  height: 100,
                  width: 370,
                  child: Card(
                    child: ListTile(
                      title: Text('สถานที่ตรวจ : $place'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('วันที่ : $date'),
                          Text('เวลา : $time'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // StreamBuilder<QuerySnapshot>(
          //     stream: FirebaseFirestore.instance
          //         .collection("patients")
          //         .doc("user001")
          //         .collection("appointments")
          //         .doc(widget.mypath)
          //         .snapshots(),
          //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //       if (!snapshot.hasData) {
          //         return Center(child: CircularProgressIndicator());
          //       }

          //       if (snapshot.data!.docs.isEmpty) {
          //         return Text("ไม่มีข้อมูล");
          //       }
          //       return Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.only(bottom: 35.0),
          //             child: ElevatedButton(
          //               onPressed: () async {
          //                 DateTime? pickedDate = await showDatePicker(
          //                   context: context,
          //                   initialDate: DateTime.now(),
          //                   firstDate: DateTime.now(),
          //                   lastDate: DateTime(2025),
          //                 );
          //                 if (pickedDate != null) {
          //                   setState(() {
          //                     dateController.text =
          //                         pickedDate.toLocal().toString();
          //                     date = dateController.text;
          //                   });
          //                 }
          //               },
          //               child: Text("เลือกวันที่"),
          //               style: ElevatedButton.styleFrom(
          //                 primary: Color(0xFF75C0C3),
          //                 onPrimary: Colors.white,
          //               ),
          //             ),
          //           ),
          //           SizedBox(width: 20),
          //           Padding(
          //             padding: const EdgeInsets.only(bottom: 35.0),
          //             child: ElevatedButton(
          //               onPressed: () async {
          //                 TimeOfDay? pickedTime = await showTimePicker(
          //                   context: context,
          //                   initialTime: TimeOfDay.now(),
          //                 );
          //                 if (pickedTime != null) {
          //                   if (pickedTime.hour < 9 ||
          //                       pickedTime.hour > 15 ||
          //                       (pickedTime.hour == 15 &&
          //                           pickedTime.minute > 30)) {
          //                     showDialog(
          //                         context: context,
          //                         builder: (BuildContext context) {
          //                           return AlertDialog(
          //                             title: Text("กรุณาเลือกใหม่"),
          //                             content: Text(
          //                                 "โปรดเลือกเวลาในช่วง 9:00 AM - 3:30 PM"),
          //                             actions: <Widget>[
          //                               TextButton(
          //                                 onPressed: () {
          //                                   Navigator.of(context).pop();
          //                                 },
          //                                 child: Text("ตกลง"),
          //                                 style: TextButton.styleFrom(
          //                                   primary: Color(0xFF75C0C3),
          //                                 ),
          //                               ),
          //                             ],
          //                           );
          //                         });
          //                   } else {
          //                     setState(() {
          //                       timeController.text =
          //                           pickedTime.format(context);
          //                       time = timeController.text;
          //                     });
          //                   }
          //                 }
          //               },
          //               child: Text("เลือกเวลา"),
          //               style: ElevatedButton.styleFrom(
          //                 primary: Color(0xFF75C0C3),
          //                 onPrimary: Colors.white,
          //               ),
          //             ),
          //           ),
          //           SizedBox(width: 20),
          //           Padding(
          //             padding: const EdgeInsets.only(bottom: 35.0),
          //             child: ElevatedButton(
          //               onPressed: () async {
          //                 if (selectedLabTest.isNotEmpty &&
          //                     dateController.text.isNotEmpty &&
          //                     timeController.text.isNotEmpty) {
          //                   DateTime selectedDate =
          //                       DateTime.parse(dateController.text).toUtc();
          //                   String selectedTime = timeController.text;

          //                   QuerySnapshot appointmentSnapshot =
          //                       await FirebaseFirestore.instance
          //                           .collection("patients")
          //                           .doc("user001")
          //                           .collection("appointments")
          //                           .where("labState",
          //                               isEqualTo: "waiting_patient")
          //                           .get();

          //                   if (appointmentSnapshot.docs.isNotEmpty) {
          //                     for (QueryDocumentSnapshot doc
          //                         in appointmentSnapshot.docs) {
          //                       String appointmentId = doc.id;
          //                       await FirebaseFirestore.instance
          //                           .collection("patients")
          //                           .doc("user001")
          //                           .collection("appointments")
          //                           .doc(appointmentId)
          //                           .collection("LabAppointment")
          //                           .get()
          //                           .then((QuerySnapshot querySnapshot) {
          //                         querySnapshot.docs.forEach((doc) {
          //                           doc.reference.update({
          //                             "labselected": selectedLabTest,
          //                             "selectedDate": selectedDate,
          //                             "selectedTime": selectedTime,
          //                           });
          //                           doc.reference.parent.parent
          //                               ?.update({"labState": "booked"});
          //                         });
          //                       });
          //                     }
          //                   }

          //                   setState(() {
          //                     selectedLabTest = '';
          //                     dateController.clear();
          //                     timeController.clear();
          //                   });
          //                 } else {
          //                   showDialog(
          //                       context: context,
          //                       builder: (BuildContext context) {
          //                         return AlertDialog(
          //                           title: Text("กรุณาเลือกข้อมูลให้ครบ"),
          //                           content: Text(
          //                               "ยังมีข้อมูลบางส่วนที่คุณยังไม่ได้ทำการเลือก"),
          //                           actions: <Widget>[
          //                             TextButton(
          //                               onPressed: () {
          //                                 Navigator.of(context).pop();
          //                                 paymentNoti(context);
          //                               },
          //                               child: Text("ตกลง"),
          //                               style: TextButton.styleFrom(
          //                                 primary: Color(0xFF75C0C3),
          //                               ),
          //                             ),
          //                           ],
          //                         );
          //                       });
          //                 }
          //               },
          //               child: const Text("ตกลง"),
          //               style: ElevatedButton.styleFrom(
          //                 primary: Color(0xFF75C0C3),
          //                 onPrimary: Colors.white,
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     }),
        ],
      ),
    );
  }
}
