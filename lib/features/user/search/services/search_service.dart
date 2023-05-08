import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SearchService {
  Future<List<Product>> searchProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> products = [];
    try {
      final response = await http.get(
          Uri.parse("$uri/api/products/search/$searchQuery"),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": user.token
          });

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
      showSnackBar(context: context, text: e.toString());
    }
    return products;
  }
}
