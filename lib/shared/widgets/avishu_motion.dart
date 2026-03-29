import 'package:flutter/material.dart';

class AvishuMotion {
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration medium = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 320);
  static const Curve emphasis = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
}

class AvishuPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final double pressedOpacity;
  final EdgeInsets? padding;

  const AvishuPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.985,
    this.pressedOpacity = 0.92,
    this.padding,
  });

  @override
  State<AvishuPressable> createState() => _AvishuPressableState();
}

class _AvishuPressableState extends State<AvishuPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.padding == null
        ? widget.child
        : Padding(padding: widget.padding!, child: widget.child);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        duration: AvishuMotion.fast,
        curve: AvishuMotion.emphasis,
        scale: _pressed ? widget.pressedScale : 1,
        child: AnimatedOpacity(
          duration: AvishuMotion.fast,
          curve: AvishuMotion.emphasis,
          opacity: widget.onTap == null
              ? 0.48
              : _pressed
              ? widget.pressedOpacity
              : 1,
          child: child,
        ),
      ),
    );
  }
}

class AvishuReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset beginOffset;

  const AvishuReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.beginOffset = const Offset(0, 0.035),
  });

  @override
  State<AvishuReveal> createState() => _AvishuRevealState();
}

class _AvishuRevealState extends State<AvishuReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: AvishuMotion.slow,
      curve: AvishuMotion.emphasis,
      offset: _visible ? Offset.zero : widget.beginOffset,
      child: AnimatedOpacity(
        duration: AvishuMotion.medium,
        curve: AvishuMotion.emphasis,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}

Widget buildAvishuSwitcherTransition(
  Widget child,
  Animation<double> animation,
) {
  final curved = CurvedAnimation(
    parent: animation,
    curve: AvishuMotion.emphasis,
    reverseCurve: AvishuMotion.exit,
  );

  return FadeTransition(
    opacity: curved,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.03, 0),
        end: Offset.zero,
      ).animate(curved),
      child: child,
    ),
  );
}
