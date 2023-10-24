import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telemedicine/pages/HomeScreen.dart';

class Paying extends StatefulWidget {
  final String mypath;
  const Paying({Key? key, required this.mypath}) : super(key: key);

  @override
  State<Paying> createState() => _PayingState();
}

class _PayingState extends State<Paying> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> myMed = [];
  List<String> myUnit = [];
  List<String> myPrice = [];
  String payMethod = 'ชำระผ่านบัญชีธนาคาร/บัตรเดบิต';
  int total = 0;
  List<Map<String, dynamic>> paymentData = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> upState(String documentPath, String newState) async {
    String t = '/patients/user001/appointments/$documentPath';
    try {
      final documentReference = FirebaseFirestore.instance.doc(t);
      await documentReference.update({'MedState': newState});
      print('อัปเดตค่า State สำเร็จ');
    } catch (e) {
      print('เกิดข้อผิดพลาดในการอัปเดตค่า State: $e');
    }
  }

  void _loadData() async {
    QuerySnapshot snapshot = await _firestore
        .collection("patients")
        .doc("user001")
        .collection("appointments")
        .doc(widget.mypath)
        .collection("Medicine")
        .get(); //patients/user001/appointments/ap002/Medicine
    setState(() {
      myMed = snapshot.docs.map((doc) => doc['name'] as String).toList();
      myUnit = snapshot.docs.map((doc) => doc['amount'] as String).toList();
      myPrice = snapshot.docs.map((doc) => doc['price'].toString()).toList();
      for (int i = 0; i < myMed.length; i++) {
        Map<String, dynamic> data = {
          'medicine': myMed[i],
          'quantity': myUnit[i],
          'medPrice': myPrice[i],
        };
        paymentData.add(data);
        total += int.parse(myPrice[i]);
        //print(total);
      }
    });
  }

  void changePayMethod(BuildContext context) async {
    String? selectedPaymentMethod = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("เลือกช่องทางการชำระเงิน"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'ชำระผ่านบัญชีธนาคาร/บัตรเดบิต');
              },
              child: Text('ชำระผ่านบัญชีธนาคาร/บัตรเดบิต'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Mobile Banking');
              },
              child: Text('Mobile Banking'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'Mastercard');
                payMethod = 'Mastercard';
              },
              child: Text('Mastercard'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'บัตรเครดิต');
              },
              child: Text('บัตรเครดิต'),
            ),
          ],
        );
      },
    );

    if (selectedPaymentMethod != null) {
      //print("ผู้ใช้เลือก: $selectedPaymentMethod");
      setState(() {
        payMethod = selectedPaymentMethod;
      });
    }
  }

  void paymentNoti(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('การชำระเงินสำเร็จ!'),
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
          "ชำระเงิน",
          style: TextStyle(
            color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
            fontSize: 40,
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
                width: 320,
                height: 320,
                child: ListView.builder(
                  itemCount: paymentData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text('${paymentData[index]['medicine']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('จำนวน: ${paymentData[index]['quantity']}'),
                            Text('ราคา: ${paymentData[index]['medPrice']} บาท'),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
          Center(
            child: Container(
              width: 320,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total : $total บาท",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("ชำระผ่าน : $payMethod")
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    print("Payment Successful");
                    changePayMethod(context);
                  },
                  child: Text("+ ช่องทาง")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    print(widget.mypath);
                    upState(widget.mypath, 'done');
                    paymentNoti(context);
                  },
                  child: Text("ชำระเงิน")),
            ],
          ),
        ],
      ),
    );
  }
}
