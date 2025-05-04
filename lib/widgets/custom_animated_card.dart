import 'package:flutter/material.dart';

class CustomAnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const CustomAnimatedCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<CustomAnimatedCard> createState() => _CustomAnimatedCardState();
}

class _CustomAnimatedCardState extends State<CustomAnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: Listener(
        onPointerDown: (_) => _animationController.forward(),
        onPointerUp: (_) => _animationController.reverse(),
        onPointerCancel: (_) => _animationController.reverse(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 60, // Fixed height for consistency
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
