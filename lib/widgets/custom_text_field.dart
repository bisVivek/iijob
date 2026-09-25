import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final Key? fieldKey;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.fieldKey,
    required this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
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
    if (mounted) {
      setState(() {
        _isFocused = _internalFocusNode.hasFocus;
      });
    }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final fieldBg = isDark
        ? (_isFocused ? const Color(0xFF131F37) : const Color(0xFF0C1424))
        : (_isFocused ? Colors.white : const Color(0xFFF3F6FA));

    final borderColor = isDark
        ? (_isFocused ? const Color(0xFF3B82F6) : const Color(0xFF1E293B))
        : (_isFocused ? AppTheme.primaryBlue.withValues(alpha: 0.7) : const Color(0xFFE5EDF7).withValues(alpha: 0.8));

    final prefixBg = isDark ? const Color(0xFF182744) : const Color(0xFFEBF2FD);
    final textCol = isDark ? const Color(0xFFF8FAFC) : AppTheme.lightTextPrimary;
    final hintCol = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return FormField<String>(
      key: widget.fieldKey,
      initialValue: widget.controller?.text ?? '',
      validator: (value) {
        final currentText = widget.controller != null ? widget.controller!.text : (value ?? '');
        return widget.validator?.call(currentText);
      },
      autovalidateMode: widget.autovalidateMode,
      builder: (FormFieldState<String> fieldState) {
        final hasError = fieldState.hasError && fieldState.errorText != null && fieldState.errorText!.isNotEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: hasError ? AppTheme.errorColor : borderColor,
                  width: hasError || _isFocused ? 1.8 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: hasError
                        ? AppTheme.errorColor.withValues(alpha: 0.08)
                        : (_isFocused
                            ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: isDark ? 0.2 : 0.02)),
                    blurRadius: _isFocused || hasError ? 12 : 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Custom Prefix Widget (e.g. Country Code Picker) or Icon Badge
                  if (widget.prefixWidget != null)
                    widget.prefixWidget!
                  else if (widget.prefixIcon != null)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: hasError ? AppTheme.errorColor.withValues(alpha: 0.08) : prefixBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.prefixIcon,
                        size: 18,
                        color: hasError ? AppTheme.errorColor : AppTheme.primaryBlue,
                      ),
                    ),

                  if (widget.prefixWidget != null || widget.prefixIcon != null)
                    const SizedBox(width: 10),

                  // Text Input Field
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _internalFocusNode,
                      obscureText: _obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onChanged: (val) {
                        fieldState.didChange(val);
                        widget.onChanged?.call(val);
                      },
                      onSubmitted: widget.onSubmitted,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: textCol,
                      ),
                      cursorColor: AppTheme.primaryBlue,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: hintCol,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                      ),
                    ),
                  ),

                  // Suffix eye icon for password
                  if (widget.isPassword)
                    IconButton(
                      splashRadius: 18,
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 19,
                        color: hasError ? AppTheme.errorColor : const Color(0xFF94A3B8),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                ],
              ),
            ),

            // Custom Error Message Underneath
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 1.5),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 13,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        fieldState.errorText!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.errorColor,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}


