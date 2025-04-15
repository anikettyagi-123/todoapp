
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String Gernal_mobile_no = "";

// storing mobile no. once user verified
void Store_MobileNo_database() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('user_gernal_mobile_no');

    users
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        users.doc(user.uid).update({
          'mobileNumber': Gernal_mobile_no,
        });
      } else {
        users.doc(user.uid).set({"mobileNumber": Gernal_mobile_no});
      }
    })
        .then((_) {})
        .catchError((error) {});
  }
}
void deleteMobileNumber() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      CollectionReference users =
      FirebaseFirestore.instance.collection('user_gernal_mobile_no');

      DocumentSnapshot documentSnapshot = await users.doc(user.uid).get();

      if (documentSnapshot.exists) {
        await users.doc(user.uid).delete();
      }
    }
  } catch (error) {
    // print('Error deleting mobile number from Firestore: $error');
  }
}
