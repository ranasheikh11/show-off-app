import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class DeactivateAccountScreen extends StatefulWidget {
  const DeactivateAccountScreen({super.key});

  @override
  State<DeactivateAccountScreen> createState() =>
      _DeactivateAccountScreenState();
}

class _DeactivateAccountScreenState extends State<DeactivateAccountScreen> {
  final AuthController _authCtrl = Get.find<AuthController>();
  bool _confirmed = false;

  void _onConfirmDeactivate() {
    if (!_confirmed || _authCtrl.isLoading.value) return;
    HapticFeedback.mediumImpact();
    _authCtrl.deactivateAccount(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white.withValues(alpha: 0.9),
            size: 19.sp,
          ),
          splashRadius: 22.r,
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Deactivate Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),

              // Soft Pause Icon
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.pause_rounded,
                    color: const Color(0xFF60A5FA),
                    size: 26.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Heading
              Text(
                'Take a break from Show Off',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Deactivating your account is temporary and completely reversible. Here is what happens while your account is paused:',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13.5.sp,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 28.h),

              // Text-based explanation rows with hairline dividers
              _infoRow(
                icon: Icons.visibility_off_outlined,
                title: 'Your profile will be hidden',
                description:
                    'Other users will not be able to find your profile in Search, Discover feeds, or recommendations.',
              ),
              _divider(),
              _infoRow(
                icon: Icons.photo_library_outlined,
                title: 'Your posts and stories stay safe',
                description:
                    'Nothing is deleted. All your uploaded show-offs, loves, and stats are preserved and simply paused from public view.',
              ),
              _divider(),
              _infoRow(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Messages and chats are paused',
                description:
                    'Your chat history remains untouched. You will not receive notifications until you decide to return.',
              ),
              _divider(),
              _infoRow(
                icon: Icons.restart_alt_rounded,
                title: 'Instant reactivation anytime',
                description:
                    'Whenever you are ready to come back, just sign in with your email and password to restore full access immediately.',
              ),

              SizedBox(height: 32.h),

              // Confirmation Checkbox
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _confirmed = !_confirmed);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: Checkbox(
                          value: _confirmed,
                          onChanged: (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _confirmed = val ?? false);
                          },
                          activeColor: const Color(0xFF3B82F6),
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'I understand my profile will be paused until I log in again.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12.5.sp,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Action Buttons
              Obx(() {
                final isLoading = _authCtrl.isLoading.value;

                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: (_confirmed && !isLoading)
                            ? _onConfirmDeactivate
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _confirmed
                              ? const Color(0xFF1E293B)
                              : Colors.white.withValues(alpha: 0.05),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(
                              color: _confirmed
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Deactivate My Account',
                                style: TextStyle(
                                  color: _confirmed
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.25),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context),
                      child: Text(
                        'Keep My Account Active',
                        style: TextStyle(
                          color: const Color(0xFF3B82F6),
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: Colors.white.withValues(alpha: 0.65),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF94A3B8),
                    fontSize: 12.5.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withValues(alpha: 0.05),
      indent: 34.w,
    );
  }
}
