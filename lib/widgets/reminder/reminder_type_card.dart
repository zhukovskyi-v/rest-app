import 'package:breakly/models/reminder_type_option.dart';
import 'package:flutter/material.dart';

class ReminderTypeCard extends StatefulWidget {
  final ReminderTypeOption option;

  const ReminderTypeCard({super.key, required this.option});

  @override
  State<ReminderTypeCard> createState() => _ReminderTypeCardState();
}

class _ReminderTypeCardState extends State<ReminderTypeCard>
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
          onTap: () {
            // Handle reminder type selection
            print('Selected reminder type: ${widget.option.type}');
            // You can add navigation or other actions here
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.option.gradientColors,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(widget.option.icon, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Text(
                    widget.option.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
