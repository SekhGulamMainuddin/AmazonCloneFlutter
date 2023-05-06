import 'package:amazon_clone/constants/loader.dart';
import 'package:amazon_clone/features/home/services/home_service.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({Key? key}) : super(key: key);

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  final HomeService homeService = HomeService();
  Product? product;

  @override
  void initState() {
    super.initState();
    getDealOfTheDay();
  }

  getDealOfTheDay() async {
    product = await homeService.dealOfTheDay(context: context);
    setState(() {});
  }

  navigateToDetails() {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
        arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Loader()
        : product!.name.isEmpty
            ? const SizedBox()
            : GestureDetector(
                onTap: navigateToDetails,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text(
                        "Deal of the day",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Image.network(
                      product!.images[0],
                      fit: BoxFit.fitHeight,
                      height: 235,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15)
                          .copyWith(top: 5),
                      child: Text(
                        "\u{20B9} ${product!.price}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15)
                          .copyWith(top: 5),
                      child: Text(product!.name),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: product!.images
                            .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.network(
                                    e,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fitWidth,
                                  ),
                            ))
                            .toList(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(vertical: 5)
                          .copyWith(left: 15),
                      child: Text(
                        "See all",
                        style: TextStyle(
                          color: Colors.cyan[800],
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }
}
