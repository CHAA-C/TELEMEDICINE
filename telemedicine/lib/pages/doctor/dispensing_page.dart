import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telemedicine/pages/doctor/result_doc.dart';
import 'package:telemedicine/pages/pharmacist/getMedList.dart';

class Dispense extends StatefulWidget {
  final String mypath;
  const Dispense({Key? key, required this.mypath}) : super(key: key);

  @override
  State<Dispense> createState() => _DispenseState();
}

class _DispenseState extends State<Dispense> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> myMed = [];
  List<String> myUnit = [];
  List<String> myPrice = [];
  List<String> myInfo = [];
  List<String> myPerday = [];
  List<String> myPertime = [];
  List<String> myQuan = [];
  List<String> myWarn = [];
  List<String> myWhen = [];
  List<String> myID = [];
  List<String> forResult = [];
  List<String> myamount = [
    'จำนวน',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  String myDocu = 'Pill00';
  String id = 'Medicine';
  String isMed = 'ไม่สั่งยา';
  String med = 'เลือกยา';
  String unit = '-';
  int medIndex = 0;
  String amount = 'จำนวน';
  String price = '0';
  List<String> info = [
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
    '-',
  ];
  List<Map<String, dynamic>> dispenseData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    QuerySnapshot snapshot = await _firestore.collection('Medicine').get();
    setState(() {
      myMed = snapshot.docs.map((doc) => doc['name'] as String).toList();
      myUnit = snapshot.docs.map((doc) => doc['amount'] as String).toList();
      myPrice = snapshot.docs.map((doc) => doc['price'].toString()).toList();
      myInfo = snapshot.docs.map((doc) => doc['info'] as String).toList();
      myPerday = snapshot.docs.map((doc) => doc['perDay'] as String).toList();
      myPertime = snapshot.docs.map((doc) => doc['perTime'] as String).toList();
      myQuan = snapshot.docs.map((doc) => doc['quantity'] as String).toList();
      myWarn = snapshot.docs.map((doc) => doc['warning'] as String).toList();
      myWhen = snapshot.docs.map((doc) => doc['when'] as String).toList();
      myID = snapshot.docs.map((doc) => doc['medID'] as String).toList();
      myMed.insert(0, med);
      myUnit.insert(0, '-');
      myPrice.insert(0, '-');
      myInfo.insert(0, '-');
      myPerday.insert(0, '-');
      myPertime.insert(0, '-');
      myQuan.insert(0, '-');
      myWarn.insert(0, '-');
      myWhen.insert(0, '-');
      myID.insert(0, '-');
    });
  }

  void printDispenseDetails() {
    if (med == 'เลือกยา' || amount == 'จำนวน') {
      print('error');
    } else {
      Map<String, dynamic> data = {
        'medicine': med,
        'quantity': amount,
        'medUnit': unit,
        'medPrice': price,
        'info': info[0],
        'perDay': info[1],
        'perTime': info[2],
        'quan': info[3],
        'warn': info[4],
        'when': info[5],
        'id': info[6],
      };
      dispenseData.add(data);
      if (dispenseData.isNotEmpty) {
        isMed = 'สั่งยา';
      } else {
        isMed = 'ไม่สั่งยา';
      }
      setState(() {
        med = 'เลือกยา';
        unit = '-';
        amount = 'จำนวน';
        info = [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
        ];
      });
    }
  }

  void _removeDispenseData(int index) {
    setState(() {
      dispenseData.removeAt(index);
      if (dispenseData.isNotEmpty) {
        isMed = 'สั่งยา';
      } else {
        isMed = 'ไม่สั่งยา';
      }
    });
  }

  Future<void> newMed({
    required String medName,
    required String medAmount,
    required int medPrice,
    required String path,
    required String pillID,
    required String medinfo,
    required String medPerday,
    required String medPertime,
    required String medQuan,
    required String medWarn,
    required String medWhen,
    required String medID,
  }) async {
    final newCollection = FirebaseFirestore.instance
        .collection('patients')
        .doc('user001')
        .collection('appointments')
        .doc(path)
        .collection('Medicine')
        .doc(pillID);
    final medState = FirebaseFirestore.instance
        .collection('patients')
        .doc('user001')
        .collection('appointments')
        .doc(path);
    final medInfo = {
      'name': medName,
      'amount': medAmount,
      'price': medPrice,
      'info': medinfo,
      'perDay': medPerday,
      'perTime': medPertime,
      'quantity': medQuan,
      'warning': medWarn,
      'when': medWhen,
      'medID': medID,
    };
    final upMed = {'MedState': "no_paid"};
    await medState.update(upMed);
    await newCollection.set(medInfo);
  }

  Future<void> noMed(String documentPath, String newState) async {
    String t = '/patients/user001/appointments/$documentPath';
    try {
      final documentReference = FirebaseFirestore.instance.doc(t);
      await documentReference.update({'State': newState});
      print('อัปเดตค่า State สำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตค่า State: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "จ่ายยา",
          style: TextStyle(
            color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
            fontSize: 40,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Container(
              margin: const EdgeInsets.all(12),
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color.fromARGB(255, 189, 230, 232),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("ชื่อยา : "),
                          DropdownButton<String>(
                            items: myMed.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: med,
                            onChanged: (String? value) {
                              setState(() {
                                med = value!;
                                unit = myUnit[myMed.indexOf(value)];
                                price = myPrice[myMed.indexOf(value)];
                                info[0] = myInfo[myMed.indexOf(value)];
                                info[1] = myPerday[myMed.indexOf(value)];
                                info[2] = myPertime[myMed.indexOf(value)];
                                info[3] = myQuan[myMed.indexOf(value)];
                                info[4] = myWarn[myMed.indexOf(value)];
                                info[5] = myWhen[myMed.indexOf(value)];
                                info[6] = myID[myMed.indexOf(value)];
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("จำนวน : "),
                          DropdownButton<String>(
                            items: myamount.map((String unitvalue) {
                              return DropdownMenuItem<String>(
                                value: unitvalue,
                                child: Text(unitvalue),
                              );
                            }).toList(),
                            value: amount,
                            onChanged: (String? unitvalue) {
                              setState(() {
                                amount = unitvalue!;
                              });
                            },
                          ),
                          Text(unit),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("สั่งยา Successful");
                  printDispenseDetails();
                },
                child: Text("+ เพิ่มยา"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Background color
                ),
                onPressed: () async {
                  print("สั่งยา Successful");
                  printDispenseDetails();
                  if (dispenseData.isNotEmpty) {
                    for (int i = 0; i < dispenseData.length; i++) {
                      String name = dispenseData[i]['medicine'];
                      String amount = dispenseData[i]['quantity'] +
                          dispenseData[i]['medUnit'];
                      int price = int.parse(dispenseData[i]['quantity']) *
                          int.parse(dispenseData[i]['medPrice']);
                      String info = dispenseData[i]['info'];
                      String perDay = dispenseData[i]['perDay'];
                      String perTime = dispenseData[i]['perTime'];
                      String quan = dispenseData[i]['quan'];
                      String warn = dispenseData[i]['warn'];
                      String when = dispenseData[i]['when'];
                      String id = dispenseData[i]['id'];
                      forResult.add(name);
                      int j = i + 1;
                      String temp = '$myDocu$j';
                      newMed(
                        medName: name,
                        medAmount: amount,
                        medPrice: price,
                        path: widget.mypath,
                        pillID: temp,
                        medinfo: info,
                        medPerday: perDay,
                        medPertime: perTime,
                        medQuan: quan,
                        medWarn: warn,
                        medWhen: when,
                        medID: id,
                      );
                    }
                    forResult.insert(0, widget.mypath);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultDoc(
                                dispenseData: dispenseData,
                                mypath: widget.mypath)));
                  } else {
                    noMed(widget.mypath, 'done');
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultDoc(
                                dispenseData: dispenseData,
                                mypath: widget.mypath)));
                  }
                },
                child: Text(isMed,
                    style: TextStyle(
                      color: isMed == 'สั่งยา'
                          ? Colors.green
                          : Colors.red, // กำหนดสีฟ้อน
                    )),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dispenseData.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('ชื่อยา: ${dispenseData[index]['medicine']}'),
                    subtitle: Text(
                        'จำนวน: ${dispenseData[index]['quantity']} ${dispenseData[index]['medUnit']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _removeDispenseData(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
