import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'privacy_policy_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allFaqs = const [
    {
      'category': 'Account & Security',
      'question': 'How do I change or reset my password?',
      'answer':
          'Log out of your current session and tap "Forgot Password" on the sign-in screen. We will send a secure verification code to your registered email to reset your credentials.',
    },
    {
      'category': 'Account & Security',
      'question': 'How do I update my profile details?',
      'answer':
          'Open the Profile tab and tap "Edit Profile". You can modify your display name, bio, education, age, gender, and interests at any time.',
    },
    {
      'category': 'Account & Security',
      'question': 'How do I permanently delete my account?',
      'answer':
          'Navigate to Profile > Account > Delete Account. Review the consequences, confirm your agreement, and submit the deletion. All your personal data and posts will be irreversibly removed.',
    },
    {
      'category': 'Safety & Moderation',
      'question': 'How do I report inappropriate content or abusive users?',
      'answer':
          'Show Off maintains a zero-tolerance policy against hate speech, harassment, nudity, and violence. Tap the three dots icon on any post or profile to report it immediately. Our moderation team reviews flagged items 24/7.',
    },
    {
      'category': 'Safety & Moderation',
      'question': 'What happens when an account is reported?',
      'answer':
          'Our safety team investigates the flagged content within a few hours. Accounts violating our community standards will receive warnings, temporary suspensions, or immediate permanent termination.',
    },
    {
      'category': 'Privacy & Privacy Controls',
      'question': 'Who can see my profile and posts?',
      'answer':
          'Show Off is a discovery platform for creative expressions. By default, public posts are discoverable across the feed. You can manage notifications and account visibility settings under your profile settings.',
    },
    {
      'category': 'Privacy & Privacy Controls',
      'question': 'Is my personal data encrypted and secure?',
      'answer':
          'Yes. All network transmissions are strictly encrypted via TLS 1.3/HTTPS, and credentials are protected with industry-standard one-way cryptographic hashing.',
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.trim().isEmpty) return _allFaqs;
    final query = _searchQuery.toLowerCase();
    return _allFaqs.where((faq) {
      final q = faq['question']?.toLowerCase() ?? '';
      final a = faq['answer']?.toLowerCase() ?? '';
      final c = faq['category']?.toLowerCase() ?? '';
      return q.contains(query) || a.contains(query) || c.contains(query);
    }).toList();
  }

  void _copyToClipboard(String text, String label) {
    HapticFeedback.lightImpact();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$label copied to clipboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

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
          'Help & Support',
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
                'How can we help?',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Find answers to common questions about your account and safety, or get in touch with our team directly.',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  color: const Color(0xFF94A3B8),
                  height: 1.5,
                ),
              ),

              SizedBox(height: 20.h),

              // Minimal Search Input
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  cursorColor: const Color(0xFF3B82F6),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search questions, keywords...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 13.5.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 20.sp,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 18.sp,
                            ),
                            splashRadius: 18.r,
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 13.h,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // FAQ Section Title
              _sectionHeader('FREQUENTLY ASKED QUESTIONS'),
              SizedBox(height: 8.h),

              if (faqs.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 36.sp,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'No matching questions found',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Try searching with another keyword or contact us below.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.35),
                            fontSize: 12.5.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...faqs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      _buildFaqTile(
                        question: item['question']!,
                        answer: item['answer']!,
                        category: item['category']!,
                      ),
                      if (index < faqs.length - 1)
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                    ],
                  );
                }),

              SizedBox(height: 32.h),

              // Contact Section
              _sectionHeader('DIRECT SUPPORT'),
              SizedBox(height: 8.h),

              _buildContactRow(
                icon: Icons.alternate_email_rounded,
                title: 'Email Support',
                value: 'support@showoff.com',
                caption: 'Typical response within 24 hours',
                onAction: () => _copyToClipboard('support@showoff.com', 'Support email'),
              ),
              Divider(
                color: Colors.white.withValues(alpha: 0.05),
                height: 1,
              ),
              _buildContactRow(
                icon: Icons.shield_outlined,
                title: 'Safety & Trust Team',
                value: 'safety@showoff.com',
                caption: 'For urgent moderation or harassment reports',
                onAction: () => _copyToClipboard('safety@showoff.com', 'Safety email'),
              ),

              SizedBox(height: 32.h),

              // Legal & Quick Links
              _sectionHeader('POLICIES & GUIDELINES'),
              SizedBox(height: 8.h),

              _buildLinkRow(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy Policy',
                subtitle: 'How we collect, use, and protect your data',
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                  );
                },
              ),
              Divider(
                color: Colors.white.withValues(alpha: 0.05),
                height: 1,
              ),
              _buildLinkRow(
                icon: Icons.verified_user_outlined,
                title: 'Community Guidelines',
                subtitle: 'Our zero-tolerance policy on abuse and explicit content',
                onTap: () {
                  HapticFeedback.lightImpact();
                  _showGuidelinesDialog(context);
                },
              ),

              SizedBox(height: 40.h),

              // Subdued App Version Footer
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
                      'All rights reserved',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.16),
                        fontSize: 11.sp,
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

  Widget _buildFaqTile({
    required String question,
    required String answer,
    required String category,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        childrenPadding: EdgeInsets.only(left: 4.w, right: 8.w, bottom: 14.h),
        collapsedIconColor: Colors.white.withValues(alpha: 0.35),
        iconColor: Colors.white.withValues(alpha: 0.75),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.35,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 11.5.sp,
              color: Colors.white.withValues(alpha: 0.35),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13.5.sp,
                color: const Color(0xFF94A3B8),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String value,
    required String caption,
    required VoidCallback onAction,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontFamily: 'monospace',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  caption,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            onPressed: onAction,
            icon: Icon(
              Icons.copy_rounded,
              size: 18.sp,
              color: Colors.white.withValues(alpha: 0.45),
            ),
            splashRadius: 20.r,
            tooltip: 'Copy',
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
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
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.38),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.28),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showGuidelinesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF131525),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Text(
          'Community Guidelines',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Show Off enforces a strict Zero Tolerance policy regarding:\n\n'
              '• Hate speech, bullying, or harassment\n'
              '• Sexually explicit or pornographic media\n'
              '• Violent, dangerous, or illegal activities\n'
              '• Impersonation and misinformation\n\n'
              'Violating accounts are subject to immediate permanent suspension without prior warning.',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 13.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Understood',
              style: TextStyle(
                color: const Color(0xFF3B82F6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
