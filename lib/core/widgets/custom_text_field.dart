import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String? errorText;
  final void Function(String)? onChanged;
  final bool showStrengthIndicator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? labelColor;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.errorText,
    this.onChanged,
    this.showStrengthIndicator = false,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.labelColor,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String _password = '';

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _onTextChanged(String val) {
    if (widget.isPassword && widget.showStrengthIndicator) {
      setState(() {
        _password = val;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!(val);
    }
  }

  double _getPasswordStrength() {
    if (_password.isEmpty) return 0.0;
    double strength = 0.0;
    if (_password.length >= 6) strength += 0.25;
    if (_password.length >= 8) strength += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(_password)) strength += 0.25;
    if (RegExp(r'[0-9!@#\$&*~]').hasMatch(_password)) strength += 0.25;
    return strength;
  }

  Color _getStrengthColor(double strength) {
    if (strength <= 0.25) return const Color(0xFFEF4444);
    if (strength <= 0.5) return const Color(0xFFF59E0B);
    if (strength <= 0.75) return const Color(0xFF10B981);
    return const Color(0xFF06B6D4);
  }

  String _getStrengthText(double strength) {
    if (strength == 0) return '';
    if (strength <= 0.25) return 'Too short';
    if (strength <= 0.5) return 'Fair (add capital & number)';
    if (strength <= 0.75) return 'Good password';
    return 'Great & secure! 🔒';
  }

  @override
  Widget build(BuildContext context) {
    final strength = _getPasswordStrength();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: widget.labelColor ?? const Color(0xFFE2E8F0),
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          autovalidateMode: widget.autovalidateMode,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onChanged: _onTextChanged,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          cursorColor: widget.focusedBorderColor ?? const Color(0xFF3B82F6),
          style: TextStyle(
            color: widget.textColor ?? Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: widget.hintColor ?? Colors.white.withValues(alpha: 0.35),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            error: widget.errorText != null
                ? Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: AppTheme.errorRed, size: 14.sp),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            widget.errorText!,
                            style: TextStyle(
                              color: AppTheme.errorRed,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 12.w),
                    child: widget.prefixIcon,
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: widget.suffixIcon ??
                (widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: widget.hintColor ??
                              Colors.white.withValues(alpha: 0.45),
                          size: 20.sp,
                        ),
                        splashRadius: 20.r,
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null),
            filled: true,
            fillColor: widget.fillColor ?? const Color(0xFF1E2138),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: widget.borderColor ??
                    Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: widget.borderColor ??
                    Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: widget.focusedBorderColor ?? const Color(0xFF3B82F6),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppTheme.errorRed, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppTheme.errorRed, width: 1.5),
            ),
            errorStyle: TextStyle(
              color: AppTheme.errorRed,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (widget.isPassword &&
            widget.showStrengthIndicator &&
            _password.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: strength,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _getStrengthColor(strength)),
                    minHeight: 4.h,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                _getStrengthText(strength),
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w600,
                  color: _getStrengthColor(strength),
                ),
              ),
            ],
          ),
        ]
      ],
    );
  }
}
