import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MusicSearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback onClear;

  const MusicSearchHeader({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          width: 36.w,
          height: 4.h,
          margin: EdgeInsets.only(top: 10.h, bottom: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),

        // Header Title Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Soundtrack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20.sp,
                ),
                splashRadius: 18.r,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        // Search Input Field
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              style: TextStyle(color: Colors.white, fontSize: 13.5.sp),
              cursorColor: const Color(0xFF3B82F6),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: false,
                hintText: 'Search songs, artists, or genres...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 19.sp,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 17.sp,
                        ),
                        splashRadius: 16.r,
                        onPressed: onClear,
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
