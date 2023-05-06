import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/sales.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductService {
  void uploadProduct({
    required BuildContext context,
    required List<File> images,
    required String name,
    required String description,
    required String category,
    required double price,
    required double quantity,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      List<String> imageUrls = [];
      for (var file in images) {
        CloudinaryResponse response =
            await CloudinaryPublic("dsxa06gs7", "p7asfqi4").uploadFile(
          CloudinaryFile.fromFile(file.path, folder: name),
        );
        imageUrls.add(response.secureUrl);
      }

      Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price,
          id: "");

      http.Response response = await http.post(
        Uri.parse("$uri/api/admin/add-product"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context: context, text: "Product Uploaded Successfully");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  Future<List<Product>> getProducts(BuildContext context) async {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> productList = [];
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/admin/get-products"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": user.token
        },
      );

      for (var ele in jsonDecode(response.body)) {
        productList.add(Product.fromJson(jsonEncode(ele)));
      }


    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final response= await http.post(
        Uri.parse("$uri/api/admin/delete-product"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": user.token
        },
        body: jsonEncode({"id": product.id}),
      );

      httpErrorHandling(response: response, context: context, onSuccess: onSuccess);

    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context,text: e.toString());
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context: context,text: e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandling(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context: context,text: e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

}
