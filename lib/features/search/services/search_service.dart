import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';

class SearchService {
  Future<List<Product>> fetchSearchedProduct({
    required String searchQuery,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products/search/$searchQuery'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.getUser.token!
      });
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (var product in jsonDecode(res.body)) {
              productList.add(Product.fromMap(product));
            }
          });
      print(productList);
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
    return productList;
  }
}
