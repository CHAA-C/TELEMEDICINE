import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:telemedicine/homeIcons.dart';

TextStyle heading = TextStyle(color: Color(0xff373b44), fontSize: 18);

class Medicine {
  String amount;
  DateTime date;
  String info;
  String medID;
  String name;
  String perDay;
  String perTime;
  int price;
  String warning;
  String when;
  String quantity;
  Medicine(
      {required this.amount,
      required this.date,
      required this.name,
      required this.info,
      required this.medID,
      required this.perDay,
      required this.price,
      required this.warning,
      required this.when,
      required this.perTime,
      required this.quantity});

  factory Medicine.fromMap(Map<String, dynamic> data) {
    return Medicine(
      name: data['name'],
      amount: data['amount'],
      date: data['date'].toDate(),
      info: data['info'],
      medID: data['medID'],
      perDay: data['perDay'],
      perTime: data['perTime'],
      price: data['price'],
      warning: data['warning'],
      when: data['when'],
      quantity: data['quantity'],
    );
  }
}

class getMedList extends StatefulWidget {
  const getMedList({super.key});

  @override
  State<getMedList> createState() => _getMedListState();
}

class _getMedListState extends State<getMedList> {
  bool visibleControl = false;
  String patientID = "";
  List<Medicine> medicines = [];
  String appointmentID = "ap001";
  void showData() {
    if (patientID != "") {
      FirebaseFirestore.instance
          .collection(
              "/patients/user001/appointments/${appointmentID}/Medicine")
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.docs.isNotEmpty) {
          medicines = snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            return Medicine.fromMap(data);
          }).toList();
          setState(() {});
        }
      });
    }
  }

  void updateStatus() {
    var db = FirebaseFirestore.instance;
    final appointRef = db
        .collection("/patients/${patientID}/appointments")
        .doc("${appointmentID}");
    appointRef.update({"State": "done"}).then(
        (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    setState(() {
      appointmentID = "";
      patientID = "";
      medicines = [];
      visibleControl = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            "รายการยาผู้ป่วย",
            style: TextStyle(
                color: Color(0xff373b44),
                fontSize: 40),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(children: [
              _showProfile(patientID),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: medicines.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return Text("Hello");
                    return Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            MyHomeIcons.pills,
                            size: 45,
                            color: Colors.black,
                          ),
                          title: Text(medicines[index].name),
                          subtitle: Text(
                              '${medicines[index].quantity}\t${medicines[index].amount}\nวันละ ${medicines[index].perDay}\t ครั้งละ ${medicines[index].perTime}\n${medicines[index].when}'),
                        ),
                        Divider(
                          height: 2,
                        ),
                      ],
                    );
                  }),
              Visibility(
                visible: visibleControl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(4.0),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color(0xFF75C0C3)),
                        ),
                        onPressed: () {
                          setState(() {
                            patientID = "";
                            appointmentID = "";
                            medicines = [];
                            visibleControl = false;
                          });
                        },
                        child: Text(
                          "ยกเลิก",
                          style: TextStyle(color: Color(0xff373b44)),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(4.0),
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Color(0xFF75C0C3)),
                        ),
                        onPressed: updateStatus,
                        child: Text(
                          "เสร็จสิ้น",
                          style: TextStyle(color: Color(0xff373b44)),
                        )),
                  ],
                ),
              )
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF75C0C3),

          onPressed: () {
            startScan();
          },
          child: Icon(Icons.qr_code_scanner, color: Color(0xff373b44)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          selectedItemColor: Color(0xff75c0c3),
          items: [
            BottomNavigationBarItem(
                icon: Icon(MyHomeIcons.pills), label: "จ่ายยา"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล"),
          ],
          onTap: (index) {
            print(index);
          },
        ),
      ),
    );
  }

  Widget _showProfile(patientID) {
    if (patientID == "") {
      return Text("โปรดสแกนคิวอาร์โค้ดเพื่ออ่านข้อมูลผู้ป่วย");
    } else {
      visibleControl = true;
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("patients")
            .doc(patientID)
            .snapshots(),
        builder: (context, user) {
          return user.hasData
              ? Container(
                  height: 100,
                  width: double.infinity,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Color(0xFF75C0C3),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  '${user.data!.get('profileImg')}'),
                            ),
                            SizedBox(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.data!.get('name'),
                                  style: heading,
                                ),
                                Text(
                                  user.data!.get('phone'),
                                  style: heading,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                )
              : CircularProgressIndicator();
        },
      );
    }
  }

  startScan() async {
    //อ่านข้อมูลจาก qrcode
    String? cameraScanResult = await scanner.scan();
    setState(() {
      var inp = cameraScanResult!.split(" ");
      patientID = inp[0];
      appointmentID = inp[1];
      showData();
    });
  }
}
