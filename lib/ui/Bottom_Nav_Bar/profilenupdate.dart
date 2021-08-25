import 'package:arong/widgets/custom_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? _nameEditingController;
  TextEditingController? _phoneNumberEditingController;
  TextEditingController? _ageEditingController;

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          controller: _nameEditingController =
              TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _phoneNumberEditingController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _ageEditingController =
              TextEditingController(text: data['age']),
        ),
        ElevatedButton(
            onPressed: () => updateUserDetail(), child: Text("Update"))
      ],
    );
  }

  updateUserDetail() {
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update(
        {
          "name":_nameEditingController!.text,
          "phone":_phoneNumberEditingController!.text,
          "age":_ageEditingController!.text,
        }
    ).then((value) => CustomToast.toast('Updated Successfully'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-form-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              if (data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return setDataToTextField(data);
            },
          ),
        )),
      ),
    );
  }
}
