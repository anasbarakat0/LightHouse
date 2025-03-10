import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconTextWidget extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  const IconTextWidget(
      {super.key, required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/svg/$icon.svg",
          width: 23,
          height: 23,
          color: color,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(

            overflow: TextOverflow.clip
          ),
        ),
      ],
    );
  }
}
