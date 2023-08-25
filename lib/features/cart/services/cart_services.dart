import 'dart:convert';
import 'dart:ffi';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/utils.dart';

class CartServices {
  void removeFromCart(
      {required BuildContext context, required Product product}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(Uri.parse('$uri/api/remove-from-cart/${product.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.getUser.token!,
          },
          );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print(res.body);
            User user = userProvider.getUser.copyWith(
              cart: jsonDecode(res.body)['cart'],
            );
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }

  void rateProduct(
      {required BuildContext context,
        required double rating,
        required Product product}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/rate-product'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.getUser.token!,
          },
          body: jsonEncode({'id': product.id, 'rating': rating}));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, Colors.green, 'Product rated!');
          });
    } catch (e) {
      return showSnackBar(context, Colors.red, e.toString());
    }
  }
}
