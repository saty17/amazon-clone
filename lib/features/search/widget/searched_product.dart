import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/starts.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;

  const SearchedProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    double totalRating = 0;

    for (int i = 0; i < product.ratings!.length; i++) {
      if (product.ratings![i].rating != null) {
        totalRating += product.ratings![i].rating!.toDouble();
      }
    }

    double avgRating = 0;
    if (totalRating != 0) {
      avgRating = totalRating / product.ratings!.length;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      // width: MediaQuery.of(context).size.width - 20,
      child: Row(
        children: [
          Image.network(
            product.images![0],
            fit: BoxFit.fitHeight,
            height: 135,
            width: 135,
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
              // width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.name!,
                style: const TextStyle(fontSize: 16),
                maxLines: 2,
              ),
            ),
            Container(
              // width: 200,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Stars(rating: avgRating),
            ),
            Container(
              // width: 200,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                '\₹${product.price}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
            Container(
              // width: 200,
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                'Eligible for FREE shipping',
                maxLines: 2,),
              ),
            Container(
              // width: 200,
              padding: const EdgeInsets.only(left: 10),
              child: const Text(
                'In Stock',
                style: TextStyle(color: Colors.teal),
                maxLines: 2,
              ),
            ),
          ])
        ],
      ),
    );
  }
}
