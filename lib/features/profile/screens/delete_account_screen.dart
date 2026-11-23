import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final AuthController _authCtrl = Get.find<AuthController>();
  bool _confirmed = false;

  void _onConfirmDelete() {
    if (!_confirmed || _authCtrl.isLoading.value) return;
    HapticFeedback.mediumImpact();
    _authCtrl.deleteAccount(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
          'Delete Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Soft Warning Icon
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFEF4444),
                    size: 26.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Title & Human Subtitle
              Text(
                "We're sorry to see you go",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Before deleting your account permanently, please take a moment to understand what will happen:',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 28.h),

              // Text-Based Impact List (Zero Cards, Pure Clean Hairline Rows)
              _bulletPoint(
                Icons.image_not_supported_outlined,
                'Your posts, media & show-offs',
                'All media content you published will be permanently erased.',
              ),
              _divider(),
              _bulletPoint(
                Icons.favorite_border_rounded,
                'Loves, matches & conversations',
                'You will be removed from all chats and matching records.',
              ),
              _divider(),
              _bulletPoint(
                Icons.person_off_outlined,
                'Profile & username',
                'Your profile handle and all associated data will become unreachable.',
              ),
              _divider(),
              _bulletPoint(
                Icons.history_rounded,
                'Irreversible action',
                'This cannot be undone. You will not be able to reactivate this account.',
              ),

              const Spacer(),

              // Confirmation Checkbox (Clean & Minimal)
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _confirmed = !_confirmed);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: Checkbox(
                          value: _confirmed,
                          activeColor: const Color(0xFFEF4444),
                          checkColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          onChanged: (val) {
                            HapticFeedback.selectionClick();
                            setState(() => _confirmed = val ?? false);
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'I understand that deleting my account is permanent and cannot be reversed.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13.sp,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Keep Account (Primary Safe Action)
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2138),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Keep My Account',
                    style: TextStyle(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Delete Account Button (Confirmed Action)
              Obx(() => SizedBox(
                width: double.infinity,
                height: 48.h,
                child: TextButton(
                  onPressed: (_confirmed && !_authCtrl.isLoading.value)
                      ? _onConfirmDelete
                      : null,
                  style: TextButton.styleFrom(
                    backgroundColor: _confirmed
                        ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                        : Colors.transparent,
                    foregroundColor: const Color(0xFFEF4444),
                    disabledForegroundColor:
                        Colors.white.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: _confirmed
                            ? const Color(0xFFEF4444).withValues(alpha: 0.4)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                  child: _authCtrl.isLoading.value
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFEF4444),
                          ),
                        )
                      : Text(
                          'Delete My Account Permanently',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: _confirmed
                                ? const Color(0xFFEF4444)
                                : Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                ),
              )),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulletPoint(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              icon,
              size: 17.sp,
              color: Colors.white.withValues(alpha: 0.5),
            ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12.5.sp,
                    height: 1.4,
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
      indent: 31.w,
    );
  }
}
