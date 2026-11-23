import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import 'delete_account_screen.dart';
import 'deactivate_account_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0D17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0D17),
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
          'Settings',
          style: TextStyle(
            fontSize: 16.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          final user = authCtrl.currentUser.value;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Preferences
                _sectionHeader('PREFERENCES'),
                SizedBox(height: 4.h),
                _buildMenuRow(
                  icon: Icons.notifications_none_rounded,
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts for matches, likes, and messages',
                  trailing: _buildNotificationSwitch(context, authCtrl, user),
                ),

                SizedBox(height: 28.h),

                // Section: Legal & Policies
                _sectionHeader('LEGAL & POLICIES'),
                SizedBox(height: 4.h),
                _buildMenuRow(
                  icon: Icons.lock_outline_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'How we collect, manage, and protect your data',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 28.h),

                // Section: Account Management
                _sectionHeader('ACCOUNT ACTIONS'),
                SizedBox(height: 4.h),

                // Deactivate Account
                _buildMenuRow(
                  icon: Icons.pause_circle_outline_rounded,
                  iconColor: Colors.white.withValues(alpha: 0.7),
                  title: 'Deactivate Account',
                  subtitle:
                      'Temporarily hide your profile, stories, and matches',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DeactivateAccountScreen(),
                      ),
                    );
                  },
                ),

                _hairlineDivider(),

                // Delete Account
                _buildMenuRow(
                  icon: Icons.delete_outline_rounded,
                  iconColor: const Color(0xFFF87171),
                  title: 'Delete Account',
                  titleColor: const Color(0xFFF87171),
                  subtitle:
                      'Permanently remove your account and all associated data',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DeleteAccountScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 44.h),

                // Version Info
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Show Off  •  Version 1.0.0 (Build 12)',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Account & Privacy Settings',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.16),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w, bottom: 4.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.35),
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.9,
        ),
      ),
    );
  }

  Widget _hairlineDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withValues(alpha: 0.05),
      indent: 38.w,
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? titleColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: iconColor ?? Colors.white.withValues(alpha: 0.65),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? Colors.white.withValues(alpha: 0.9),
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.38),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: Colors.white.withValues(alpha: 0.25),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(
    BuildContext context,
    AuthController authCtrl,
    UserModel user,
  ) {
    return Obx(() {
      final isUpdating = authCtrl.isUpdatingNotifications.value;
      final currentUser = authCtrl.currentUser.value ?? user;
      final isEnabled = currentUser.notificationsEnabled;

      return GestureDetector(
        onTap: isUpdating
            ? null
            : () {
                HapticFeedback.lightImpact();
                authCtrl.toggleNotifications(!isEnabled, context);
              },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          width: 48.w,
          height: 28.h,
          padding: EdgeInsets.all(2.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: isEnabled
                ? const Color(0xFFFF4D8D)
                : Colors.white.withValues(alpha: 0.16),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 23.w,
              height: 23.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: isUpdating
                  ? Padding(
                      padding: EdgeInsets.all(3.5.w),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isEnabled
                              ? const Color(0xFFFF4D8D)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      );
    });
  }
}
