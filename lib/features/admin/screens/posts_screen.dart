import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/loader.dart';
import '../../../models/product.dart';

import 'add_product_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({Key? key}) : super(key: key);

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  // void deleteProduct(Product product) {
  //   adminServices.deleteProduct(
  //       context: context,
  //       product: product,
  //       onSuccess: () {
  //         products!.remove(product);
  //         setState(() {});
  //       });
  // }

  void deleteProductById(String productId) {
    adminServices.deleteProductById(
        context: context,
        productId: productId,
        onSuccess: () {
          products!.removeWhere((element) => element.id == productId);
          setState(() {});
        });
  }

  void navigateToAddProductScreen() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    final productData = products![index];
                    return Column(
                      children: [
                        SizedBox(
                          height: 140,
                          child: SingleProduct(
                            image: productData.images![0],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                productData.name!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            )),
                            IconButton(
                                onPressed: () {
                                  // deleteProduct(productData);
                                  deleteProductById(productData.id!);
                                },
                                icon: const Icon(Icons.delete_outline))
                          ],
                        )
                      ],
                    );
                  }),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: navigateToAddProductScreen,
              tooltip: 'Add a Product',
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
