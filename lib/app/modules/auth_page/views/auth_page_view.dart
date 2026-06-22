import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/auth_page_controller.dart';

class AuthPageView extends GetView<AuthPageController> {
  const AuthPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AuthPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
