import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../auth/models/user_model.dart';
import 'edit_profile_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    return Obx(() {
      final user = authCtrl.currentUser.value;
      if (user == null) {
        return const Scaffold(
          backgroundColor: Color(0xFF0C0D17),
          body: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF4D8D),
              strokeWidth: 2,
            ),
          ),
        );
      }
      return _ProfileView(user: user, authCtrl: authCtrl);
    });
  }
}

class _ProfileView extends StatelessWidget {
  final UserModel user;
  final AuthController authCtrl;

  const _ProfileView({required this.user, required this.authCtrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D17),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFF4D8D),
          backgroundColor: const Color(0xFF161828),
          onRefresh: () async {
            HapticFeedback.lightImpact();
            await authCtrl.refreshProfile();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Clean Minimal Navigation Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
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
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.5.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 20.sp,
                        ),
                        splashRadius: 22.r,
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Main Body (Text-Based & Minimalist)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),

                      // Avatar
                      _buildAvatar(user),
                      SizedBox(height: 14.h),

                      // Name & Handle
                      _buildNameAndHandle(user),
                      SizedBox(height: 18.h),

                      // Card-less Text-Based Stats Row
                      _buildTextStats(user),
                      SizedBox(height: 20.h),

                      // Edit Profile Button (Subtle, sleek outline)
                      _buildEditButton(context),
                      SizedBox(height: 32.h),

                      // Text-Based Menu List (No cards, pure clean rows)
                      _buildTextMenuList(context, authCtrl, user),
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Minimal Clean Avatar ─────────────────────────────────────────────────
  Widget _buildAvatar(UserModel user) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 86.w,
          height: 86.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: user.profileImage != null && user.profileImage!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: user.profileImage!,
                    width: 86.w,
                    height: 86.w,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      color: const Color(0xFF161828),
                      child: const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFFF4D8D),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (ctx, url, err) => _avatarFallback(user.name),
                  )
                : _avatarFallback(user.name),
          ),
        ),

        // Online dot
        if (user.isOnline)
          Positioned(
            bottom: 2.h,
            right: 2.w,
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF0C0D17),
                  width: 2.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _avatarFallback(String name) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'S';
    return Container(
      color: const Color(0xFF1A1D30),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ─── Name, Username & Details ─────────────────────────────────────────────
  Widget _buildNameAndHandle(UserModel user) {
    final hasUsername = user.username.trim().isNotEmpty;
    final hasAge = user.age != null && user.age! > 0;
    final hasEducation = user.education != null && user.education!.trim().isNotEmpty;

    return Column(
      children: [
        Text(
          user.name.trim().isNotEmpty ? user.name : 'Creator',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          hasUsername ? '@${user.username.trim()}' : user.email,
          style: TextStyle(
            fontSize: 13.5.sp,
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w400,
          ),
        ),
        if (hasAge || hasEducation) ...[
          SizedBox(height: 6.h),
          Text(
            [
              if (hasAge) '${user.age} yrs',
              if (hasEducation) user.education!,
            ].join('  •  '),
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.38),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  // ─── Pure Text-Based Stats (No Cards, Pure Breathable Typography) ──────────
  Widget _buildTextStats(UserModel user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statTextItem(user.postsCount.toString(), 'Posts'),
          _textDivider(),
          _statTextItem(user.lovedByCount.toString(), 'Loved'),
          _textDivider(),
          _statTextItem(user.matchedCount.toString(), 'Matches'),
        ],
      ),
    );
  }

  Widget _statTextItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withValues(alpha: 0.45),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _textDivider() {
    return Container(
      width: 1,
      height: 22.h,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }

  // ─── Minimal Outlined Edit Button ─────────────────────────────────────────
  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42.h,
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfileScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.14),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }

  // ─── Text-Based Menu (Direct Rows, Hairline Dividers, Zero Cards) ──────────
  Widget _buildTextMenuList(
      BuildContext context, AuthController authCtrl, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section: Preferences
        _sectionTitle('PREFERENCES'),
        SizedBox(height: 4.h),
        _menuTextRow(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          trailing: _buildNotificationSwitch(context, authCtrl, user),
        ),
        _hairlineDivider(),
        _menuTextRow(
          icon: Icons.lock_outline_rounded,
          title: 'Privacy Policy',
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            );
          },
        ),

        SizedBox(height: 24.h),

        // Section: Support
        _sectionTitle('SUPPORT & INFO'),
        SizedBox(height: 4.h),
        _menuTextRow(
          icon: Icons.help_outline_rounded,
          title: 'Help & Support',
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
            );
          },
        ),
        _hairlineDivider(),
        _menuTextRow(
          icon: Icons.info_outline_rounded,
          title: 'About Show Off',
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            );
          },
        ),

        SizedBox(height: 24.h),

        // Section: Account
        _sectionTitle('ACCOUNT'),
        SizedBox(height: 4.h),
        _menuTextRow(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
        _hairlineDivider(),
        _menuTextRow(
          icon: Icons.logout_rounded,
          iconColor: const Color(0xFFF87171),
          title: 'Log Out',
          titleColor: const Color(0xFFF87171),
          showChevron: false,
          onTap: () => _showLogoutDialog(context, authCtrl),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 2.h),
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

  Widget _menuTextRow({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? titleColor,
    VoidCallback? onTap,
    Widget? trailing,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 13.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 19.sp,
              color: iconColor ?? Colors.white.withValues(alpha: 0.65),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Colors.white.withValues(alpha: 0.88),
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (trailing != null)
              trailing
            else if (showChevron)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13.sp,
                color: Colors.white.withValues(alpha: 0.22),
              ),
          ],
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

  // ─── Minimal Dialogs ──────────────────────────────────────────────────────
  Future<void> _showLogoutDialog(
      BuildContext context, AuthController authCtrl) async {
    HapticFeedback.lightImpact();
    final confirm = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161828),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: const Text(
          'Log Out',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      authCtrl.logout(context);
    }
  }
}
