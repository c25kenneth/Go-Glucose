import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goglucose/HomePageScreens/RecordDetail.dart';
import 'package:goglucose/GradientText.dart';
import 'package:goglucose/backgroundConstants.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class AllRecords extends StatefulWidget {
  final User user;
  const AllRecords({Key? key, required this.user}) : super(key: key);

  @override
  State<AllRecords> createState() => _AllRecordsState();
}

class _AllRecordsState extends State<AllRecords> {
  late List docs = [];

  List _foundUsers = [];

  @override
  void initState() {
    super.initState();
    getDocs().then((documents) => {
          setState(() {
            docs = documents;
            _foundUsers = documents;
          })
        });
  }

  Future<List> getDocs() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(widget.user.uid)
        .orderBy("createdOn", descending: false)
        .get();
    final List documents = result.docs;
    return documents;
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      setState(() {
        _foundUsers = docs;
      });
    } else {
      setState(() {
        _foundUsers = docs
            .where((user) => user["recordName"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
      });
      // we use the toLowerCase() method to make it case-insensitive
    }
  }

  @override
  Widget build(BuildContext context) {
    makeCard(String recordName, String dateCreated, dynamic document) {
      return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
            decoration: BoxDecoration(color: Color.fromARGB(228, 241, 143, 37)),
            child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecordDetailScreen(
                                document: document,
                                user: widget.user,
                              )));
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Icon(Icons.calendar_month, color: Colors.white),
                ),
                title: Text(
                  recordName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    Text(dateCreated, style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0))),
      );
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: new GradientText("Your Records",
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25.0,
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
                              onChanged: (value) => _runFilter(value),
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                labelText: "Search...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Search by record name ",
                                prefixIcon: Icon(Ionicons.search),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "All Records: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: _foundUsers.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: makeCard(
                                    _foundUsers[index]["recordName"],
                                    DateFormat.yMEd().add_jms().format(
                                        _foundUsers[index]["createdOn"]
                                            .toDate()),
                                    _foundUsers[index]),
                              );
                            }),
                      )
                    ],
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
