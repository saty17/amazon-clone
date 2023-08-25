import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../../providers/user_provider.dart';
import '../model/sales.dart';

class AdminServices {
  void sellProducts({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<XFile> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dbo9owt24', 'o2soetj6');
      List<String> imageUrls = [];

      for (var image in images) {
        CloudinaryResponse res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(image.path, folder: name));
        imageUrls.add(res.secureUrl);
      }

      print('$imageUrls++++++++++++++++');

      Product product = Product(
          name: name,
          description: description,
          price: price,
          quantity: quantity,
          category: category,
          images: imageUrls);

      http.Response res = await http.post(Uri.parse('$uri/admin/add-product'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.getUser.token!
          },
          body: jsonEncode(product.toMap()));
      print(jsonEncode(product.toMap()));
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, Colors.green, 'Product Added Successfully!');
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    print(userProvider.getUser.token);
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-products'), headers: {
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

  // void deleteProduct({required BuildContext context, required Product product, required VoidCallback onSuccess}) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   try {
  //     http.Response res = await http.post(Uri.parse('$uri/admin/delete-product'), body: jsonEncode({'id': product.id}), headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'x-auth-token': userProvider.getUser.token
  //     });
  //
  //     httpErrorHandle(response: res, context: context, onSuccess: (){
  //       showSnackBar(context, Colors.green, 'Product Deleted Successfully!');
  //       onSuccess();
  //     });
  //   } catch (e) {
  //     showSnackBar(context, Colors.red, e.toString());
  //   }
  // }

  void deleteProductById(
      {required BuildContext context,
      required String productId,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http
          .delete(Uri.parse('$uri/admin/delete-product/$productId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.getUser.token!
      });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, Colors.green, 'Product Deleted Successfully!');
            onSuccess();
          });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    print(userProvider.getUser.token);
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.getUser.token!
      });
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            orderList = orderFromJson(res.body);
          });
    } catch (e) {
      print(e);
      showSnackBar(context, Colors.red, e.toString());
    }
    return orderList;
  }

  void changeOrderStatus(
      {required BuildContext context,
      required int status,
      required Order order,
      required VoidCallback onSuccess}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
          Uri.parse('$uri/admin/change-order-status'),
          body: jsonEncode({'id': order.id, 'status': status}),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.getUser.token!
          });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, Colors.green, 'Order Updated Successfully!');
            onSuccess();
          });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarnings = 0;
    print(userProvider.getUser.token);
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.getUser.token!
      });
      print(res.body);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);
            totalEarnings = response['totalEarnings'];
            sales = [
              Sales('Mobiles', response['mobileEarnings']),
              Sales('Essentials', response['essentialEarnings']),
              Sales('Appliances', response['applianceEarnings']),
              Sales('Books', response['bookEarnings']),
              Sales('Fashion', response['fashionEarnings']),
            ];
          });
    } catch (e) {
      print(e);
      showSnackBar(context, Colors.red, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarnings
    };
  }

}
