import 'dart:convert';
import 'dart:ffi';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class AddressServices {
  void saveUserAddress(
      {required BuildContext context, required String address}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res =
          await http.post(Uri.parse('$uri/api/save-user-address'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.getUser.token!,
              },
              body: jsonEncode({'address': address}));

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User user = userProvider.getUser
                .copyWith(address: jsonDecode(res.body)['address']);

            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }

  void placeOrder(
      {required BuildContext context,
      required String address,
      required double totalSum}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.getUser.token!,
          },
          body: jsonEncode({
            'address': address,
            'totalPrice': totalSum,
            'cart': userProvider.getUser.cart
          }));

      httpErrorHandle(response: res, context: context, onSuccess: () {
        showSnackBar(context, Colors.green, 'Your order has been placed!');
        User user = userProvider.getUser.copyWith(
          cart: [],
        );
        userProvider.setUserFromModel(user);
      });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }
}
