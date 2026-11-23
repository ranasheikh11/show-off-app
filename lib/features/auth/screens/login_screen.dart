import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/custom_assets.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _authCtrl = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _authCtrl.loginError.value = null;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      _authCtrl.login(_emailCtrl.text.trim(), _passCtrl.text.trim(), context);
    } else {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFF131527),
        body: Stack(
          children: [
            // Ambient decorative background glows
            Positioned(
              top: -80.h,
              right: -40.w,
              child: Container(
                width: 260.w,
                height: 260.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFF3377).withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 120.h,
              left: -80.w,
              child: Container(
                width: 260.w,
                height: 260.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF3B82F6).withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main form content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),

                        // Logo with subtle ambient aura
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 110.w,
                                height: 110.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFFF3377).withValues(alpha: 0.22),
                                      const Color(0xFF3B82F6).withValues(alpha: 0.12),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Image.asset(
                                CustomAssets.transparentLogo,
                                height: 105.h,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // Humanized Header
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFFFF4D8D),
                              Color(0xFF9370DB),
                              Color(0xFF38B6FF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Sign in to explore moments and connect with creators',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Email Field
                        CustomTextField(
                          label: 'Email',
                          hint: 'name@example.com',
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autofillHints: const [AutofillHints.email],
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: const Color(0xFFFF4D8D).withValues(alpha: 0.8),
                            size: 20.sp,
                          ),
                          validator: (val) {
                            final text = val?.trim() ?? '';
                            if (text.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                            if (!emailRegex.hasMatch(text)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 18.h),

                        // Password Field
                        Obx(() => CustomTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: _passCtrl,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLogin(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: const Color(0xFF38B6FF).withValues(alpha: 0.85),
                            size: 20.sp,
                          ),
                          errorText: _authCtrl.loginError.value,
                          onChanged: (_) {
                            if (_authCtrl.loginError.value != null) {
                              _authCtrl.loginError.value = null;
                            }
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (val.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        )),

                        // Forgot Password Link
                        SizedBox(height: 6.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              context.push('/forget-password');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: const Color(0xFF60A5FA),
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),

                        // Submit Button
                        Obx(() => CustomButton(
                          text: 'Log In',
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF3377),
                              Color(0xFF6366F1),
                              Color(0xFF2563EB),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          isLoading: _authCtrl.isLoading.value,
                          onPressed: _onLogin,
                        )),
                        SizedBox(height: 26.h),

                        // Bottom Register redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.lightImpact();
                                context.push('/register');
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    color: const Color(0xFFFF4D8D),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
