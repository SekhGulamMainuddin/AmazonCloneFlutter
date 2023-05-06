import 'dart:convert';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {

      http.Response response = await http.post(
        Uri.parse("$uri/api/signup"),
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(response.statusCode);

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
              context: context,
              text: "Account Created! Login with same credentials");
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandling(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);
          await prefs.setString(
              "x-auth-token", jsonDecode(response.body)["token"]);
          if(jsonDecode(response.body)["type"]=="user")
            Navigator.pushNamedAndRemoveUntil(
              context, BottomBar.routeName, (route) => false);
          else
            Navigator.pushNamed(context, AdminScreen.routeName);
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = await prefs.getString("x-auth-token");
      if (token == null) {
        await prefs.setString("x-auth-token", "");
      }

      http.Response response = await http
          .post(Uri.parse("$uri/api/tokenIsValid"), headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "x-auth-token": token!
      });

      if (jsonDecode(response.body) == true) {
        http.Response userRes = await http.get(
          Uri.parse("$uri/api/userData"),
          headers: <String,String>{
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token
          }
        );

        Provider.of<UserProvider>(context, listen: false).setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }
}
