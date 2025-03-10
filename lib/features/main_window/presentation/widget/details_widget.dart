import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

class DetailsWidget extends StatelessWidget {
  final String label;
  final int value;

  const DetailsWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 100,
      child:Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: darkNavy
                          ),
          ),
          const SizedBox(height: 2),
          Text(
            value.toString(),
            style:  Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: grey
                          ),
          ),
        ],
      ),
    );
  }
}
