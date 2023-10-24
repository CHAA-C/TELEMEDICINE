import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MakeLabAP extends StatefulWidget {
  const MakeLabAP({super.key});

  @override
  State<MakeLabAP> createState() => _MakeLabAPState();
}

TextStyle _listStyle = TextStyle(color: Color(0xff373b44));

TextStyle _Bullet = TextStyle(
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  fontSize: 15,
);

class _MakeLabAPState extends State<MakeLabAP> {
  String patientID = "user001";
  String doctorName = "นพ.เจษฎา พันธวาศิษฏ์";
  String appointmentID = 'ap002';


  List thalassemia_screening = [
    "Dichlorophenol-indophenol precipitation test (DCIP)*",
    "One tube osmotic fragility (OF)*",
    "Inclusion bodies staining*",
    "Hb typing (RBC parameter + Hb typing)*"
  ];
  List thalassemia_screening_value = [
    false,
    false,
    false,
    false,
  ];

  List DNA_analysisforThalassemias = [
    "PCR for -thal 1 (SEA and THAI deletion)*",
    "PCR for -thal 1 (5-deletion)*",
    "Thalassemia profile 2 [PCR for -thal]*",
    "PCR for -thal 2*",
    "Multiplex PCR for β-thalassemia*",
    "PCR for β-globin deletion (9 types)",
    "Multiplex PCR for abnormal Hb (10 types)",
    "Beta-globin gene sequencing (2.0 Kb)",
    "Alpha-globin gene sequencing (1.6 Kb)"
  ];

  List DNA_analysisforThalassemias_value = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List DNA_analysisforCoagulation = [
    "Prothrombin mutation (FII20210G>A)",
    "FactorV Leiden mutation (FV1691G>A)"
  ];

  List DNA_analysisforCoagulation_value = [
    false,
    false,
  ];
  List G_6_PDDeficiency = [
    "Heinz bodies staining*",
    "G6PD Screening (FST)*",
    "G6PD Quantitative",
    "DNA analysis for G6PD (10 mutations)",
    "G6PD gene sequencing (13 Exon)",
    "Plasma free hemoglobin level",
    "vWF multimer assay"
  ];
  List G_6_PDDeficiency_value = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sukhumvit",
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "สั่งตรวจแลป",
            style: TextStyle(
              color: Color.fromARGB(255, 80, 89, 100).withOpacity(1.0),
              fontSize: 40,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
ExpansionTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  "Thalassemia screening",
                  style: _Bullet,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                collapsedBackgroundColor: Color(0xff75c0c3),
                backgroundColor: Color(0xffe9f1fe),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: thalassemia_screening.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Checkbox(
                            value: thalassemia_screening_value[index],
                            onChanged: (value) {
                              setState(() {
                                setState(() {
                                  thalassemia_screening_value[index] = value;
                                });
                              });
                            },
                          ),
                          title: Text(
                            thalassemia_screening[index],
                            style: _listStyle,
                          ),
                        );
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  "DNA analysis for Thalassemias and Hemoglobinopathies",
                  style: _Bullet,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                collapsedBackgroundColor: Color(0xff75c0c3),
                backgroundColor: Color(0xffe9f1fe),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: DNA_analysisforThalassemias.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Checkbox(
                            value: DNA_analysisforThalassemias_value[index],
                            onChanged: (value) {
                              setState(() {
                                setState(() {
                                  DNA_analysisforThalassemias_value[index] =
                                      value;
                                });
                              });
                            },
                          ),
                          title: Text(DNA_analysisforThalassemias[index]),
                        );
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  "DNA analysis for Coagulation factors",
                  style: _Bullet,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                collapsedBackgroundColor: Color(0xff75c0c3),
                backgroundColor: Color(0xffe9f1fe),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: DNA_analysisforCoagulation.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Checkbox(
                            value: DNA_analysisforCoagulation_value[index],
                            onChanged: (value) {
                              setState(() {
                                setState(() {
                                  DNA_analysisforCoagulation_value[index] =
                                      value;
                                });
                              });
                            },
                          ),
                          title: Text(DNA_analysisforCoagulation[index]),
                        );
                      }),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ExpansionTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: Text(
                  "G-6-PD Deficiency",
                  style: _Bullet,
                ),
                controlAffinity: ListTileControlAffinity.leading,
                collapsedBackgroundColor: Color(0xff75c0c3),
                backgroundColor: Color(0xffe9f1fe),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: G_6_PDDeficiency.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Checkbox(
                            value: G_6_PDDeficiency_value[index],
                            onChanged: (value) {
                              setState(() {
                                setState(() {
                                  G_6_PDDeficiency_value[index] = value;
                                });
                              });
                            },
                          ),
                          title: Text(G_6_PDDeficiency[index]),
                        );
                      })
                ],
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          makeLab();
        }),
      ),
    );
  }

  makeLab() {
    List lis1 = [];
    List lis2 = [];
    List lis3 = [];
    List lis4 = [];
    for (var i = 0; i < thalassemia_screening.length; i++) {
      if (thalassemia_screening_value[i] == true) {
        lis1.add(thalassemia_screening[i]);
      }
    }
    for (var i = 0; i < DNA_analysisforThalassemias.length; i++) {
      if (DNA_analysisforThalassemias_value[i] == true) {
        lis2.add(DNA_analysisforThalassemias[i]);
      }
    }
    for (var i = 0; i < DNA_analysisforCoagulation.length; i++) {
      if (DNA_analysisforCoagulation_value[i] == true) {
        lis3.add(DNA_analysisforCoagulation[i]);
      }
    }
    for (var i = 0; i < G_6_PDDeficiency.length; i++) {
      if (G_6_PDDeficiency_value[i] == true) {
        lis4.add(G_6_PDDeficiency[i]);
      }
    }
    print(lis1);
    print(lis2);
    print(lis3);
    print(lis4);
    var db = FirebaseFirestore.instance;
    final labAP = {
      "thalassemia_screening": lis1,
      "DNA_analysisforThalassemias": lis2,
      "DNA_analysisforCoagulation": lis3,
      "G_6_PDDeficiency": lis4,
      "doctorName": doctorName,
    };

    db
        .collection("/patients/${patientID}/appointments")
        .doc("${appointmentID}")
        .collection("LabAppointment")
        .doc()
        .set(labAP)
        .onError((e, _) => print("Error writing document: $e"));

    db
        .collection("/patients/${patientID}/appointments")
        .doc("${appointmentID}")
        .update({"labState": "waiting_patient"}).then(
            (value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"));
  }
}
