import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class SpeedDialFab extends StatefulWidget {
  final List<SpeedDialChild> children;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;

  const SpeedDialFab({
    super.key,
    required this.children,
    this.icon = Icons.add,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  });

  @override
  State<SpeedDialFab> createState() => _SpeedDialFabState();
}

class _SpeedDialFabState extends State<SpeedDialFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Child buttons
        ...widget.children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          return SizeTransition(
            sizeFactor: _animation,
            axisAlignment: -1.0,
            child: FadeTransition(
              opacity: _animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Label
                    if (child.label != null)
                      Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: darkNavy,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          child.label!,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    // Child button
                    FloatingActionButton(
                      heroTag: 'speed_dial_child_$index',
                      mini: true,
                      backgroundColor: child.backgroundColor ?? orange,
                      onPressed: () {
                        child.onPressed();
                        _toggle();
                      },
                      child: Icon(
                        child.icon,
                        color: child.iconColor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        // Main button
        FloatingActionButton.extended(
          heroTag: 'speed_dial_main',
          onPressed: _toggle,
          backgroundColor: widget.backgroundColor ?? lightGrey,
          icon: AnimatedRotation(
            turns: _isOpen ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isOpen ? Icons.close : widget.icon,
              color: widget.iconColor ?? orange,
            ),
          ),
          label: Text(
            _isOpen ? '' : (widget.tooltip ?? ''),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: orange,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class SpeedDialChild {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final Color? backgroundColor;
  final Color? iconColor;

  const SpeedDialChild({
    required this.icon,
    required this.onPressed,
    this.label,
    this.backgroundColor,
    this.iconColor,
  });
}
