import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  bool _isFocused = false;
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white : const Color(0xFFF3F6FA),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isFocused
              ? AppTheme.primaryBlue.withValues(alpha: 0.4)
              : const Color(0xFFE5EDF7).withValues(alpha: 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: _isFocused ? 14 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container Pill / Badge
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isFocused
                  ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                  : const Color(0xFFE8F1FD),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              widget.prefixIcon,
              size: 20,
              color: _isFocused ? AppTheme.primaryBlue : const Color(0xFF005BFF),
            ),
          ),

          const SizedBox(width: 12),

          // Text Input Field
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _internalFocusNode,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              validator: widget.validator,
              onFieldSubmitted: widget.onSubmitted,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              cursorColor: AppTheme.primaryBlue,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Suffix eye icon for password
          if (widget.isPassword)
            IconButton(
              splashRadius: 20,
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: const Color(0xFF94A3B8),
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
        ],
      ),
    );
  }
}
