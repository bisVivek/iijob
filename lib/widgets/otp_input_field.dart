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

    // Attach key-event handlers for backspace navigation between boxes
    for (int i = 0; i < widget.length; i++) {
      final idx = i;
      _focusNodes[idx].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace) {
          if (_controllers[idx].text.isEmpty && idx > 0) {
            // Current box empty — clear previous box and move focus back
            _controllers[idx - 1].clear();
            _focusNodes[idx - 1].requestFocus();
            _notifyChanged();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length > 1) {
      // Paste / auto-fill: distribute digits across all boxes
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
        _controllers[i].selection = TextSelection.fromPosition(
          TextPosition(offset: _controllers[i].text.length),
        );
      }
      // Focus the last filled box or the first empty one
      final targetIdx =
          digits.length < widget.length ? digits.length : widget.length - 1;
      _focusNodes[targetIdx].requestFocus();
      _notifyChanged();
      return;
    }

    if (value.isNotEmpty) {
      // Normal single-digit entry: advance to next box
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    // If value is empty, the digit was deleted from this box.
    // Backspace on an already-empty box is handled by the key-event listener above.

    _notifyChanged();
  }

  void _notifyChanged() {
    final otp = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(otp);
    // Fire onCompleted only when every individual box has exactly one digit
    final allFilled = _controllers.every((c) => c.text.length == 1);
    if (allFilled) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final double boxWidth =
            ((totalWidth - (widget.length - 1) * 8) / widget.length)
                .clamp(36.0, 48.0);
        final double boxHeight = (boxWidth * 1.22).clamp(44.0, 56.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Container(
              margin: EdgeInsets.symmetric(
                horizontal:
                    index == 0 || index == widget.length - 1 ? 0 : 3.5,
              ),
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
                      color:
                          isFocused ? Colors.white : const Color(0xFFF3F6FA),
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
                            color:
                                AppTheme.primaryBlue.withValues(alpha: 0.15),
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
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) => _onChanged(val, index),
                        onTap: () {
                          // Tapping a filled box selects all so next keypress replaces it
                          _controllers[index].selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controllers[index].text.length,
                          );
                        },
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

