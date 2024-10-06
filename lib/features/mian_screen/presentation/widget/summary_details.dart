import 'package:flutter/material.dart';
import 'package:light_house/features/mian_screen/presentation/widget/custom_cart.dart';

class SummaryDetails extends StatelessWidget {
  final String visits;
  final String onGround;
  const SummaryDetails(
      {super.key, required this.visits, required this.onGround});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: const Color(0xFF2F353E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildDetails('Visits', visits),
          buildDetails('on ground', onGround),
        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        Text(
          key,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
