
import 'package:arong/const/appcolors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bottom_nav_bar.dart';

class UserAddForm extends StatefulWidget {
  @override
  _UserAddFormState createState() => _UserAddFormState();
}

class _UserAddFormState extends State<UserAddForm> {
  TextEditingController _nameEditController = TextEditingController();
  TextEditingController _phoneNumberEditController = TextEditingController();
  TextEditingController _dobEditController = TextEditingController();
  TextEditingController _genderEditController= TextEditingController();
  TextEditingController _AddressEditController = TextEditingController();

  List<String> gender=["Male","Female","Others"];

  Future<void> _selectDateFromPicker(BuildContext context)async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobEditController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB()async{

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;

    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(currentUser.email).set({
      "name":_nameEditController.text,
      "phone":_phoneNumberEditController.text,
      "dob":_dobEditController.text,
      "gender":_genderEditController.text,
      "address":_AddressEditController.text,
    }).then((value) => Navigator.push(context, MaterialPageRoute(builder: (_)=>BottomNavController()))).catchError((error)=>print("something is wrong. $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Submit The Form to Continue.",
                    style:
                        TextStyle(fontSize: 22.sp, color: AppColors.deep_green),
                  ),
                  Text(
                    "We will not share your information with anyone.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _nameEditController,
                    decoration: InputDecoration(hintText: "Enter Your Name"),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberEditController,
                    decoration: InputDecoration(hintText: "Enter Your Phone Number"),
                  ),
                  TextField(
                    controller: _dobEditController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Date of Birth",
                      suffixIcon: IconButton(
                        onPressed: () {
                          _selectDateFromPicker(context);
                        },
                        icon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _genderEditController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "choose your gender",
                      prefixIcon: DropdownButton<String>(
                        items: gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                            onTap: () {
                              setState(() {
                                _genderEditController.text = value;
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.streetAddress,
                    controller: _AddressEditController,
                    decoration: InputDecoration(hintText: "Enter Your Contact address"),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  SizedBox(
                    width: 1.sw,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        sendUserDataToDB();
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.deep_green,
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
