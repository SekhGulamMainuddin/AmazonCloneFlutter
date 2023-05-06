import 'package:amazon_clone/constants/loader.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/account/widgets/product.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/product_service.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ProductService productService = ProductService();
  List<Product>? productsList;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  fetchProducts() async {
    productsList = await productService.getProducts(context);
    setState(() {});
  }

  deleteProduct(Product product, int index) async {
    showSnackBar(context: context, text: "Delete Product : ${product.name}");
    productService.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          productsList?.removeAt(index);
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productsList == null
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.builder(
                itemCount: productsList?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final product = productsList![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5)
                        .copyWith(top: 5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 135,
                          child: SingleProduct(
                            imageUrl: product.images[0],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                child: const Icon(Icons.delete_outline),
                                onTap: () => deleteProduct(product, index),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Product",
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, AddProductScreen.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
