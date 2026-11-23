import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/custom_assets.dart';
import 'privacy_policy_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About Show Off',
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
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Header (Logo already has 'Show Off' text embedded, so no duplicate text)
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      CustomAssets.transparentLogo,
                      height: 86.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Version 1.0.0  •  Build 12',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: Colors.white.withValues(alpha: 0.4),
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 36.h),

              // Mission
              _sectionHeader('OUR MISSION'),
              SizedBox(height: 8.h),
              Text(
                'A space to share what you love, connect authentically, and discover extraordinary creators around the globe.',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.45,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Show Off was founded on the belief that everyone has a unique story, talent, or milestone worthy of celebrating. We designed this platform to be clean, distraction-free, and respectful of your time and privacy.',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: const Color(0xFF94A3B8),
                  height: 1.6,
                ),
              ),

              SizedBox(height: 32.h),

              // Core Values & Highlights
              _sectionHeader('WHAT WE STAND FOR'),
              SizedBox(height: 8.h),
              _buildValueRow(
                icon: Icons.auto_awesome_outlined,
                title: 'Creative Authenticity',
                description:
                    'Express yourself freely with high-fidelity posts, stories, and curated media without artificial pressures.',
              ),
              _hairlineDivider(),
              _buildValueRow(
                icon: Icons.shield_outlined,
                title: 'Safe & Respectful Community',
                description:
                    'We uphold a strict zero-tolerance policy against hate speech, harassment, and harmful interactions.',
              ),
              _hairlineDivider(),
              _buildValueRow(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy by Design',
                description:
                    'Your personal data belongs to you. We strictly encrypt sensitive information and never sell user information.',
              ),
              _hairlineDivider(),
              _buildValueRow(
                icon: Icons.people_outline_rounded,
                title: 'Genuine Connections',
                description:
                    'Discover people who share your specific passions, hobbies, and aspirations through meaningful engagement.',
              ),

              SizedBox(height: 32.h),

              // Technical Specifications
              _sectionHeader('APPLICATION DETAILS'),
              SizedBox(height: 8.h),
              _buildSpecRow(label: 'Application', value: 'Show Off Mobile'),
              _hairlineDivider(),
              _buildSpecRow(label: 'Version', value: '1.0.0 (Release)'),
              _hairlineDivider(),
              _buildSpecRow(label: 'Build', value: '2026.11.12'),
              _hairlineDivider(),
              _buildSpecRow(label: 'Engine', value: 'Flutter Impeller (Vulkan)'),
              _hairlineDivider(),
              _buildSpecRow(label: 'Target Platform', value: 'Android & iOS'),

              SizedBox(height: 32.h),

              // Creator & Credits
              _sectionHeader('DEVELOPMENT & CREDITS'),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Designed & Crafted by Rana Sheikh',
                      style: TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Engineered with dedicated attention to craftsmanship, smooth transitions, and intuitive user experiences.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF94A3B8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Legal & Open Source
              _sectionHeader('LEGAL & LICENSES'),
              SizedBox(height: 8.h),
              _buildActionRow(
                icon: Icons.description_outlined,
                title: 'Privacy Policy & Terms',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                  );
                },
              ),
              _hairlineDivider(),
              _buildActionRow(
                icon: Icons.code_rounded,
                title: 'Open Source Software Licenses',
                onTap: () {
                  HapticFeedback.lightImpact();
                  showLicensePage(
                    context: context,
                    applicationName: 'Show Off',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2026 Show Off Inc. All rights reserved.',
                  );
                },
              ),

              SizedBox(height: 44.h),

              // Footer
              Center(
                child: Column(
                  children: [
                    Text(
                      '© 2026 Show Off Inc. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Made with passion for creators everywhere.',
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
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
      color: Colors.white.withValues(alpha: 0.05),
      height: 1,
    );
  }

  Widget _buildValueRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Icon(
              icon,
              size: 19.sp,
              color: Colors.white.withValues(alpha: 0.65),
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: const Color(0xFF94A3B8),
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

  Widget _buildSpecRow({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.5.sp,
              color: Colors.white.withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5.sp,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.28),
              size: 19.sp,
            ),
          ],
        ),
      ),
    );
  }
}
