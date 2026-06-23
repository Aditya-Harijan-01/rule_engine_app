// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class AuthPageController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  bool register = false;
  bool loading = false;
  bool isLogin = false;
  String? errorMessage;
  final box = GetStorage();
  final roles = ['Admin', 'Manager', 'User'];

  final selectedRole = 'User'.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    loading = true;
    errorMessage = null;
    update();

    try {
      if (register) {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text.trim(),
              password: password.text,
            );
        if (userCredential.user != null) {
          // Navigate to the home page after successful registration
          toggleAuthMode();
        }
      } else {
        final data = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
        // print('User signed in: ${data.user?.email}');
        if (data.user != null) {
          // Navigate to the home page after successful login
          box.write('userId', data.user!.uid);
          box.write('userEmail', data.user!.email);
          box.write('isLogin', true);
          Get.offAllNamed(Routes.HOME);
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message ?? 'Authentication failed.';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      loading = false;
      update();
    }
  }

  void toggleAuthMode() {
    register = !register;
    errorMessage = null;
    email.clear();
    password.clear();
    update();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
