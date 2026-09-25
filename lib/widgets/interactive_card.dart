import 'package:flutter/material.dart';

/// An interactive wrapper that adds smooth micro-scaling and press feedback.
class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.pressScale = 0.98,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed
              ? widget.pressScale
              : (_isHovered ? 1.012 : 1.0),
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: widget.child,
        ),
      ),
    );
  }
}
