import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Widget child;
  final BorderSide side;

  const MyButton({
    super.key,
    required this.onPressed,
    this.color = orange, 
    this.side = BorderSide.none, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: side
          ),
        ),
        child: child,
      ),
    );
  }
}
