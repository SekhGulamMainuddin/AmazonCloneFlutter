import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeService {
  Future<List<Product>> getProducts({
    required BuildContext context,
    required String category,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> products = [];
    try {
      final response = await http.get(
          Uri.parse("$uri/api/products?category=$category"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": user.token
          });

      print(products.length);

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          for (var ele in jsonDecode(response.body)) {
            products.add(Product.fromJson(jsonEncode(ele)));
          }
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context: context, text: e.toString());
    }
    return products;
  }

  Future<Product> dealOfTheDay({
    required BuildContext context,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    Product product = Product(
      name: "",
      description: "",
      quantity: 0,
      images: [],
      category: "",
      price: 0,
    );
    try {
      final response = await http.get(
          Uri.parse("$uri/api/deal-of-the-day"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": user.token
          });

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          product= Product.fromJson(response.body);
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return product;
  }
}
