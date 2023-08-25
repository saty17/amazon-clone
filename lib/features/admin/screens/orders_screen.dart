import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';

import '../../../models/order.dart';
import '../../order_details/screens/order_details.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AdminServices adminServices = AdminServices();
  List<Order>? _orders;

  void fetchOrders() async {
    _orders = await adminServices.fetchAllOrders(context);
    setState(() {
      _orders = _orders;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return _orders == null
        ? const Loader()
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: _orders!.length,
            itemBuilder: (context, index) {
              final orderData = _orders![index];
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailScreen.routeName,
                        arguments: orderData);
                  },
                  child: SizedBox(
                    height: 140,
                    child: SingleProduct(
                      image: orderData.products![0].product!.images![0],
                    ),
                  ));
            },
          );
  }
}
