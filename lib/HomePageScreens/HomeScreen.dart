import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/HomePageScreens/AddRecord.dart';
import 'package:goglucose/HomePageScreens/AllGraphs.dart';
import 'package:goglucose/HomePageScreens/AllRecord.dart';
import 'package:goglucose/HomePageScreens/AllTime.dart';
import 'package:goglucose/HomePageScreens/ViewYearlyTrend.dart';
import 'package:goglucose/GradientText.dart';
import 'package:goglucose/backgroundConstants.dart';
import 'package:ionicons/ionicons.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  late Stream<QuerySnapshot> glucoseRecordStream =
      FirebaseFirestore.instance.collection(widget.user.uid).snapshots();

  bool? NADocexists;

  @override
  void initState() {
    super.initState();
    var document =
        FirebaseFirestore.instance.collection('Users').doc(widget.user.uid);
    document.get().then((DocumentSnapshot doc) {
      final data = doc.data()! as Map<String, dynamic>;
      setState(() {
        name = data["name"];
      });
    });
    checkifNAExists();
  }

  checkifNAExists() async {
    var a = await FirebaseFirestore.instance
        .collection(widget.user.uid)
        .doc("NA")
        .get();
    if (a.exists) {
      // print('Exists');
      setState(() {
        NADocexists = true;
      });
    } else if (!a.exists) {
      // print('Not exists');
      setState(() {
        NADocexists = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    singleCard(iconName, actionName) {
      return SizedBox(
        height: 40,
        child: Card(
          color: kSecondaryColor,
          semanticContainer: true,
          child: InkWell(
            onTap: () {
              if (iconName == 0xf068b) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllGraphs(user: widget.user)));
              } else if (iconName == 0xe305) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddGlucoseRecordPage(user: widget.user)));
              } else if (iconName == 0xf2ff) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllRecords(
                              user: widget.user,
                            )));
              } else if (iconName == 0xe083) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => YearlyTrend(
                              user: widget.user,
                            )));
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(IconData(iconName, fontFamily: "MaterialIcons"),
                    color: Colors.black, size: 35.0),
                Text(
                  actionName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: glucoseRecordStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong. Please try again late."),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading..."));
            } else if (snapshot.data!.docs.length == 1 && NADocexists == true) {
              return Stack(
                children: [
                  Container(
                      decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 244, 133, 21),
                      Color.fromARGB(255, 255, 238, 0)
                    ],
                  ))),
                  Column(
                    children: [
                      SizedBox(height: 35.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 15.0,
                          ),
                          GradientText(
                            'Welcome Back, \n$name',
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(218, 210, 243, 0.8),
                              Color.fromRGBO(251, 168, 164, 0.8)
                            ]),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10),
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(15),
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.height * 0.8,
                          child: Image.asset(
                              "assets/images/go-glucose-high-resolution-color-logo.png"),
                        ),
                      ),
                      Center(
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          color: const Color(0xff020227),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 90),
                            child: Center(
                              child: Text(
                                "Add a glucose record to get started!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  Container(
                      decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 244, 133, 21),
                      Color.fromARGB(255, 255, 238, 0)
                    ],
                  ))),
                  Column(
                    children: [
                      SizedBox(height: 35.0),
                      Row(
                        children: [
                          SizedBox(
                            width: 15.0,
                          ),
                          GradientText(
                            'Welcome Back, \n$name',
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(218, 210, 243, 0.8),
                              Color.fromRGBO(251, 168, 164, 0.8)
                            ]),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        height: MediaQuery.of(context).size.height * 0.22,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Image.asset(
                            "assets/images/go-glucose-high-resolution-color-logo.png"),
                      ),
                      SizedBox(height: 7.5),
                      GridView.count(
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: [
                          singleCard(0xf068b, "View Graphs"),
                          singleCard(0xe305, "Add Record"),
                          singleCard(0xf2ff, "View Records"),
                          singleCard(0xe083, "View Trends"),
                        ],
                      )
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }
}
