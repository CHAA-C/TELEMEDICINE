import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';
import 'package:telemedicine/pages/diagnosis_result.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Meddy extends StatelessWidget {
  final String mypath;
  const Meddy({Key? key, required this.mypath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String appointmentID = mypath;
    String patientID = "user001";
    return Scaffold(
      //extendBodyBehindAppBar: true,
      // ----------- Header ------------ //
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "รับยา",
          style: TextStyle(
              color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
              fontSize: 40),
        ),
        //backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),

      // ----------- รูป , ชื่อ ------------ //
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/medBG.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("patients")
                .doc("user001")
                .collection("appointments")
                .snapshots(),
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

              Map<String, dynamic> data =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;
              String name = data['patientName'];

              return Container(
                margin: const EdgeInsets.all(12),
                width: 370,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  color: Color.fromARGB(255, 117, 192, 195),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/images/55.jpg"),
                          radius: 44,
                        ),
                        Text(
                          "คุณ:    $name",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // ----------- ข้อมูล ------------ //
          SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("patients")
                  .doc("user001")
                  .collection("appointments")
                  .doc(appointmentID)
                  .collection("Result")
                  .snapshots(),
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

                Map<String, dynamic> data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                String department = data['Department'];
                String docName = data['DocName'];
                String medicine = data['Medicine'];

                return Container(
                  width: 370,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Color.fromARGB(255, 233, 241, 254),
                  ),
                  child: Scrollbar(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: ListView(
                        children: [
                          Text("ชื่อแพทย์  : $docName\n",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              )),
                          Text("แผนก   : $department\n",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              )),
                          Text("รายการยา  : $medicine\n",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              )),
                          Text("ประวัติการแพ้ยา  : $medicine\n",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // -------- QR --------- //
          Container(
            width: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: '${patientID} ${appointmentID}',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ],
            ),
          ),

          // -------- ปุ่ม --------- //
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                child: const Text("เสร็จสิ้น")),
          ]),
        ]),
      ),
    );
  }
}
