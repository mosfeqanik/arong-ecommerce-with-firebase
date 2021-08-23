import 'package:arong/const/appcolors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _carouselImages = [];
  List _products = [];
  var _dotPosition = 0;
  TextEditingController _searchController = TextEditingController();
  var _fireStoreInstance = FirebaseFirestore.instance;

  fetchCarouselImage() async {
    QuerySnapshot carouselCollection =
        await _fireStoreInstance.collection("carousel_slider").get();
    setState(() {
      for (int i = 0; i < carouselCollection.docs.length; i++) {
        _carouselImages.add(carouselCollection.docs[i]["img_path"]);
      }
    });
    return carouselCollection.docs;
  }

  fetchProduct() async {
    QuerySnapshot productCollection =
        await _fireStoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < productCollection.docs.length; i++) {
        _products.add({
          "product_name": productCollection.docs[i]["product_name"],
          "product_img": productCollection.docs[i]["product_img"],
          "product_description": productCollection.docs[i]
              ["product_description"],
          "product_price": productCollection.docs[i]["product_price"],

        });
        print(productCollection.docs[i]["product_price"]);
      }
    });
    return productCollection.docs;
  }

  @override
  void initState() {
    fetchProduct();
    fetchCarouselImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                      child: TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: "Search Products here",
                            hintStyle: TextStyle(fontSize: 15.sp)),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.h,
                    width: 50.h,
                    color: AppColors.deep_green,
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 19 / 9,
              child: CarouselSlider(
                items: _carouselImages
                    .map(
                      (item) => Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(item),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    onPageChanged: (val, carouselPageChangedReason) {
                      setState(() {
                        _dotPosition = val;
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            DotsIndicator(
              dotsCount:
                  _carouselImages.length == 0 ? 1 : _carouselImages.length,
              position: _dotPosition.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColors.deep_green,
                color: AppColors.deep_green.withOpacity(.5),
                spacing: EdgeInsets.all(2),
                activeSize: Size(8, 8),
                size: Size(6, 6),
              ),
            ),
            Expanded(
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: ()=>(){},
                      child: Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            AspectRatio(
                                aspectRatio: 3/2,
                                child: Container(
                                    child: Image.network(
                                      _products[index]["product_img"][0],
                                      fit: BoxFit.fitHeight,
                                      loadingBuilder: (context,child,progress){
                                        return progress ==null ?child: LinearProgressIndicator(
                                            minHeight: .2,
                                            backgroundColor: Colors.white,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent));
                                      },
                                    ))),
                            Text("${_products[index]["product_name"]}"),
                            Text(
                                "${_products[index]["product_price"].toString()}"),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
