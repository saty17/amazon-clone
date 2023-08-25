import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/starts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';
import '../../search/screens/search_screen.dart';
import '../services/product_details_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String routeName = '/product-details';
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductDetailsServices productDetailsServices = ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double totalRating = 0;
    for (int i = 0; i < widget.product.ratings!.length; i++) {
      if (widget.product.ratings![i].rating != null) {
        totalRating += widget.product.ratings![i].rating!.toDouble();
      }
      if (widget.product.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).getUser.id) {
        myRating = widget.product.ratings![i].rating!.toDouble();
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.ratings!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart(){
    productDetailsServices.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    height: 42,
                    margin: const EdgeInsets.only(left: 15),
                    child: Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        onFieldSubmitted: (text) {
                          navigateToSearchScreen(text);
                        },
                        decoration: InputDecoration(
                            prefixIcon: InkWell(
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                    left: 6,
                                  ),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 23,
                                  ),
                                )),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 10),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(7),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.black38, width: 1),
                            ),
                            hintText: 'Search Amazon.in',
                            hintStyle: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    )),
              ),
              Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.black,
                    size: 25,
                  ))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id!),
                  Stars(rating: avgRating),
                ],
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  widget.product.name!,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                )),
            CarouselSlider(
                items: widget.product.images!.map((i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(viewportFraction: 1, height: 300)),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                      text: 'Deal Price: ',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: '\₹${widget.product.price!}',
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.product.description!),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(text: 'Buy Now', onTap: () {}),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                  text: 'Add to Cart',
                  color: const Color.fromRGBO(245, 216, 19, 1),
                  onTap: addToCart),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Rate The Product',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.secondaryColor,
              ),
              onRatingUpdate: (rating) {
                productDetailsServices.rateProduct(
                    context: context, rating: rating, product: widget.product);
              },
            )
          ],
        ),
      ),
    );
  }
}
