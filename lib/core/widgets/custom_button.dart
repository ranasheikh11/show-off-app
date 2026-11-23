import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final double? borderRadius;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 14.r;
    final effectiveHeight = height ?? 52.h;

    return SizedBox(
      width: width ?? double.infinity,
      height: effectiveHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: color ?? AppTheme.primaryBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)),
              ),
              child: _buildChild(color ?? AppTheme.primaryBlue),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: gradient ??
                    LinearGradient(colors: [
                      color ?? AppTheme.primaryBlue,
                      color ?? AppTheme.primaryBlue
                    ]),
                borderRadius: BorderRadius.circular(radius),
                boxShadow: gradient != null
                    ? [
                        BoxShadow(
                          color: gradient!.colors.first.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: (color ?? AppTheme.primaryBlue)
                              .withValues(alpha: 0.25),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius)),
                  elevation: 0,
                ),
                child: _buildChild(Colors.white),
              ),
            ),
    );
  }

  Widget _buildChild(Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 22.w,
        width: 22.w,
        child: const CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2.2,
        ),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 18.sp),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      );
    }
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    );
  }
}
