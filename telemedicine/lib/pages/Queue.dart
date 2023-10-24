import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';
import 'package:telemedicine/pages/HistoryTaking.dart';

class Queue extends StatelessWidget {
  final HistoryData historyData;
  const Queue({super.key, required this.historyData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "HotDoc",
      home: QueuePage(historyData: historyData),
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
    );
  }
}

class AppointInfo {
  String? hospital;
  String? time;
  DateTime? date;

  AppointInfo({this.hospital, this.time, this.date});
}

class QueuePage extends StatefulWidget {
  final HistoryData historyData;

  QueuePage({required this.historyData});

  @override
  State<QueuePage> createState() => _QueuePagestate(historyData: historyData);
}

class _QueuePagestate extends State<QueuePage> {
  final HistoryData historyData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DateTime> myQdate = [];
  List<String> myQtime = [];

  _QueuePagestate({required this.historyData}) {
    _selectedHospital = _hospitalList[0];
    _selectedTime = _timeList[0];
  }

  final _hospitalList = [
    "โรงพยาบาลพระมุงกุฎ",
    "โรงพยาบาลภูมิพล",
    "โรงพยาบาลศิริราช",
    "รงพยาบาลรามาธิบดี ",
    "โรงพยาบาลธรรมศาสตร์",
    "โรงพยาบาลรังสิต",
    "โรงพยาบาล CSG",
    "โรงพยาบาลชาติหน้าค่อยว่ากัน",
    "โรงพยาบาลข้นอีสาน",
    "โรงพยาบาลสวนตาชม"
  ];
  final _timeList = [
    "8.00",
    "9.00",
    "10.00",
    "11.00",
    "13.00",
    "14.00",
    "15.00",
    "21.00"
  ];
  String? _selectedHospital = "";
  String? _selectedTime = "";
  DateTime? _selectedDate;
  String incrementedDoc = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != _selectedDate) {
      // Remove the time component from the selected date
      final dateWithoutTime = DateTime(picked.year, picked.month, picked.day);
      setState(() {
        _selectedDate = dateWithoutTime;
      });
    }
  }

  void _loadData() async {
    QuerySnapshot snapshot = await _firestore.collection('appointments').get();
    setState(() {
      myQdate =
          snapshot.docs.map((doc) => doc['QueueDate'] as DateTime).toList();
      myQtime = snapshot.docs.map((doc) => doc['QueueTime'] as String).toList();
    });
  }

  Future<dynamic> CreateData(
      {required String symptoms,
      required String startDate,
      required bool isFam,
      required String symptomTriggers,
      required bool isClose,
      required String symptomSeverity,
      required String additionalNotes,
      required String id,
      required String? hospital,
      required DateTime? queueDate,
      required String? queueTime}) async {
    final newDocument = FirebaseFirestore.instance
        .collection('patients')
        .doc('user001')
        .collection('appointments')
        .doc(id);
    final json = {
      'symptoms': symptoms,
      'startDate': startDate,
      'isFamilyMemberExperienced': isFam,
      'symptomTriggers': symptomTriggers,
      'isCloseContact': isClose,
      'symptomSeverity': symptomSeverity,
      'additionalNotes': additionalNotes,
      'State': 'waiting',
      'Hospital': hospital,
      'QueueDate': queueDate,
      'QueueTime': queueTime,
      'docName': 'น.พ.สมศักดิ์ กิตติการ',
    };

    await newDocument.set(json);
  }

  AppointInfo _appointInfo = AppointInfo();

  Future<void> checkDuplicateDate(DateTime selectedDate) async {
    var collection = FirebaseFirestore.instance
        .collection('patients')
        .doc('user001')
        .collection('appointments');

    QuerySnapshot querySnapshot =
        await collection.where('QueueDate', isEqualTo: selectedDate).get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('วันที่นี้มีนัดหมายแล้ว'),
        ),
      );
      return;
    } else {
      // ไม่มีวันที่ซ้ำ ทำการเพิ่มข้อมูลเหมือนเดิม
      final symptoms = historyData.symptoms;
      final startDate = historyData.startDate;
      final isFam = historyData.isFamilyMemberExperienced;
      final sympTomTriggers = historyData.symptomTriggers;
      final isClose = historyData.isCloseContact;
      final symptomSeverity = historyData.symptomSeverity;
      final additionalNotes = historyData.additionalNotes;

      _showHistoryData();

      var allDocs = await collection.get();
      if (allDocs.docs.isEmpty) {
        incrementedDoc = 'ap001';
      } else {
        var docID = allDocs.docs.last.id;
        incrementedDoc = incrementNumericString(docID);
      }

      CreateData(
          symptoms: symptoms,
          startDate: startDate,
          isFam: isFam,
          symptomTriggers: sympTomTriggers,
          isClose: isClose,
          symptomSeverity: symptomSeverity,
          additionalNotes: additionalNotes,
          id: incrementedDoc,
          hospital: _selectedHospital,
          queueDate: selectedDate, // ใช้วันที่ที่ผู้ใช้เลือก
          queueTime: _selectedTime);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  Future<void> _showHistoryData() async {
    // แสดงข้อมูลจาก historyData
    // print("อาการ: ${historyData.symptoms}");
    // print("วันที่เริ่มเป็น: ${historyData.startDate}");
    // print("ญาติพี่น้องเคยมีอาการ: ${historyData.isFamilyMemberExperienced}");
    // print("อาการจะกำเริบเมื่อใด: ${historyData.symptomTriggers}");
    // print("เคยสนิทสนมใกล้ชิด: ${historyData.isCloseContact}");
    // print("อาการมีมากน้อยเพียงใด: ${historyData.symptomSeverity}");
    // print("หมายเหตุ: ${historyData.additionalNotes}");

    // _appointInfo.hospital = _selectedHospital;
    // _appointInfo.time = _selectedTime;
    // _appointInfo.date = _selectedDate;

    // print("สถานที่จอง: ${_appointInfo.hospital}");
    // print("วันนัดพบ: ${_appointInfo.date}");
    // print("เวลานัดพบ: ${_appointInfo.time}");

    var collection = FirebaseFirestore.instance
        .collection('patients')
        .doc('user001')
        .collection('appointments');

    var allDocs = await collection.get();
    var docID = allDocs.docs.last.id;

    String incrementedString = incrementNumericString(docID);

    print(incrementedString);
  }

  String incrementNumericString(String input) {
    // Find the numeric part of the input string.
    String numericPart = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericPart.isNotEmpty) {
      // Parse the numeric part and increment it.
      int numericValue = int.parse(numericPart);
      numericValue++;

      // Determine the number of leading zeros based on the original numeric part length.
      String leadingZeros =
          '0' * (numericPart.length - numericValue.toString().length);

      // Create the incremented string with the same non-numeric part and leading zeros.
      return input.replaceAll(RegExp(r'[0-9]'), '') +
          leadingZeros +
          numericValue.toString();
    } else {
      // If there's no numeric part, return the original string.
      return input;
    }
  }

  bool _isTimeInvalid(String time) {
    final currentTime = DateTime.now();
    final selectedTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      int.parse(time.split(":")[0]),
      int.parse(time.split(":")[1]),
    );
    print(_selectedTime);
    return selectedTime.isBefore(currentTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            "assets/images/back.png",
          ),
          iconSize: 40,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/images/select.png",
            ),
            iconSize: 40,
            onPressed: () {},
          )
        ],
        title: Text(
          "จองคิว",
          style: TextStyle(
              color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
              fontSize: 40),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "สถานที่จอง",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedHospital,
                  items: _hospitalList
                      .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedHospital = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "วันนัดพบ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                        : "",
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "เวลานัดพบ",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedTime,
                  items: _timeList
                      .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedTime = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        var now = DateTime.now();
                        if (_selectedDate == null ||
                            _selectedDate!.day < now.day) {
                          print(_selectedDate!.day);
                          print(now.hour);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('กรุณาเลือกวันที่ให้ถูกต้อง'),
                            ),
                          );
                          return;
                        }
                        double timeDouble =
                            double.parse(_selectedTime!); // แปลงเป็น double
                        int timeInt =
                            timeDouble.toInt(); // แปลง double เป็น int
                        if (_selectedDate!.day == now.day &&
                            timeInt < now.hour) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('กรุณาเลือกเวลาให้ถูกต้อง'),
                            ),
                          );
                          return;
                        }

                        // เรียกใช้ฟังก์ชันเพื่อตรวจสอบว่าวันที่มีซ้ำกันหรือไม่
                        await checkDuplicateDate(_selectedDate!);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // กำหนดรูปแบบของมุม
                        ),
                        backgroundColor: Colors.teal[300],
                      ),
                      child: const Text(
                        "ยืนยัน",
                        style: TextStyle(fontSize: 18),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
