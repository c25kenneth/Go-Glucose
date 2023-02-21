import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/HomePageScreens/AllTime.dart';
import 'package:goglucose/HomePageScreens/ThisWeek.dart';
import 'dart:math';

import 'package:goglucose/HomePageScreens/TodayChart.dart';

class YearlyTrend extends StatefulWidget {
  final User user;
  const YearlyTrend({Key? key, required this.user}) : super(key: key);

  @override
  State<YearlyTrend> createState() => _YearlyTrendState();
}

class _YearlyTrendState extends State<YearlyTrend> {
  List allGlucoseLevels = [];
  List weeklyGlucoseLevels = [];
  List todayGlucoseLevels = [];
  String isTrendIncreasing = " ";

  DateTime getStartTimeWeek([DateTime? date]) {
    final currentDate = date ?? DateTime.now();
    final dateTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    return dateTime.subtract(Duration(days: currentDate.weekday - 1));
  }

  @override
  void initState() {
    super.initState();

    getYearlyData().then((value) {
      value.forEach((doc) {
        setState(() {
          allGlucoseLevels.add(doc["glucoseLevel"]);
        });
      });
    });

    getWeeklyDocs().then((value) {
      value.forEach((doc) {
        setState(() {
          weeklyGlucoseLevels.add(doc["glucoseLevel"]);
        });
      });
    });

    getDailyDoc().then((value) {
      value.forEach((doc) {
        setState(() {
          todayGlucoseLevels.add(doc["glucoseLevel"]);
        });
      });
    });
  }

  Future<List> getYearlyData() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(widget.user.uid)
        .where("createdOn",
            isGreaterThan: Timestamp.fromDate(
                DateTime(DateTime.now().year - 1, 12, 31, 23, 59, 999, 999999)))
        .orderBy("createdOn", descending: false)
        .get();
    final List documents = result.docs;
    return documents;
  }

  Future<List> getDailyDoc() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(widget.user.uid)
        .orderBy("createdOn", descending: false)
        .where("createdOn",
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)))
        .where("createdOn",
            isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .get();
    final List documents = result.docs;
    return documents;
  }

  Future<List> getWeeklyDocs() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(widget.user.uid)
        .orderBy("createdOn", descending: false)
        .where("createdOn",
            isGreaterThan: Timestamp.fromDate(getStartTimeWeek()))
        .get();
    final List documents = result.docs;
    return documents;
  }

  String getTrend(List glucoseLevels) {
    try {
      // double sum = (glucoseLevels.reduce((a, b) => a + b)).toDouble();
      // double mean = (sum / glucoseLevels.length).toDouble();
      // double variance =
      //     (glucoseLevels.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) /
      //             (glucoseLevels.length - 1))
      //         .toDouble();
      // double stdDev = (sqrt(variance)).toDouble();
      // double slope = (stdDev / mean).toDouble();
      double slope =
          (glucoseLevels.last - glucoseLevels.first) / (glucoseLevels.length);

      if (slope > 0.0) {
        setState(() {
          isTrendIncreasing = "There is an increasing trend in glucose";
        });
        return isTrendIncreasing;
      } else if (slope < 0.0) {
        setState(() {
          isTrendIncreasing = "There is a decreasing trend in glucose";
        });
        return isTrendIncreasing;
      } else {
        setState(() {
          isTrendIncreasing = "There appears to be no visible trend in data";
        });
        return isTrendIncreasing;
      }
    } catch (e) {
      print(e);
      setState(() {
        isTrendIncreasing = "There appears to be no glucose data!";
      });
      return isTrendIncreasing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View your Glucose Trend")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35.0),
            Center(child: AllTimeChart(user: widget.user)),
            Center(
              child: Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  getTrend(allGlucoseLevels),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            Center(
              child: ThisWeekChart(user: widget.user),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  getTrend(weeklyGlucoseLevels),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: TodayChart(user: widget.user),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(5),
                child: Text(
                  getTrend(todayGlucoseLevels),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.0,
            )
          ],
        ),
      ),
    );
  }
}
