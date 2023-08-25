import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/widgets/bottom_bar.dart';
import '../providers/user_provider.dart';
import 'admin/screens/admin_screen.dart';
import 'auth/screens/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void navigateToNextScreen(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      final userProvider = Provider.of<UserProvider>(context, listen: false).getUser;
      userProvider.token!.isNotEmpty || userProvider.token != null
          ? userProvider.type == 'user'
              ? Navigator.pushNamed(context, BottomBar.routeName)
              : Navigator.pushNamed(context, AdminScreen.routeName)
          : Navigator.pushNamed(context, AuthScreen.routeName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToNextScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Image.asset(
          'assets/images/amazon_in.png',
        )));
  }
}
