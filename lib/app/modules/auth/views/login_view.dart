import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../core/values/app_strings.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _obscurePassword = true.obs;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      body: Stack(
        children: [
          // ================== BACKGROUND ==================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF1F6), Color(0xFFFFE6EF)],
              ),
            ),
          ),

          Positioned(
            top: -140,
            left: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFFFF85A7).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // ================== CONTENT ==================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ================== BRANDING ==================
                    Image.asset(
                      'assets/images/mochi_logo.png',
                      width: 170, // 🔥 lebih besar & dominan
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Hello There !',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F91),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sweet moments start here',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),

                    const SizedBox(height: 40),

                    // ================== FLOATING CARD ==================
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // EMAIL
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: AppStrings.email,
                                hintText: 'name@example.com',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: controller.validateEmail,
                              enabled: !controller.isLoading.value,
                            ),
                            const SizedBox(height: 16),

                            // PASSWORD
                            Obx(
                              () => TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword.value,
                                decoration: InputDecoration(
                                  labelText: AppStrings.password,
                                  hintText: '••••••••',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () => _obscurePassword.value =
                                        !_obscurePassword.value,
                                  ),
                                ),
                                validator: controller.validatePassword,
                                enabled: !controller.isLoading.value,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // LOGIN BUTTON
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6F91),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            controller.login(
                                              _emailController.text,
                                              _passwordController.text,
                                            );
                                          }
                                        },
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          AppStrings.login,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // REGISTER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  AppStrings.dontHaveAccount,
                                  style: TextStyle(fontSize: 13),
                                ),
                                TextButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.goToRegister,
                                  child: const Text(
                                    AppStrings.register,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
