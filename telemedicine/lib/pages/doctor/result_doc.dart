import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';
import 'package:telemedicine/pages/doctor/docHome.dart';

String id = 'ap001';
String name = ''; // ตัวแปรเก็บชื่อผู้ป่วย
String allergy = '';
String incrementedDoc = "";

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

class ResultDoc extends StatefulWidget {
  final String mypath;
  final List<Map<String, dynamic>> dispenseData;
  ResultDoc({Key? key, required this.dispenseData, required this.mypath})
      : super(key: key);

  @override
  State<ResultDoc> createState() => _ResultDocState();
}

class _ResultDocState extends State<ResultDoc> {
  TextEditingController departmentController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController diagnosisResultController = TextEditingController();
  TextEditingController nextAppointmentController = TextEditingController();

  DateTime? selectedDate;
  bool? nextAppointmentEnabled = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('patients').get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        name = snapshot.docs.first.data()!['name'] as String;
        allergy = snapshot.docs.first.data()!['allergicHistory'] as String;
      });
    }
  }

  Future<void> CreateData(
      {required DateTime? queueDate,
      required String department,
      required String docName,
      required String symptom,
      required String diagnosisResult,
      required String resultID,
      required List<Map<String, dynamic>> dispenseData,
      required DateTime? nextAppointment}) async {
    final newCollection = FirebaseFirestore.instance
        .collection('patients')
        .doc('user001')
        .collection('appointments')
        .doc(widget.mypath)
        .collection('Result')
        .doc(resultID);

    String formatDispenseData(List<Map<String, dynamic>> dispenseData) {
      List<String> formattedData = dispenseData.map((data) {
        final medicine = data['medicine'];
        final quantity = data['quantity'];
        final medUnit = data['medUnit'];
        return '$medicine $quantity $medUnit';
      }).toList();

      return formattedData.join(', ');
    }

    final json = {
      'Date': queueDate,
      'Department': department,
      'DocName': docName,
      'Symptom': symptom,
      'DiagnosisResult': diagnosisResult,
      'Medicine': formatDispenseData(dispenseData),
      'PatientName': name,
      'allergicHistory': allergy,
      'NextAppointment':
          nextAppointment != null ? nextAppointment : "ไม่มีนัดครั้งต่อไป",
    };

    await newCollection.set(json);
  }

  Future<void> next(String newState) async {
    String t = '/patients/user001/appointments/${widget.mypath}';
    try {
      final documentReference = FirebaseFirestore.instance.doc(t);
      await documentReference.update({'State': newState});
      print('อัปเดตค่า State สำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตค่า State: $e');
    }
  }

  Future<void> Wantadpai(DateTime nextAppointment) async {
    String t = '/patients/user001/appointments/${widget.mypath}';
    try {
      final documentReference = FirebaseFirestore.instance.doc(t);
      await documentReference.update({'QueueDate': nextAppointment});
      print('อัปเดตค่า State สำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตค่า State: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        nextAppointmentController.text = picked.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายงานผลวินิจฉัย"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(departmentController, 'แผนกที่ตรวจ'),
              _buildTextField(symptomController, 'อาการ'),
              _buildTextField(diagnosisResultController, 'ผลการวินิจฉัย'),
              CheckboxListTile(
                title: Text('นัดครั้งถัดไป'),
                value: nextAppointmentEnabled ?? false,
                onChanged: (value) {
                  setState(() {
                    nextAppointmentEnabled = value;
                    if (value == true) {
                      next('waiting');
                      _selectDate(context);
                    } else {
                      next('done');
                    }
                  });
                },
              ),
              if (nextAppointmentEnabled == true)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Icon(Icons.calendar_today),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: _buildTextField(
                        nextAppointmentController,
                        'วันที่นัดครั้งถัดไป',
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // next('waiting');
                  DateTime? nextAppointment;
                  if (nextAppointmentEnabled == true) {
                    nextAppointment =
                        DateTime.parse(nextAppointmentController.text);
                  }
                  Wantadpai(nextAppointment!);

                  var collection = FirebaseFirestore.instance
                      .collection('patients')
                      .doc('user001')
                      .collection('appointments')
                      .doc(id)
                      .collection('Result');

                  var allDocs = await collection.get();
                  if (allDocs.docs.isEmpty) {
                    // ไม่มีเอกสารอยู่เลย
                    incrementedDoc = 're001';
                  } else {
                    var docID = allDocs.docs.last.id;
                    incrementedDoc = incrementNumericString(docID);
                  }

                  CreateData(
                      queueDate: DateTime.now(),
                      department: departmentController.text,
                      docName: 'น.พ.สมศักดิ์ กิตติการ',
                      symptom: symptomController.text,
                      diagnosisResult: diagnosisResultController.text,
                      dispenseData: widget.dispenseData,
                      nextAppointment: nextAppointment,
                      resultID: incrementedDoc);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => docHome()));
                },
                child: Text('บันทึกข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          enabled: enabled,
        ),
      ),
    );
  }
}
