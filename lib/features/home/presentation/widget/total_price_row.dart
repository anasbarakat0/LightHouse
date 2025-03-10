import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TotalPriceRow extends StatelessWidget {
  final double totalPrice;

  const TotalPriceRow({
    super.key,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${"total_price".tr()}: ",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "${totalPrice.toStringAsFixed(0)} ${"s.p".tr()}",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.green),
          ),
        ],
      ),
    );
  }
}
