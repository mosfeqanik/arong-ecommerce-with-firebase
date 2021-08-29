import 'package:arong/const/appcolors.dart';
import 'package:arong/ui/Bottom_Nav_Bar/favourites.dart';
import 'package:arong/ui/Bottom_Nav_Bar/homescreen.dart';
import 'package:arong/ui/Bottom_Nav_Bar/profilenupdate.dart';
import 'package:arong/widgets/share_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Bottom_Nav_Bar/cart.dart';

class BottomNavController extends StatefulWidget {
  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    HomeScreen(),
    FavouriteScreen(),
    MyCartScreen(),
    UserUpdateForm()
  ];
  int _currentIndex = 0;

  void setPref() async {
    await Prefs.loadPref();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.deep_green,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outlined),
              label: "Home",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Home",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Home",
              backgroundColor: Colors.white)
        ],
        showSelectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
