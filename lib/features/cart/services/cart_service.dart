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

class CartService{
  void removeFromCart({
    required BuildContext context,
    required Product product,
}) async {
    try{
      final userProvider= Provider.of<UserProvider>(context, listen: false);
      final response= await http.get(
        Uri.parse("$uri/api/remove-cart/${product.id}"),
        headers: <String,String>{
          "Content-Type":"application/json; charset=UTF-8",
          "x-auth-token":userProvider.user.token
        }
      );

      httpErrorHandling(response: response, context: context, onSuccess: (){
        User user =
        userProvider.user.copyWith(cart: jsonDecode(response.body)['cart']);
        userProvider.setUserFromModel(user);
      });

    }catch(e){
      showSnackBar(context: context, text: e.toString());
    }
  }
}