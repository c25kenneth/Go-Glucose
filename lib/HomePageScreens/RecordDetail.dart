import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/HomePageScreens/HomeScreen.dart';
import 'package:goglucose/backgroundConstants.dart';
import 'package:ionicons/ionicons.dart';

class RecordDetailScreen extends StatefulWidget {
  final dynamic document;
  final User user;
  const RecordDetailScreen(
      {Key? key, required this.document, required this.user})
      : super(key: key);

  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late int glucoseLev;
  String additionalNotes = "";
  String mealsOrCalories = "";
  String physicalActivities = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      additionalNotes = widget.document["additionalNotes"];
      mealsOrCalories = widget.document["mealsOrCalories"];
      glucoseLev = widget.document["glucoseLevel"];
      physicalActivities = widget.document["physicalActivities"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Text(widget.document["recordName"]),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 35.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              child: SizedBox(
                height: 50,
                width: 525,
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black87,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  child: TextFormField(
                    initialValue: widget.document["glucoseLevel"].toString(),
                    onChanged: (val) {
                      setState(() {
                        glucoseLev = int.parse(val);
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              child: Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 8,
                shadowColor: Colors.black87,
                child: TextFormField(
                  initialValue: widget.document["physicalActivities"],
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
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              child: Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 8,
                shadowColor: Colors.black87,
                child: TextFormField(
                  initialValue: widget.document["mealsOrCalories"],
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
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
              child: Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 8,
                shadowColor: Colors.black87,
                child: TextFormField(
                  initialValue: widget.document["additionalNotes"],
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
                    prefixIcon: const Icon(Ionicons.alert_circle_outline),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(widget.user.uid)
                    .doc(widget.document.reference.id)
                    .update({
                  "glucoseLevel": glucoseLev,
                  "mealsOrCalories": mealsOrCalories,
                  "additionalNotes": additionalNotes,
                  "physicalActivities": physicalActivities,
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Record was successfully updated!"),
                ));
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(132, 250, 176, 0.8),
                      Color.fromRGBO(143, 211, 244, 0.8)
                    ]),
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 200,
                  height: 60,
                  alignment: Alignment.center,
                  child: const Text(
                    'Update Glucose Record',
                    style: const TextStyle(
                        fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(children: <Widget>[
              Expanded(child: Divider()),
              Text("OR"),
              Expanded(child: Divider()),
            ]),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(widget.user.uid)
                    .doc(widget.document.reference.id)
                    .delete();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Record was successfully deleted!"),
                ));
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(user: widget.user)));
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Ink(
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: 200,
                  height: 60,
                  alignment: Alignment.center,
                  child: const Text(
                    'Delete Record',
                    style: const TextStyle(
                        fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }
}
