import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/HomePageScreens/AllRecord.dart';
import 'package:goglucose/HomePageScreens/AllTime.dart';
import 'package:goglucose/HomePageScreens/ThisWeek.dart';
import 'package:goglucose/HomePageScreens/TodayChart.dart';
import 'package:goglucose/backgroundConstants.dart';

class AllGraphs extends StatefulWidget {
  final User user;
  const AllGraphs({Key? key, required this.user}) : super(key: key);

  @override
  State<AllGraphs> createState() => _AllGraphsState();
}

class _AllGraphsState extends State<AllGraphs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 35),
            Container(
              child: Text(
                "This Year: ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.all(10),
            ),
            Container(
              child: AllTimeChart(
                user: widget.user,
              ),
              margin: EdgeInsets.only(left: 16, right: 15),
            ),
            SizedBox(height: 25),
            Container(
              child: Text(
                "This Week: ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.all(10),
            ),
            Container(
              child: ThisWeekChart(
                user: widget.user,
              ),
              margin: EdgeInsets.only(left: 16, right: 15),
            ),
            SizedBox(height: 25),
            Container(
              child: Text(
                "Today's Readings: ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.all(10),
            ),
            Container(
              child: TodayChart(
                user: widget.user,
              ),
              margin: EdgeInsets.only(left: 16, right: 15),
            ),
            SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}
