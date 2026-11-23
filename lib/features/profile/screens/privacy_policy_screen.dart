import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../../core/widgets/custom_button.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final AuthController _authCtrl = Get.find<AuthController>();
  bool _isAccepting = false;

  @override
  Widget build(BuildContext context) {
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
          'Privacy Policy',
          style: TextStyle(
            fontSize: 16.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Show Off Privacy & Terms',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Your privacy and safety are our highest priorities. Please review how we protect your data and maintain a safe creative community.',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.55),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Last updated: October 2026',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.35),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24.h),
              _sectionDivider(),
              SizedBox(height: 8.h),

              // Sections
              _buildSection(
                index: '01',
                title: 'Information We Collect',
                content:
                    'We collect information you provide directly to us, such as when you create or modify your account, upload creative moments, communicate with creators, or request customer support.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '02',
                title: 'How We Use Your Information',
                content:
                    'We use collected information to provide, maintain, and enhance our services. This includes facilitating connections, improving recommendation feeds, providing support, and keeping our platform safe and reliable.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '03',
                title: 'Sharing of Information',
                content:
                    'We do not sell your personal data. We only share information with trusted infrastructure providers required to operate our services, or in compliance with legal authorities when required by applicable laws.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '04',
                title: 'Security & Encryption',
                content:
                    'We implement industry-standard encryption and security protocols to safeguard your personal data from loss, unauthorized access, disclosure, and misuse.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '05',
                title: 'Content Policy & Zero Tolerance',
                isHighlighted: true,
                content:
                    'We strictly prohibit sexually explicit materials (18+), hate speech, harassment, extreme violence, or gore. We maintain a zero-tolerance policy. Violations will result in immediate content removal and permanent account termination without prior notice.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '06',
                title: 'Limitation of Liability & Fraud Prevention',
                content:
                    'Show Off is a communication platform. We strongly advise users never to share financial information, passwords, or bank details with anyone. Transactions or agreements between users are conducted solely at your own discretion.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '07',
                title: 'Age Restrictions (18+)',
                content:
                    'Our services are designed for individuals aged 18 and older. We do not knowingly collect personal information from minors. Accounts identified as underage will be terminated promptly.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '08',
                title: 'Your Data Rights (GDPR & CCPA)',
                content:
                    'You retain the right to access, correct, export, or permanently delete your personal information (Right to be Forgotten). You can exercise full data deletion at any time via Profile Settings > Delete Account.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '09',
                title: 'Intellectual Property',
                content:
                    'You retain full ownership of the original media content you upload to Show Off. The Show Off brand, app design, and proprietary code remain the exclusive property of Show Off.',
              ),
              _sectionDivider(),

              _buildSection(
                index: '10',
                title: 'Community Reporting & Account Bans',
                content:
                    'To maintain community trust, user reports are systematically monitored. Accounts receiving confirmed reports for scamming, harassment, or policy violations will be permanently blacklisted.',
              ),

              SizedBox(height: 28.h),

              // Accept Button (if user hasn't accepted yet)
              Obx(() {
                final user = _authCtrl.currentUser.value;
                final bool showAcceptButton =
                    user != null && !user.hasAcceptedPrivacyPolicy;
                if (!showAcceptButton) return const SizedBox.shrink();

                return Column(
                  children: [
                    CustomButton(
                      text: 'Accept & Continue',
                      isLoading: _isAccepting,
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        setState(() => _isAccepting = true);
                        final success = await _authCtrl.acceptPrivacyPolicy();
                        if (!context.mounted) return;
                        setState(() => _isAccepting = false);
                        if (success) {
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Failed to accept policy. Please try again.'),
                            ),
                          );
                        }
                      },
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: 12.r,
                      height: 50.h,
                    ),
                    SizedBox(height: 20.h),
                  ],
                );
              }),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String index,
    required String title,
    required String content,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                index,
                style: TextStyle(
                  color: isHighlighted
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF3B82F6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 13.5.sp,
              height: 1.6,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionDivider() {
    return Divider(
      height: 16.h,
      thickness: 1,
      color: Colors.white.withValues(alpha: 0.04),
    );
  }
}
