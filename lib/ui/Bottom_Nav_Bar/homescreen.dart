import 'package:arong/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60.h,
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          hintText: "Search Products here",
                          hintStyle: TextStyle(fontSize: 15.sp)
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: 60.h,
                    color: AppColors.deep_green,
                    child: Icon(Icons.search,color: Colors.white,size: 40,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
