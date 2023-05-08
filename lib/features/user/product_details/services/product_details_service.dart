import 'dart:convert';

import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsService {
  void rateProduct({
    required BuildContext context,
    required Product product,
    required double ratings,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      final response = await http.post(
        Uri.parse("$uri/api/rate-product"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": user.token
        },
        body: jsonEncode({"id": product.id, "ratings": ratings}),
      );

      httpErrorHandling(response: response, context: context, onSuccess: () {});
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final response = await http.post(
          Uri.parse(
            "$uri/api/add-product-to-cart",
          ),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": userProvider.user.token
          },
          body: jsonEncode({
            "id": product.id
          }));

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          User user= userProvider.user.copyWith(cart: jsonDecode(response.body)["cart"]);
          userProvider.setUserFromModel(user);
          print(userProvider.user.cart[0]);
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context: context, text: e.toString());
    }
  }
}
