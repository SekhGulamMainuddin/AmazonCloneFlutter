import 'dart:convert';

import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandling({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context: context, text: jsonDecode(response.body)["msg"]);
      break;
    case 500:
      showSnackBar(context: context, text: jsonDecode(response.body)["error"]);
      break;
    default:
      showSnackBar(context: context, text: response.body);
  }
}
