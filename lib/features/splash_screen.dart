import 'dart:async';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1250), () {
      Navigator.pushNamed(
        context,
        Provider.of<UserProvider>(context, listen: false).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context, listen: false).user.type == "user"
            ? BottomBar.routeName
            : AdminScreen.routeName
            : AuthScreen.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            "assets/images/amazon_in.png",
            height: 70,
          ),
        ),
      ),
    );
  }
}
