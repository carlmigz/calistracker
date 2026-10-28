import 'package:calistracker/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';

class WidgetTextField extends StatefulWidget {
  const WidgetTextField({
    super.key,
    required this.controller,
    this.suggestions,
    this.kType,
    this.inputFormatters,
    this.validator,
    this.maxLength,
    this.maxLines,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.enabled,
    this.filled,
    this.obscureText,
    this.suffixIcon,
    this.fNode,
    this.onFieldSubmitted,
    this.prefixText,
    this.suffixIconTap,
    this.textCaps,
    this.onChanged,
    this.fillColor,
    this.isDense,
    this.errorText,
    this.autoValidate,
  });

  final TextEditingController? controller;
  final bool? suggestions;
  final TextInputType? kType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLines;
  final String? labelText;
  final String? hintText;
  final String? prefixText;
  final IconData? prefixIcon;
  final bool? enabled;
  final bool? filled;
  final bool? obscureText;
  final IconData? suffixIcon;
  final FocusNode? fNode;
  final VoidCallback? suffixIconTap;
  final TextCapitalization? textCaps;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Color? fillColor;
  final bool? isDense;
  final String? errorText;
  final AutovalidateMode? autoValidate;

  @override
  State<WidgetTextField> createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enableSuggestions: widget.suggestions ?? true,
      autovalidateMode:
          widget.autoValidate ?? AutovalidateMode.onUserInteraction,
      keyboardType: widget.kType,
      validator: widget.validator,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines ?? 1,
      obscureText: _isObscure,
      focusNode: widget.fNode,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters ?? [],
      onFieldSubmitted: widget.onFieldSubmitted,
      textCapitalization: widget.textCaps ?? TextCapitalization.none,
      style: TextStyle(color: AppColors.white, fontSize: 12.sp),

      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.transparent),
        ),
        errorText: widget.errorText,
        enabled: widget.enabled ?? true,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: AppColors.white)
            : null,
        labelText: widget.labelText,
        labelStyle: TextStyle(color: AppColors.white),
        prefixText: widget.prefixText,
        counterText: '',
        hintText: widget.hintText,
        hintStyle: TextStyle(color: AppColors.white, fontSize: 12.sp),
        isDense: true,
        filled: widget.filled ?? true,
        fillColor: widget.fillColor ?? AppColors.darkGray,

        suffixIcon: widget.kType == TextInputType.visiblePassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Ionicons.eye_outline : Ionicons.eye_off_outline,
                  color: AppColors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : widget.suffixIcon != null
            ? IconButton(
                icon: Icon(widget.suffixIcon, color: AppColors.white),
                onPressed: widget.suffixIconTap,
              )
            : null,
      ),
    );
  }
}
