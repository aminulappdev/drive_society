import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_color/app_colors.dart';
import '../app_text_style/styles.dart';

class CustomTextField extends StatefulWidget {
  final double? height;
  final TextEditingController? controller;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final Widget? sufIcon;
  final Widget? preIcon;
  final ValueChanged<String>? onChange;
  final double borderRadius;
  final Color? containerColor;
  final Color? borderColor;
  final bool isPassword;
  final Color? textColor;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.height = 48,
    this.controller,
    this.hintText,
    this.hintTextStyle,
    this.sufIcon,
    this.preIcon,
    this.onChange,
    this.borderRadius = 12,
    this.containerColor,
    this.borderColor,
    this.isPassword = false,
    this.textColor,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.validator,
    this.autovalidateMode,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor ?? AppColors.borderColor),
        color: widget.containerColor,
      ),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        onChanged: widget.onChange,
        controller: widget.controller,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType ?? (widget.isPassword
            ? TextInputType.text
            : TextInputType.text),
        obscureText: widget.isPassword ? _obscureText : false,
        style: TextStyle(color: widget.textColor ?? AppColors.black),
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          hintText: widget.hintText ?? '',
          hintStyle: widget.hintTextStyle ?? h5.copyWith(color: AppColors.black),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: widget.preIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.sufIcon,
          border: InputBorder.none,
          errorStyle: TextStyle(color: AppColors.red),
          counterText: '',
        ),
      ),
    );
  }
}
