import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/custom_assets.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthController _authCtrl = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _authCtrl.registerEmailError.value = null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onRegister() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      _authCtrl.register({
        'name': _nameCtrl.text.trim(),
        'username': _userCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'password': _passCtrl.text.trim(),
      }, context);
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
              top: -60.h,
              left: -50.w,
              child: Container(
                width: 250.w,
                height: 250.h,
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
              bottom: 80.h,
              right: -70.w,
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

            SafeArea(
              child: Column(
                children: [
                  // Sleek Custom Top Navigation Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.pop();
                          },
                          child: Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2138),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D8D).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: const Color(0xFFFF4D8D).withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                color: const Color(0xFFFF4D8D),
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Join Show Off',
                                style: TextStyle(
                                  color: const Color(0xFFFF4D8D),
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form Scroll Area
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 90.w,
                                    height: 90.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          const Color(0xFFFF3377).withValues(alpha: 0.2),
                                          const Color(0xFF3B82F6).withValues(alpha: 0.1),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    CustomAssets.transparentLogo,
                                    height: 85.h,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Heading
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
                                'Create Account',
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
                              'Sign up to share your talent with creators worldwide',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 28.h),

                            // Full Name Field
                            CustomTextField(
                              label: 'Full Name',
                              hint: 'e.g. John Doe',
                              controller: _nameCtrl,
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              prefixIcon: Icon(
                                Icons.badge_outlined,
                                color: const Color(0xFFFF4D8D).withValues(alpha: 0.8),
                                size: 20.sp,
                              ),
                              validator: (val) {
                                final text = val?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                if (text.length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(text)) {
                                  return 'Name should only contain letters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Username Field
                            CustomTextField(
                              label: 'Username',
                              hint: 'e.g. johndoe',
                              controller: _userCtrl,
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              prefixIcon: Icon(
                                Icons.alternate_email_rounded,
                                color: const Color(0xFF818CF8).withValues(alpha: 0.85),
                                size: 20.sp,
                              ),
                              validator: (val) {
                                final text = val?.trim() ?? '';
                                if (text.isEmpty) {
                                  return 'Please choose a username';
                                }
                                if (text.length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                if (text.length > 25) {
                                  return 'Username cannot exceed 25 characters';
                                }
                                if (text.contains(' ')) {
                                  return 'Username cannot contain spaces';
                                }
                                if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(text)) {
                                  return 'Only letters, numbers, and _ . are allowed';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            // Email Field
                            Obx(() => CustomTextField(
                              label: 'Email',
                              hint: 'name@example.com',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              autofillHints: const [AutofillHints.email],
                              errorText: _authCtrl.registerEmailError.value,
                              onChanged: (_) {
                                if (_authCtrl.registerEmailError.value != null) {
                                  _authCtrl.registerEmailError.value = null;
                                }
                              },
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
                            )),
                            SizedBox(height: 16.h),

                            // Password Field
                            CustomTextField(
                              label: 'Password',
                              hint: 'Create a strong password',
                              controller: _passCtrl,
                              isPassword: true,
                              showStrengthIndicator: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _onRegister(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                color: const Color(0xFF38B6FF).withValues(alpha: 0.85),
                                size: 20.sp,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please create a password';
                                }
                                if (val.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 28.h),

                            // Register Button
                            Obx(() => CustomButton(
                              text: 'Create Account',
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
                              onPressed: _onRegister,
                            )),
                            SizedBox(height: 18.h),

                            // Human trust badge / disclaimer
                            Center(
                              child: Text(
                                'By signing up, you agree to our Terms & Privacy Policy.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 12.sp,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Bottom Login redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    context.pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                                    child: Text(
                                      'Log In',
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
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
