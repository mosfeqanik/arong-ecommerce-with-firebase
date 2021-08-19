import 'package:arong/const/appcolors.dart';
import 'package:arong/ui/Bottom_Nav_Bar/cart.dart';
import 'package:arong/ui/Bottom_Nav_Bar/favourites.dart';
import 'package:arong/ui/Bottom_Nav_Bar/homescreen.dart';
import 'package:arong/ui/Bottom_Nav_Bar/profile.dart';
import 'package:flutter/material.dart';

class BottomNavController extends StatefulWidget {

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {

  final _pages=[HomeScreen(),FavouriteScreen(),CartScreen(),ProfileScreen()];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "E-Commerce",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Home"),backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined),title: Text("Home"),backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),title: Text("Home"),backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.person),title: Text("Home"),backgroundColor: Colors.white)
        ],
        showSelectedLabels: false,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
