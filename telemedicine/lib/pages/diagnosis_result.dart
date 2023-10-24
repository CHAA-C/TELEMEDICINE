import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';
import 'package:telemedicine/pages/lab_page.dart';
import 'package:telemedicine/pages/med_receive.dart';

class DiagResult extends StatefulWidget {
  String mypath;
  DiagResult({Key? key, required this.mypath}) : super(key: key);

  @override
  State<DiagResult> createState() => _DiagResultState();
}

class _DiagResultState extends State<DiagResult> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showLabButtons = false;
  bool showMedButtons = false;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('patients')
        .doc('user001')
        .collection('appointments')
        .doc(widget.mypath)
        .get();
    setState(() {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('MedState') &&
            data['MedState'] != null &&
            data['MedState'] != 'done') {
          showMedButtons = true;
        }
        if (data.containsKey('labState') &&
            data['labState'] != null &&
            data['labState'] != 'done') {
          showLabButtons = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------- Header ------------ //
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "ผลวินิจฉัย",
          style: TextStyle(
              color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
              fontSize: 40),
        ),
      ),
      body: Container(
        child: Column(children: [
          // ----------- ข้อมูล ------------ //
          SingleChildScrollView(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("patients")
                  .doc("user001")
                  .collection("appointments")
                  .doc(widget.mypath)
                  .collection("Result")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Text("ไม่มีข้อมูล");
                }

                Map<String, dynamic> data =
                    snapshot.data!.docs.first.data() as Map<String, dynamic>;
                String doctorName = data['DocName'];
                String patientName = data['PatientName'];
                String symptom = data['Symptom'];
                String DiagResult = data['DiagnosisResult'];

                return Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  height: 400,
                  width: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Color.fromARGB(255, 209, 251, 255),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          Text(
                            "ผู้ตรวจอาการ : $doctorName\n",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "ผู้ป่วย : $patientName\n",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "อาการ : $symptom\n",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "ผลวินิจฉัย : $DiagResult\n",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18,
                            ),
                          ),
                          // Text(
                          //   "รายการยา : $myMed\n",
                          //   style: TextStyle(
                          //     color: Color.fromARGB(255, 0, 0, 0),
                          //     fontSize: 18,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // ----------- ปุ่ม , ไอคอน ------------ //
          // Container(
          //   margin: const EdgeInsets.all(0.0),
          //   padding: const EdgeInsets.all(2.0),
          //   width: 400,
          //   height: 220,
          //child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: showLabButtons,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 145,
                        margin: const EdgeInsets.all(8),
                        //height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Color.fromARGB(255, 189, 230, 232),
                          // border: Border.all(width: 5)
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 37, 37, 37),
                              // blurRadius: 25.0,
                              // spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(4, 3),
                            )
                          ],
                        ),
                        child: IconButton(
                          icon: Image.asset(
                            "assets/images/lab.png",
                          ),
                          iconSize: 90,
                          onPressed: () {
                            Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LabPage(
                                  mypath: widget.mypath,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Text(
                        'จองตรวจแลป',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff000000),
                        ),
                      ),
                    ]),
              ),
              Visibility(
                visible: showMedButtons,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 145,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Color.fromARGB(
                              255, 189, 230, 232), //117, 192, 195
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 37, 37, 37),
                              // blurRadius: 25.0,
                              // spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(4, 3),
                            )
                          ],
                          // border: Border.all(width: 5)
                        ),
                        child: IconButton(
                          icon: Image.asset(
                            "assets/images/med.png",
                          ),
                          iconSize: 90,
                          onPressed: () {
                            Navigator.pushReplacement<void, void>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Meddy(
                                  mypath: widget.mypath,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const Text(
                        'รับยา',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff000000),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
          //),
        ]),
      ),
    );
  }
}
