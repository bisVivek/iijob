import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste of full OTP code
      final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < widget.length; i++) {
        if (i < clean.length) {
          _controllers[i].text = clean[i];
        }
      }
      _checkCompletion();
      return;
    }

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _checkCompletion();
  }

  void _checkCompletion() {
    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        // Dynamically compute box size so it never overflows any screen
        final double boxWidth = ((totalWidth - (widget.length - 1) * 8) / widget.length).clamp(36.0, 48.0);
        final double boxHeight = (boxWidth * 1.22).clamp(44.0, 56.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: index == 0 || index == widget.length - 1 ? 0 : 3.5),
              width: boxWidth,
              height: boxHeight,
              child: AnimatedBuilder(
                animation: _focusNodes[index],
                builder: (context, child) {
                  final isFocused = _focusNodes[index].hasFocus;
                  final hasValue = _controllers[index].text.isNotEmpty;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isFocused ? Colors.white : const Color(0xFFF3F6FA),
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: isFocused
                            ? AppTheme.primaryBlue
                            : (hasValue
                                ? AppTheme.primaryBlue.withValues(alpha: 0.45)
                                : const Color(0xFFE5EDF7)),
                        width: isFocused ? 2.0 : 1.5,
                      ),
                      boxShadow: [
                        if (isFocused)
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Center(
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                        cursorColor: AppTheme.primaryBlue,
                        decoration: const InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) => _onChanged(val, index),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }
}
