import 'dart:convert';

import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    print(userProvider.getUser.token);
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.getUser.token!
      });
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (var product in jsonDecode(res.body)) {
              productList.add(Product.fromMap(product));
            }
          });
    } catch (e) {
      print(e);
      showSnackBar(context, Colors.red, e.toString());
    }
    return productList;
  }


  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(category: '', description: '', images: [], price: 0.0, name: '', quantity: 0.0);
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.getUser.token!
      });
      print('res.body==================');
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            product = Product.fromMap(jsonDecode(res.body));
          });
    } catch (e) {
      print(e);
      showSnackBar(context, Colors.red, e.toString());
    }
    return product;
  }
}
