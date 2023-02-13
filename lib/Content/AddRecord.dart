import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/FirebaseFlutter.dart';
import 'package:goglucose/GradientText.dart';
import 'package:goglucose/backgroundConstants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';

class AddGlucoseRecordPage extends StatefulWidget {
  final User user;
  const AddGlucoseRecordPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddGlucoseRecordPage> createState() => _AddGlucoseRecordPageState();
}

class _AddGlucoseRecordPageState extends State<AddGlucoseRecordPage> {
  String recordName = "";
  late int glucoseLevel;
  String physicalActivities = "";
  String mealsOrCalories = "";
  String additionalNotes = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: new GradientText("Add a Glucose Record",
                style: const TextStyle(fontSize: 20),
                gradient: LinearGradient(colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade900,
                ])),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              new Container(
                color: kBackgroundColor,
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Text(
                          "Record your Glucose",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          child: SizedBox(
                            height: 50,
                            width: 525,
                            child: Material(
                              elevation: 8,
                              shadowColor: Colors.black87,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    recordName = val;
                                  });
                                },
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  labelText: "Name for glucose reading",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Glucose Reading for " +
                                      DateFormat.yMMMd().format(DateTime.now()),
                                  prefixIcon: Icon(Ionicons.book_outline),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          child: SizedBox(
                            height: 50,
                            width: 525,
                            child: Material(
                              elevation: 8,
                              shadowColor: Colors.black87,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    glucoseLevel = int.parse(val);
                                  });
                                },
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  labelText: "Glucose level in mg/dL",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: "Ex. 98 mg/dL",
                                  prefixIcon: Icon(Ionicons.analytics_outline),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Text(
                          "Other info",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 8,
                            shadowColor: Colors.black87,
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  physicalActivities = val;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "Any Physical Activities",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Ran a mile, swam, etc.",
                                prefixIcon: Icon(Ionicons.fitness_outline),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 8,
                            shadowColor: Colors.black87,
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  mealsOrCalories = val;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "Any Meals or Calorie intakes",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "200 Calories consumed, etc.",
                                prefixIcon: Icon(Ionicons.fast_food_outline),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 8),
                          child: Material(
                            borderRadius: BorderRadius.circular(30),
                            elevation: 8,
                            shadowColor: Colors.black87,
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  additionalNotes = value;
                                });
                              },
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: "Other Notes",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon:
                                    const Icon(Ionicons.alert_circle_outline),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 35.0),
                        ElevatedButton(
                          onPressed: () async {
                            await addGlucoseRecord(
                                recordName,
                                glucoseLevel,
                                physicalActivities,
                                mealsOrCalories,
                                additionalNotes,
                                widget.user.uid);

                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(246, 112, 98, 0.8),
                                  Color.fromRGBO(252, 82, 150, 0.8)
                                ]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              width: 200,
                              height: 60,
                              alignment: Alignment.center,
                              child: const Text(
                                'Add Glucose Record',
                                style: const TextStyle(
                                    fontSize: 18, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
