import 'package:arong/const/appcolors.dart';
import 'package:arong/ui/login.dart';
import 'package:arong/widgets/custom_toast.dart';
import 'package:arong/widgets/share_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserUpdateForm extends StatefulWidget {
  @override
  _UserUpdateFormState createState() => _UserUpdateFormState();
}

class _UserUpdateFormState extends State<UserUpdateForm> {
  bool _isEditButtonClicked = false;
  TextEditingController _nameEditController = TextEditingController();
  TextEditingController _phoneNumberEditController = TextEditingController();
  TextEditingController _addressEditController = TextEditingController();

  setDataToTextField(data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            enabled: _isEditButtonClicked,
            controller: _nameEditController =
                TextEditingController(text: data['name']),
          ),
        ),
        Text(
          "Phone Number",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            enabled: _isEditButtonClicked,
            controller: _phoneNumberEditController =
                TextEditingController(text: data['phone']),
          ),
        ),
        Text(
          "Contact Address",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            enabled: _isEditButtonClicked,
            controller: _addressEditController =
                TextEditingController(text: data['address']),
          ),
        ),

      ],
    );
  }

  updateUserDetail() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser.email).update({
      "name": _nameEditController.text,
      "phone": _phoneNumberEditController.text,
      "address": _addressEditController.text,
    }).then((value) => CustomToast.toast('Updated Successfully'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "E-Commerce",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_outlined,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () {
              Prefs.clearPref();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                      (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    _isEditButtonClicked?"Update Your Information":"Your information ",
                    style:
                        TextStyle(fontSize: 22.sp, color: AppColors.deep_green),
                  ),
                  Row(
                    children: [
                      Text(
                        "We will not share your information with anyone.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditButtonClicked = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users-form-data")
                        .doc(FirebaseAuth.instance.currentUser.email)
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
                  _isEditButtonClicked?SizedBox(
                    width: 1.sw,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        updateUserDetail();
                        _isEditButtonClicked = false;
                      },
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.deep_green,
                        elevation: 3,
                      ),
                    ),

                  ):Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
