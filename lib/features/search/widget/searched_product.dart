import 'package:amazon_clone/common/widgets/rating_bars.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;

  const SearchedProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    double ratings= 0;
    for (var ele in product.rating!) {
      totalRating += ele.rating;
    }
    if (totalRating != 0) {
      ratings = totalRating / product.rating!.length;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 5),
      child: Row(
        children: [
          Image.network(
            product.images[0],
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10,),
          Column(
            children: [
              Container(
                width: 235,
                alignment: Alignment.topLeft,
                child: Text(
                  product.name,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2),
                width: 235,
                alignment: Alignment.topLeft,
                child: RatingBars(ratings: ratings),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                width: 235,
                alignment: Alignment.topLeft,
                child: Text(
                  "\u{20B9}${product.price}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 235,
                alignment: Alignment.topLeft,
                child: const Text(
                  "Eligible for FREE Shiping",
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                width: 235,
                alignment: Alignment.topLeft,
                child: const Text(
                  "In Stock",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
