import 'package:agora_uikit/agora_uikit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  String patientID;
  String appointmentID;
  VideoCallScreen(this.patientID, this.appointmentID) {}

  @override
  State<VideoCallScreen> createState() =>
      _VideoCallScreenState(this.patientID, this.appointmentID);
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  String patientID;
  String appointmentID;
  _VideoCallScreenState(this.patientID, this.appointmentID) {}
  final _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'f652a31a99c945dc8668aabb21a4bd08',
      channelName: 'testing',
      tempToken:
          '007eJxTYJh14OPX9BW+lYKXjDdGST7u5liZeeLaez2ZBbGiN9xM125UYEgzMzVKNDZMtLRMtjQxTUm2MDOzSExMSjIyTDRJSjGwcL+rk9oQyMiQ7JLNwAiFID47Q0lqcUlmXjoDAwD5HSEV',
      uid: 13,
      username: 'doctor',
    ),
  );

  Future<void> _initializeAgora() async {
    await _client.initialize();
  }

  @override
  void initState() {
    _initializeAgora();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          height: 400,
                          color: Color(0xFF75C0C3),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('patients')
                                          .doc('user001')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text('no data');
                                        } else {
                                          var patientInfo =
                                              snapshot.data!.data();
                                          return ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        '${patientInfo?['profileImg']}'),
                                                    radius: 50,
                                                  )),
                                              Text(
                                                  'ชื่อ ${patientInfo?['name']}'),
                                              Text(
                                                  'วันเกิด ${patientInfo?['birthDate'].toDate().day} ${_getMonth(patientInfo?['birthDate'].toDate().month)} ${patientInfo?['birthDate'].toDate().year}'),
                                              Text(
                                                  'อายุ ${patientInfo?['ages']}'),
                                              Text(
                                                  'เพศ ${patientInfo?['sex']}'),
                                              Text(
                                                  'อีเมล ${patientInfo?['email']}'),
                                              Text(
                                                  'โทร ${patientInfo?['phone']}'),
                                              Text(
                                                  'โรคประจำตัว ${patientInfo?['chronic']}'),
                                              Text(
                                                  'ประวัติการแพ้ ${patientInfo?['allergicHistory']}'),
                                              Text(
                                                  'ประวัติโรคเลือด ${patientInfo?['bloodDisease_history']}'),
                                              Text(
                                                  'ประวัติการผ่าตัด ${patientInfo?['surgery_history']}'),
                                              Text(
                                                  'สิทธิ์รักษา ${patientInfo?['claim']}'),
                                            ],
                                          );
                                        }
                                      }),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection(
                                              '/patients/${patientID}/appointments')
                                          .doc('${appointmentID}')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text('no data');
                                        } else {
                                          var appointmentInfo =
                                              snapshot.data!.data();
                                          return ListView(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            children: [
                                              Text(
                                                  'มีอาการ ${appointmentInfo!['symptoms']}'),
                                              Text(
                                                  'มีอาการระดับ ${appointmentInfo!['symptomSeverity']}'),
                                              Text(
                                                  'มี ${appointmentInfo['symptomTriggers']} เป็นตัวกระตุ้น'),
                                              (appointmentInfo[
                                                      'isCloseContact'])
                                                  ? Text('เคยใกล้ชิดผู้ป่วย')
                                                  : Text(
                                                      'ไม่เคยใกล้ชิดผู้ป่วย'),
                                              (appointmentInfo[
                                                      'isFamilyMemberExperienced'])
                                                  ? Text(
                                                      'มีประวัติทางพันธุกรรม')
                                                  : Text(
                                                      'ไม่มีประวัติทางพันธุกรรม'),
                                              Text(
                                                  'เพิ่มเติม ${appointmentInfo['additionalNote']}'),
                                            ],
                                          );
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                },
                icon: Icon(Icons.info))
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: _client,
                showNumberOfUsers: true,
                layoutType: Layout.grid,
              ),
              AgoraVideoButtons(client: _client)
            ],
          ),
        ),
      ),
    );
  }
}

String _getMonth(int month) {
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
