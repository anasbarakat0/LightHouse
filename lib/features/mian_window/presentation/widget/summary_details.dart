import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/mian_window/presentation/widget/custom_cart.dart';

class SummaryDetails extends StatefulWidget {
  final String visits;
  final String onGround;
  const SummaryDetails(
      {super.key, required this.visits, required this.onGround});

  @override
  State<SummaryDetails> createState() => _SummaryDetailsState();
}

class _SummaryDetailsState extends State<SummaryDetails> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: lightGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildDetails('visits'.tr(), widget.visits),
          buildDetails('on_ground'.tr(), widget.onGround),
        ],
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return Column(
      children: [
        Text(
          key,
          style: const TextStyle(fontSize: 14, color: orange,fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
