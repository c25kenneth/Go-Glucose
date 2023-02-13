import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
final db = FirebaseFirestore.instance;
// Future<void> registerUser(String name, String email, String password) async {
//   try{
//     await _auth.createUserWithEmailAndPassword(email: email, password: password);

//   } on FirebaseAuthException catch (e){}
// }

Future<User?> registerUser(String name, String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    db
        .collection("Users")
        .doc(uid)
        .set({"name": name, "email": email, "password": password, "uid": uid});

    db
        .collection(uid)
        .doc("NA")
        .set({"NA": "Add a glucose record to get started!"});
    return user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> signIn(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? currUser = _auth.currentUser;
    return currUser;
  } catch (e) {
    print(e);
    return null;
  }
}

Future addGlucoseRecord(
    String recordName,
    int glucoseLevel,
    String physicalActivities,
    String mealsOrCalories,
    String additionalNotes,
    String uid) async {
  try {
    CollectionReference glucoseRecords = db.collection(uid);
    QuerySnapshot glucoseCollection =
        await FirebaseFirestore.instance.collection(uid).get();

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection(uid).doc("NA");
    var naDoc = await userDocRef.get();

    if (!naDoc.exists) {
      await glucoseRecords.doc().set({
        "recordName": recordName,
        "glucoseLevel": glucoseLevel,
        "physicalActivities": physicalActivities,
        "mealsOrCalories": mealsOrCalories,
        "additionalNotes": additionalNotes,
        "createdOn": FieldValue.serverTimestamp(),
      });
    } else if (naDoc.exists && glucoseCollection.docs.length == 1) {
      await userDocRef.delete();
      await glucoseRecords.doc().set({
        "recordName": recordName,
        "glucoseLevel": glucoseLevel,
        "physicalActivities": physicalActivities,
        "mealsOrCalories": mealsOrCalories,
        "additionalNotes": additionalNotes,
        "createdOn": FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    print(e);
  }
}
