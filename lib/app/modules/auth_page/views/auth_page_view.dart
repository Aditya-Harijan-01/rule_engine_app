import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_page_controller.dart';

class AuthPageView extends GetView<AuthPageController> {
  const AuthPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthPageController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Icon(
                              Icons.account_tree_rounded,
                              size: 54,
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Rule Engine',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),

                            const SizedBox(height: 6),

                            Text(
                              controller.register
                                  ? 'Create your workspace'
                                  : 'Sign in to your workspace',
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 28),

                            TextFormField(
                              controller: controller.email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              validator: (v) => v != null && v.contains('@')
                                  ? null
                                  : 'Enter a valid email.',
                            ),

                            const SizedBox(height: 14),

                            TextFormField(
                              controller: controller.password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              validator: (v) => (v?.length ?? 0) >= 6
                                  ? null
                                  : 'Use at least 6 characters.',
                            ),

                            const SizedBox(height: 14),
                            if (controller.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Text(
                                  controller.errorMessage!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            FilledButton(
                              onPressed: controller.loading
                                  ? null
                                  : controller.submit,
                              child: Text(
                                controller.loading
                                    ? 'Please wait...'
                                    : controller.register
                                    ? 'Create account'
                                    : 'Sign in',
                              ),
                            ),

                            TextButton(
                              onPressed: controller.loading
                                  ? null
                                  : controller.toggleAuthMode,
                              child: Text(
                                controller.register
                                    ? 'Already have an account? Sign in'
                                    : 'New here? Create an account',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
