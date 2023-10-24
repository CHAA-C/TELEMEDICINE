import 'package:flutter/material.dart';
import 'package:telemedicine/pages/Queue.dart';

class HistoryTaking extends StatefulWidget {
  const HistoryTaking({super.key});

  @override
  State<HistoryTaking> createState() => _HistoryTakingState();
}

class HistoryData {
  final String symptoms;
  final String startDate;
  final bool isFamilyMemberExperienced;
  final String symptomTriggers;
  final bool isCloseContact;
  final String symptomSeverity;
  final String additionalNotes;

  HistoryData({
    required this.symptoms,
    required this.startDate,
    required this.isFamilyMemberExperienced,
    required this.symptomTriggers,
    required this.isCloseContact,
    required this.symptomSeverity,
    required this.additionalNotes,
  });
}

class _HistoryTakingState extends State<HistoryTaking> {
  final _formKey = GlobalKey<FormState>();
  bool isFamilyMemberExperienced = false;
  bool isCloseContact = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();
  TextEditingController _symptomTriggersController = TextEditingController();
  String _symptomSeverityController = "";
  TextEditingController _additionalNotesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
      title: "ซักประวัติ",
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "ซักประวัติ",
            style: TextStyle(
                color: Color(0xFF373B44),
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0), // ปรับค่า padding ตามที่คุณต้องการ
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text("อาการเป็นอย่างไร",
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  TextFormField(
                    controller: _symptomsController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "ปวดหัว , ตัวร้อน , เป็นผื่นคัน"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่ข้อมูลอาการ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("วันที่เริ่มเป็น",
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    validator: (value) {
                      var now = DateTime.now();
                      final inputDate = value!.split("/");
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่วันที่เริ่มเป็น';
                      }
                      if (int.parse(inputDate[2]) > now.year) {
                        // ปีผิด
                        return 'กรุณาใส่ปีให้ถูกต้อง';
                      } else {
                        if (int.parse(inputDate[1]) > now.month) {
                          //ปีถูก เดือนผิด
                          return 'กรุณาใส่เดือนให้ถูกต้อง';
                        } else {
                          if (int.parse(inputDate[0]) > now.day) {
                            //ปีถูก เดือนถูก วันผิด
                            return 'กรุณาใส่วันให้ถูกต้อง';
                          }
                        }
                      }
                      // print(DateTime.now().day);
                      // print(inputDate);
                      // print({DateTime.now().day.runtimeType});
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('ญาติพี่น้องเคยมีอาการนี้ไหม',
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text('เคย'),
                        selected: isFamilyMemberExperienced,
                        selectedColor: Color(0xFF75C0C3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        shadowColor: Colors.grey,
                        onSelected: (selected) {
                          setState(() {
                            isFamilyMemberExperienced = true;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ChoiceChip(
                        label: Text('ไม่เคย'),
                        selected: !isFamilyMemberExperienced,
                        selectedColor: Color(0xFF75C0C3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            isFamilyMemberExperienced = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('อาการจะกำเริบเมื่อใด',
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  TextFormField(
                    controller: _symptomTriggersController,
                    decoration: InputDecoration(
                      hintText: "เมื่ออากาศร้อน , เมื่อทำงานหนัก",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่ว่าอาการจะกำเริบเมื่อใด';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('เคยสนิทสนม ใกล้ชิดกับคนที่มีอาการเดียวกันไหม',
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text('เคย'),
                        selected: isCloseContact,
                        selectedColor: Color(0xFF75C0C3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            isCloseContact = true;
                          });
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ChoiceChip(
                        label: Text('ไม่เคย'),
                        selected: !isCloseContact,
                        selectedColor: Color(0xFF75C0C3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            isCloseContact = false;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('อาการมีมากน้อยเพียงใด',
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // กำหนดรูปร่างขอบ
                        borderSide:
                            BorderSide(color: Colors.grey), // กำหนดสีขอบ
                      ),
                    ),
                    hint: Text("ระบุความหนักเบาของอาการ"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาระบุความหนักเบาของอาการ';
                      }
                      return null;
                    },
                    items: <String>['มาก', 'ปานกลาง', 'น้อย']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _symptomSeverityController = value.toString();
                      });
                    },
                  ),
                  // TextFormField(
                  //   controller: _symptomSeverityController,
                  //   decoration: InputDecoration(
                  //     hintText: 'มาก / น้อย / ทนได้',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'กรุณาใส่ว่ามีอาการมากน้อยเพียงใด';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('หมายเหตุ',
                      style: TextStyle(
                          color: Color(
                            0xFF6D6D6D,
                          ),
                          fontSize: 17)),
                  TextFormField(
                    controller: _additionalNotesController,
                    decoration: InputDecoration(
                      hintText: "บอกลักษณะอาการเพิ่มเติม",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 300.0,
                        height: 50.0,
                        child:
                            // TextButton(
                            //   style: TextButton.styleFrom(
                            //     backgroundColor: Color(0xFF75C0C3),
                            //     textStyle:
                            //         TextStyle(color: Colors.black, fontSize: 20),
                            //   ),
                            //   onPressed: () {
                            //     if (_formKey.currentState!.validate()) {
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //             content: Text('Processing Data')),
                            //       );
                            //     }
                            //   },
                            //   child: const Text('ถัดไป'),
                            // ),

                            ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF75C0C3),
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              HistoryData historyData = HistoryData(
                                symptoms: _symptomsController.text,
                                startDate: _dateController.text,
                                isFamilyMemberExperienced:
                                    isFamilyMemberExperienced,
                                symptomTriggers:
                                    _symptomTriggersController.text,
                                isCloseContact: isCloseContact,
                                symptomSeverity: _symptomSeverityController,
                                additionalNotes:
                                    _additionalNotesController.text,
                              );

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //       content: Text('Processing Data')),
                              // );

                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) =>
                                      Queue(historyData: historyData),
                                ),
                              );
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
