import 'package:calistracker/core/themes/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
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
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final String? errorText;
  final AutovalidateMode? autoValidate;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscure = widget.obscureText ?? false;

  bool get _isPassword => widget.kType == TextInputType.visiblePassword;

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
      style: AppTextStyles.input,
      decoration: InputDecoration(
        errorText: widget.errorText,
        enabled: widget.enabled ?? true,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        labelText: widget.labelText,
        prefixText: widget.prefixText,
        counterText: '',
        hintText: widget.hintText,
        filled: widget.filled,
        fillColor: widget.fillColor,
        suffixIcon: _isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () => setState(() => _isObscure = !_isObscure),
              )
            : widget.suffixIcon != null
            ? IconButton(
                icon: Icon(widget.suffixIcon),
                onPressed: widget.suffixIconTap,
              )
            : null,
      ),
    );
  }
}
