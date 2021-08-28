import 'package:arong/const/appcolors.dart';
import 'package:arong/widgets/custom_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProductDetailScreen extends StatefulWidget {
  var _products;

  ProductDetailScreen(this._products);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Future addToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-cart-items");
    return _collectionRef
        .doc(currentUser.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._products["product_name"],
      "price": widget._products["product_price"],
      "images": widget._products["product_img"],
    }).then((value) => CustomToast.toast('Added to Cart'));
  }

  Future checkOutNow() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-checkout-items");
    return _collectionRef
        .doc(currentUser.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._products["product_name"],
      "price": widget._products["product_price"],
      "images": widget._products["product_img"],
    }).then((value) => CustomToast.toast('Added to Checkout'));
  }

  Future addToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("users-favourite-items");
    return _collectionRef
        .doc(currentUser.email)
        .collection("items")
        .doc()
        .set({
      "name": widget._products["product_name"],
      "price": widget._products["product_price"],
      "images": widget._products["product_img"],
    }).then((value) => CustomToast.toast('Added to favourite'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  height: 300.0,
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: AspectRatio(
                      aspectRatio: 19 / 9,
                      child: CarouselSlider(
                        items: widget._products['product_img']
                            .map<Widget>(
                              (item) =>
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(item),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                        )
                            .toList(),
                        options: CarouselOptions(
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 30.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Icon(
                              Icons.search,
                              color: AppColors.deep_green,
                              size: 30.0,
                            ),
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users-favourite-items")
                                .doc(FirebaseAuth.instance.currentUser.email)
                                .collection("items")
                                .where("name",
                                isEqualTo: widget._products['product_name'])
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return Text("");
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: IconButton(
                                  onPressed: () =>
                                  snapshot
                                      .data.docs.length ==
                                      0
                                      ? addToFavourite()
                                      : CustomToast.toast('Already Added'),
                                  icon: snapshot.data.docs.length == 0
                                      ? Icon(
                                    Icons.favorite_outline,
                                    color: AppColors.deep_green,
                                  )
                                      : Icon(
                                    Icons.favorite,
                                    color: AppColors.deep_green,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                widget._products['product_name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  letterSpacing: 1.8,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                "Price: " + widget._products['product_price'].toString() +
                    "\$ ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: Colors.red,
                  letterSpacing: 1.8,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Product Description',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Text(
                widget._products['product_description'],
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black38,
                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50.0,
                  width: 220.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.deep_green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 20.0,
                        )
                      ]),
                  child: Center(
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users-cart-items")
                      .doc(FirebaseAuth.instance.currentUser.email)
                      .collection("items")
                      .where("name",
                      isEqualTo: widget._products['product_name'])
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Text("");
                    }
                    return InkWell(
                      onTap: () =>
                      snapshot.data.docs.length == 0
                          ? addToCart()
                          : CustomToast.toast('Already Added'),
                      child: Container(
                        height: 50.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.deep_green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 2),
                                blurRadius: 20.0,
                              )
                            ]),
                        child: Center(
                            child: snapshot.data.docs.length == 0
                                ? Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 30.0,
                            )
                                : Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 30.0,
                            )),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }
}
